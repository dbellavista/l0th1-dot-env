# Integrations with optional tools: each one only loads if the tool is installed.

(( $+commands[atuin] )) && eval "$(atuin init zsh --disable-up-arrow)"
