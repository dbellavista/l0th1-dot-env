# PATH is managed as the `path` array; -U drops duplicates (first one wins).
# The (N/) qualifier only adds directories that exist on this machine.
typeset -gU path fpath

path=(
  $HOME/.local/bin(N/)
  $HOME/.atuin/bin(N/)
  $path
  $HOME/.cargo/bin(N/)
)

# Extra completion dirs (compinit runs on the first prompt, via use-omz).
fpath=( $HOME/.docker/completions(N/) $fpath )
