# Copilot Instructions

## Repository Overview

Personal dotfiles for **kanoah** targeting both CachyOS Linux and Windows environments. Contains configurations for: Neovim, Fish shell, FastFetch, WezTerm, PowerShell, and VS Code.

## GNU Stow

[GNU Stow](https://www.gnu.org/software/stow/) manages symlinks from this repo into `~/` (home directory). `.stowrc` is pre-configured so all commands work from the repo root without extra flags.

```bash
stow wezterm       # symlink a package
stow -D wezterm    # remove symlinks
stow -n wezterm    # dry run
```

**Package directory structure**: each top-level folder is a stow package. Files must be nested to mirror `~/`. For example:
- `wezterm/.config/wezterm/wezterm.lua` → `~/.config/wezterm/wezterm.lua`
- `Code/User/settings.json` → `~/.config/Code/User/settings.json` (VS Code on Linux)

Currently stowed: `wezterm`, `Code`.  
**Not yet stowed**: `nvim/`, `fish/`, `fastfetch/` — their contents live directly in `~/.config/` as real directories (not symlinked). To stow them, nest files under `<package>/.config/<name>/` then run `stow <package>`.

## Lua Formatting (Neovim config)

All Lua files are formatted with **stylua** using `nvim/.config/nvim/.stylua.toml`:
- 2-space indentation, 160 column width
- Single quotes preferred (`AutoPreferSingle`)
- No call parentheses (`call_parentheses = "None"`)
- Collapsed simple statements (`collapse_simple_statement = "Always"`)

```bash
stylua --check nvim/   # lint
stylua nvim/           # format in-place
```

## Neovim Architecture

Built on **kickstart.nvim**. The config is split across:
- `nvim/.config/nvim/init.lua` — single file with all core options, keymaps, and plugin specs
- `nvim/.config/nvim/lua/kickstart/plugins/` — optional kickstart extras (all commented out in `init.lua`; uncomment to enable)
- `nvim/.config/nvim/lua/custom/plugins/` — user plugins; every `.lua` file here is auto-imported by lazy.nvim and must return a `LazySpec` table

**Plugin manager**: lazy.nvim  
**LSP**: nvim-lspconfig + Mason (`lua_ls` enabled; `lua_ls` formatting disabled — stylua handles it)  
**Formatter**: conform.nvim — `<leader>f` to format manually; auto-format on save is opt-in per filetype via the `enabled_filetypes` table in `init.lua`  
**Completion**: blink.cmp + LuaSnip + blink-copilot (Copilot inline suggestions via ghost text)  
**Fuzzy finder**: Telescope (`enabled` flag in init.lua can swap it for snacks/fzf-lua)  
**File manager**: yazi.nvim (`<leader>-` to open, `<c-up>` to toggle)  
**AI**: CopilotChat.nvim (`claude-opus-4.7`), keys under `<leader>c*`

### Adding an LSP server

Add the Mason tool name to the `servers` table in `init.lua`. For servers with Mason name mismatches (e.g., `apex_ls`), configure manually in a custom plugin using `nvim-lspconfig` with `optional = true` and `init` (not `config`) to avoid overriding kickstart's lspconfig setup.

### Adding a formatter

Add the formatter under `conform.nvim`'s `formatters_by_ft` table in `init.lua`. To enable auto-format on save for a filetype, add it to the `enabled_filetypes` table in the `format_on_save` function.

## Key Neovim Conventions

- Leader key: `<space>`
- New plugins go in `lua/custom/plugins/<name>.lua` and must return a `LazySpec` table
- Use `opts = {}` shorthand instead of `config = function() require('X').setup({}) end` when no extra logic is needed
- Annotate `opts` with `---@module 'X'` and `---@type X.Config` for LSP type checking
- Background is transparent (Normal bg = none, set via autocommand on ColorScheme in `init.lua`)
- Augroup names: `kickstart-*` prefix for built-ins; use a distinct prefix for custom groups
- When extending a plugin already defined in `init.lua` (e.g., blink.cmp, nvim-treesitter), use `optional = true` in the custom plugin spec and merge with `opts` functions

## Salesforce Plugin

`lua/custom/plugins/salesforce.lua` and `salesforce_sf.lua` provide Apex/LWC development support:
- Filetype detection for `.cls`, `.trigger`, `.apex` → `apex` filetype
- `apex_ls` LSP via Mason (requires Java; Mason name is `apex-language-server`)
- prettier formatting for LWC/Aura files (JS, HTML, CSS, XML) via conform.nvim

## Copilot Inline Completions

`lua/custom/plugins/copilot.lua` wires `zbirenbaum/copilot.lua` + `blink-copilot` into blink.cmp.  
**Node version constraint**: requires Node 24 specifically (not 26). Managed via `mise use --global node@24`.

## Shell / Prompt

- **Fish** (`fish/.config/fish/config.fish`): sources CachyOS base config, activates `mise`, then initializes oh-my-posh with the `catppuccin_mocha` theme fetched from the upstream URL
- **PowerShell** (`PowerShell/Microsoft.PowerShell_profile.ps1`): UTF-8 encoding, FastFetch on startup, WinGet CommandNotFound module

## Color Theme

**Catppuccin Mocha** is used consistently across FastFetch, oh-my-posh, and bufferline. **Tokyo Night** (night variant) is used for WezTerm and Neovim's colorscheme; bufferline derives its palette programmatically from `tokyonight.colors`.

## WezTerm

Tracked at `wezterm/.config/wezterm/wezterm.lua`. Key settings:
- **Color scheme**: `"Tokyo Night"` (matches Neovim's tokyonight-night)
- **Font size**: 14, **line height**: 1.2
- **Tab bar**: plain style (`use_fancy_tab_bar = false`), positioned at bottom, hidden when only one tab open
- **Window**: no decorations except resize handle (`RESIZE`), zero padding, `window_close_confirmation = "NeverPrompt"`
- **Performance**: `max_fps = 120`, `prefer_egl = true`, static cursor (`cursor_blink_rate = 0`)
- **Custom keymap**: `Ctrl+Shift+R` prompts to rename the current tab

## FastFetch

Config at `fastfetch/config.jsonc`. The logo source path is hardcoded to a Windows path (`C:/Users/kanoah/.config/fastfetch/ascii.txt`) — update for Linux use.
