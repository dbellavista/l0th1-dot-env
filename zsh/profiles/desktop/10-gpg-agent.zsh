# Use gpg-agent as the SSH agent on workstations. Skipped inside SSH sessions
# so a forwarded agent is never overridden.
if [[ -z $SSH_CONNECTION ]] && (( $+commands[gpgconf] )); then
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
fi
