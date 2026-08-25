# dotfiles

Personal dotfiles for Arch Linux (WSL2 + native), managed with GNU Stow.

Configs: Neovim (kickstart-based), Fish, WezTerm, FastFetch, Hyprland, Noctalia, mise.

---

## Quick start on a fresh WSL Arch install

```sh
git clone <this-repo> ~/Code/dotfiles
cd ~/Code/dotfiles
./bootstrap.sh --dry-run     # preview - changes nothing
./bootstrap.sh               # do it
```

Full walkthrough, including the Windows-side steps: **[docs/FRESH-INSTALL.md](docs/FRESH-INSTALL.md)**

---

## Bootstrap

`bootstrap.sh` is a tiny POSIX shim that installs fish (a fresh Arch box doesn't
have it), then hands off to `bootstrap.fish`, which does the real work in nine
idempotent phases.

| Phase | Action |
|---|---|
| `packages` | `pacman -S --needed` from `scripts/packages.txt` |
| `wslconf` | installs `/etc/wsl.conf` (automount `metadata` — required by the Salesforce CLI) |
| `stow` | symlinks `fish`, `nvim`, `fastfetch`, `mise` |
| `mise` | installs the java + node runtimes |
| `npm` | installs globals from `scripts/npm-globals.txt` |
| `omp` | installs oh-my-posh into `~/.local/bin` |
| `shell` | sets fish as the login shell |
| `git` | applies global git config |
| `verify` | asserts the resulting environment is sane |

### Options

```sh
./bootstrap.fish --dry-run          # print actions, change nothing
./bootstrap.fish --only stow        # run a single phase (repeatable)
./bootstrap.fish --skip packages    # skip a phase (repeatable)
./bootstrap.fish --force            # redo steps normally skipped when present
./bootstrap.fish --help
```

Every phase is **idempotent** — running it twice is safe and mostly a no-op.

### Safety behaviour

- **`--dry-run` first.** Nothing is executed; each action is printed instead.
- **`/etc/wsl.conf` is never blind-overwritten.** If it exists and differs, the
  script prints a diff and leaves it alone unless you pass `--force`.
- **Stow conflicts are backed up, not clobbered.** A pre-existing real
  `~/.config/<pkg>` is moved to `<pkg>.pre-stow.<timestamp>` before linking.
- **No hardcoded username.** `/etc/wsl.conf` is rendered from
  `scripts/wsl.conf.template` using `whoami` at run time.

### What it does NOT do

- Create the WSL distro or your user account
- Run `wsl --shutdown` for you after `/etc/wsl.conf` changes
- Authenticate Salesforce orgs (`sf org login web`)
- Set your git identity (`user.email`)
- Generate SSH keys or log into GitHub
- Install Windows-side apps (WezTerm, Neovim for Windows, Nerd Fonts)

---

## Data files

Edit these rather than the script:

| File | Purpose |
|---|---|
| `scripts/packages.txt` | pacman packages (`#` comments allowed) |
| `scripts/npm-globals.txt` | global npm packages |
| `scripts/wsl.conf.template` | `/etc/wsl.conf`, `__USER__` is substituted |
| `scripts/lib.fish` | shared logging / dry-run / package helpers |

Check for drift between the declared list and what's actually installed:

```sh
diff (fish -c 'source scripts/lib.fish; read_list scripts/packages.txt' | sort | psub) (pacman -Qqe | sort | psub)
```

---

## GNU Stow

[GNU Stow](https://www.gnu.org/software/stow/) symlinks each top-level folder
into `~/`. Files mirror the home layout, e.g.
`wezterm/.config/wezterm/wezterm.lua` → `~/.config/wezterm/wezterm.lua`.

```sh
stow wezterm       # link
stow -D wezterm    # unlink
stow -n wezterm    # dry run
```

Stowed by bootstrap in WSL: `fish`, `nvim`, `fastfetch`, `mise`.

**Not** stowed in WSL — `wezterm` (runs on the Windows host), `hypr` and
`noctalia` (Wayland/GUI, no compositor in WSL). Stow those by hand on a native
Linux desktop.

> **`.stowrc` contains hardcoded absolute paths** (`--target` / `--dir`) and only
> works for the user it was written for. `bootstrap.fish` ignores it and passes
> `--target`/`--dir` explicitly, so bootstrapping works under any username.
> Update `.stowrc` if you invoke `stow` manually on a different machine.

---

## WSL notes

Two non-obvious things that cost real debugging time:

1. **`/mnt/c` needs the `metadata` mount option**, set via
   `[automount] options="metadata,umask=22,fmask=11"` in `/etc/wsl.conf`.
   Without it every file under `/mnt/c` is mode `777`, and the Salesforce CLI
   refuses to read `~/.sfdx/key.json` with *"Invalid file permissions for secret
   file"*.

2. **WSL has no D-Bus secret service**, so `libsecret`/`secret-tool` fails with
   *"The name is not activatable"* and the Salesforce CLI cannot decrypt any auth
   file. `config.fish` exports `SF_USE_GENERIC_UNIX_KEYCHAIN=true` to force the
   CLI's file-based keychain. The `verify` phase asserts this is present.

Also note WSL and Windows have **separate home directories**. Auth done in
Windows (`C:\Users\<you>\.sfdx`) is invisible to WSL. Run `sf org login web`
from inside WSL.

---

## Neovim

Built on kickstart.nvim. See `.github/copilot-instructions.md` for the full
architecture notes (plugin layout, LSP, formatting, Salesforce integration).

Requires Neovim 0.11+ (`salesforce.lua` uses `vim.lsp.config()` / `vim.lsp.enable()`).

## Lua formatting

```sh
stylua --check nvim/   # lint
stylua nvim/           # format
```
