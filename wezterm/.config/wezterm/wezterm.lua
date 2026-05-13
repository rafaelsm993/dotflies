local wezterm = require("wezterm");

local config = wezterm.config_builder();

config = {
    automatically_reload_config = true,
    enable_tab_bar = true,
    use_fancy_tab_bar = false,
    tab_bar_at_bottom = true,
    window_close_confirmation = "NeverPrompt",
    window_decorations = "RESIZE",
    font_size = 14,
    line_height = 1.2,
    -- Appearance
    cursor_blink_rate = 0,
    -- config.window_decorations = 'RESIZE'
    hide_tab_bar_if_only_one_tab = true,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0
    },
    window_background_opacity = 1.0,
    color_scheme = "Tokyo Night",

    -- Miscellaneous settings
    max_fps = 120,
    prefer_egl = true,

    keys = {
        {
            key = "R",
            mods = "CTRL|SHIFT",
            action = wezterm.action.PromptInputLine {
                description = "Enter new tab name",
                action = wezterm.action_callback(function(window, _, line)
                    if line then
                        window:active_tab():set_title(line)
                    end
                end),
            },
        },
    },

}

return config;
