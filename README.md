# l0th1-dot-env

My zsh and vim setup, deployed to every machine I use: laptops, desktops,
servers, and (vim only) Windows.

- **This repo (public):** the base config, general functions, OS and profile layers, and the `l0th1` tool.
- **Overlays (private, optional):** one repo per trust domain. Each machine clones only the ones it should have:
  - `l0th1-dot-env-personal`: personal machines
  - `l0th1-dot-env-identifai`: IdentifAI machines (work laptop, work servers)

  An overlay that isn't cloned on a machine has none of its code on that machine's disk.
- **Each machine (in no repo):** its identity in `~/.config/l0th1/machine.zsh`, and secrets or one-off tweaks in `~/.config/l0th1/local/`.

## Layers

Config is built from layers. Each one is an optional directory, and later layers win:

```
public   zsh/core
public   zsh/os/<darwin|linux>
public   zsh/profiles/<profile>          for each profile in L0TH1_PROFILES
overlay  zsh/common                     \
overlay  zsh/profiles/<profile>          > for each overlay in L0TH1_OVERLAYS, in order
overlay  zsh/hosts/<L0TH1_HOST>          /
machine  ~/.config/l0th1/local
```

A layer directory can contain:

| Path | What happens |
|---|---|
| `functions/<name>` | autoloaded function (file body = function body). Same name in a later layer **replaces** it. `_name` files are completions. |
| `bin/<name>` | executable put on PATH. Use this instead of a function for long-running jobs, or anything called from scripts, `nohup` or `sudo`. A later layer wins. |
| `plugins.txt` | [antidote](https://github.com/mattmc3/antidote) bundle lines; all layers are merged into one static bundle, rebuilt only when the list changes |
| `*.zsh` | sourced in lexical order, after every layer's functions are available |

Vim follows the same idea: `vim/core/*.vim`, then
`<overlay>/vim/{common,profiles/<p>,hosts/<host>}/*.vim` (each may also have a
`plugins.vim` with extra `Plug` lines), then `~/.vimrc.local`.

### Profiles

| Profile | For | Adds |
|---|---|---|
| `desktop` | personal workstations | gpg-agent as SSH agent (not inside SSH sessions), autojump, vscode |
| `dev` | anywhere I write code | python/pip/rust/... OMZ plugins, `i`/`itest`/`gfpush`; vim YouCompleteMe, ALE, jsdoc (these need build tools) |
| `server` | headless boxes | base only |
| `android` | *(identifai overlay)* | scrcpy/adb helpers |

Overlays can also add to existing profiles. For example, the identifai overlay's
`profiles/desktop` adds the AWS/jump-host helpers, but only on machines that have that overlay.

A profile name works if a directory exists for it in the public repo or any enabled overlay.

## Install

New machine (zsh and git required):

```sh
git clone https://github.com/dbellavista/l0th1-dot-env.git ~/.local/share/l0th1/public
# overlays: only the ones this machine should have
git clone git@github.com:dbellavista/l0th1-dot-env-personal.git  ~/.local/share/l0th1/personal
git clone git@github.com:dbellavista/l0th1-dot-env-identifai.git ~/.local/share/l0th1/identifai

~/.local/share/l0th1/public/bin/l0th1 install --host <name> --profiles "desktop dev" --overlays "personal"
```

`install`:

- writes `~/.config/l0th1/machine.zsh`
- puts a small managed block in `~/.zshrc`. Lines that other tools append below it stay on that machine.
- links `~/.vim` to `vim/` and `~/.local/bin/l0th1` to `bin/l0th1`
- on first vim install, runs `:PlugInstall`

Anything it replaces is moved to `~/.local/state/l0th1/backups/<timestamp>/`. Running it again is safe.

`--overlays` takes names or paths. A name is looked up next to the public repo
(`../<public-dir>-<name>`, `../l0th1-dot-env-<name>`) and in
`~/.local/share/l0th1/<name>`. Overlays are **never enabled automatically**.
Install only lists the ones it finds on disk, so cloning a repo by mistake doesn't
load its code. `--overlays none` disables all of them.

Typical machines:

| Machine | `--overlays` |
|---|---|
| personal desktop / Mac mini | `personal` |
| IdentifAI laptop | `identifai` (plus `personal` if you want it there) |
| work servers | `identifai` |

Keep access separate as well: personal machines should have no key or token that
can read the identifai repo. Use per-machine deploy keys or a separate SSH key.

### Windows (vim only)

```bat
git clone https://github.com/dbellavista/l0th1-dot-env.git %USERPROFILE%\l0th1-dot-env
echo source ~/l0th1-dot-env/vim/vimrc> %USERPROFILE%\_vimrc
vim +PlugInstall +qa
```

The vimrc adds itself to `runtimepath` and keeps plugins/undo in
`%LOCALAPPDATA%\vim`. Set profiles with `let g:l0th1_profiles = ['dev']` above
the `source` line. Machine-only settings go in `~/_vimrc.local`.

## Updating

| Command | Does |
|---|---|
| `l0th1 update` | `git pull --ff-only` both repos, refresh the `~/.zshrc` block and links |
| `l0th1 update --plugins` | also `antidote update` and `:PlugUpdate` |
| `l0th1 push-all` | runs `l0th1 update` over SSH on every host listed in the enabled overlays' `machines.txt` (`--dry-run`, `--forward-agent`) |
| `l0th1 status` / `l0th1 doctor` | machine identity and repo state / installation checks |

Shells notice upstream changes by themselves: a background `git fetch` runs at
most once a day and the next shell prints
`l0th1: N new commit(s) upstream - run l0th1 update`. Updates are never applied
automatically, because these files run as code in every shell. Turn the notice off with
`L0TH1_UPDATE_CHECK=0` in `machine.zsh`.

Typical flow: edit here, commit, push, then `l0th1 push-all` (or let each
machine show the notice).

## Zellij

The public repo and each overlay can have a `zellij/` folder:

```
zellij/config.kdl          base config (public repo only): settings only, no keybinds dump,
                           so every zellij version uses its own default keybindings
zellij/themes/<name>.kdl   colour schemes (gothic here; identifai, identifai-blue in the
                           identifai overlay; blood in the personal overlay)
zellij/layouts/<name>.kdl  layouts, started with `zellij --layout <name>`
zellij/<other>.kdl         any other file, e.g. an extra config used with --config
```

`l0th1 install`/`update` link every `*.kdl` into `~/.config/zellij/` (later
repos win) and generate `~/.config/zellij/config.kdl`: the base config plus
this machine's default theme. Links from a repo or overlay you remove are
cleaned up, and a `config.kdl` changed outside l0th1 (e.g. by zellij's
settings screen) is backed up before it is replaced.

| Command | Does |
|---|---|
| `l0th1 zellij-theme` | show this machine's theme and the themes available |
| `l0th1 zellij-theme gothic` | set it (saved in `machine.zsh`). Running sessions switch live. |
| `l0th1 zellij-theme none` | back to zellij's default |

A theme passed on the command line (`zellij options --theme X`) only applies
when a session is *created*. Attaching to an existing session ignores it. The
config file theme, on the other hand, is reloaded live.

## Commands

These live in `zsh/core/bin/` and are on PATH on every machine. Run any of them with `-h` for help.

| Command | Does |
|---|---|
| `rm_throttled [-b N] [-s SEC] [-r RATE] [-n] [-y] DIR` | Deletes a huge tree in small batches, at idle I/O priority. Has a dry run and asks for confirmation. Refuses `/`, top-level dirs and `$HOME`. |
| `tar_throttled [-r RATE] [-V] ARCHIVE SOURCE` | Creates a `.tar`/`.tar.gz`/`.tar.zst` while capping the read rate with `pv`. Writes to `ARCHIVE.partial` and renames it only after the archive is complete and synced to disk. |

## Testing

```sh
test/linux-smoke.sh            # fresh Debian container: server + desktop/dev installs, zsh, vim, commands
test/throttled-tools.zsh       # rm_throttled / tar_throttled, on this machine (macOS or Linux)
```

## Layout

```
bin/l0th1                 install/update/status/doctor/push-all
zsh/zshrc                entrypoint (layer loader)
zsh/core/                options, PATH, plugins (antidote), tools, update notice, base functions
zsh/os/<darwin|linux>/   OS-specific PATH, Homebrew, aliases
zsh/profiles/            desktop/, dev/, server/
vim/vimrc                entrypoint
vim/core/                options, plugins, ui, editing, filetypes, commands
vim/{autoload,colors,keymap}/
zellij/                  base config, themes, layouts (see Zellij)
```
