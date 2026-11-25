# OMZ's autojump plugin complains if autojump is missing, so only load it when installed.
(( $+commands[autojump] )) && [[ -r $ZSH/plugins/autojump/autojump.plugin.zsh ]] &&
  source $ZSH/plugins/autojump/autojump.plugin.zsh

# Prefer the `jc` JSON tool over autojump's jc (jump to child dir).
(( $+commands[jc] && $+functions[jc] )) && unfunction jc
