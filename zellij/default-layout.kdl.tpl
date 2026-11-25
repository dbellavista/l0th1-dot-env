// Template for the default layout (zellij loads layouts/default.kdl when no
// --layout is given). `l0th1` fills in the @...@ colours from the machine's
// zellij theme and writes ~/.config/zellij/layouts/default.kdl.
// Same as the stock layout, except the top bar is zjstatus (installed by
// `l0th1` into ~/.config/zellij/plugins/) so the label reads
// "<hostname> (<session>)" instead of "Zellij (<session>)".
layout {
    default_tab_template {
        pane size=1 borderless=true {
            plugin location="file:~/.config/zellij/plugins/zjstatus.wasm" {
                format_left   "#[@BAR@,bold] {command_host} ({session}) #[@BAR@]{tabs}"
                format_right  "#[@BAR@]{mode}"
                format_space  "#[@BAR@]"

                hide_frame_for_single_pane "false"

                mode_normal  ""
                mode_locked  "#[@ACTIVE@] LOCKED "
                mode_pane    "#[@ACTIVE@] PANE "
                mode_tab     "#[@ACTIVE@] TAB "
                mode_resize  "#[@ACTIVE@] RESIZE "
                mode_move    "#[@ACTIVE@] MOVE "
                mode_scroll  "#[@ACTIVE@] SCROLL "
                mode_search  "#[@ACTIVE@] SEARCH "
                mode_session "#[@ACTIVE@] SESSION "
                mode_tmux    "#[@ACTIVE@] TMUX "

                tab_normal   "#[fg=@BARBG@,bg=@TABBG@]#[@TAB@] {name} #[fg=@TABBG@,bg=@BARBG@]#[@BAR@]"
                tab_active   "#[fg=@BARBG@,bg=@ACTBG@]#[@ACTIVE@] {name} #[fg=@ACTBG@,bg=@BARBG@]#[@BAR@]"

                command_host_command  "hostname -s"
                command_host_format   "{stdout}"
                command_host_interval "3600"
            }
        }
        children
        pane size=2 borderless=true {
            plugin location="zellij:status-bar"
        }
    }
}
