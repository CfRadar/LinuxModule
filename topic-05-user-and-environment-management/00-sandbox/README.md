# Topic 05 Sandbox — User and Environment Management

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `whoami` — Print the effective username of the current user.
- `who` — Show who is currently logged in and on which terminal.
- `id` — Display real and effective user IDs (`uid`), primary group (`gid`), and supplementary groups.
- `users` — Print a space-separated list of usernames currently logged in to the host.
- `groups` — Print the group memberships for the current user or a specified username.
- `su` — Switch user identity (use `su - <user>` for a full login shell and clean environment).
- `sudo` — Execute a permitted command as another user according to `sudoers` policy.
- `env` — Print exported environment variables or run a command in a modified/clean (`env -i`) environment.
- `printenv` — Print all exported environment variables or the value of specific named variables.
- `export` — Mark shell variables for export to child processes as environment variables.
- `unset` — Remove shell variables or functions from the current shell environment.
- `alias` — Define or display command shortcuts expanded by interactive Bash shells.
- `unalias` — Remove one (`unalias name`) or all (`unalias -a`) defined aliases.

## Things to Try

1. Set `LOCAL_DEMO=one` and `export GLOBAL_DEMO=two`, then run `bash -c 'printenv LOCAL_DEMO; printenv GLOBAL_DEMO'` to see what child shells inherit.
2. Test `env -i PATH="$PATH" HOME="$PWD/files/mock_home" bash -lc 'echo "$HOME"; alias'` to explore an isolated startup environment without touching your real `~/.bashrc`.
3. Source `files/mock_home/.bashrc` in a subshell with `shopt -s expand_aliases` and practice `alias`, `\cmd`, and `unalias`.
4. Inspect `files/sample.env` and compare `unset VAR` vs `VAR=""` using `${VAR+set}` and `printenv`.
5. Review `files/sudoers_sample.txt` to see how `Defaults env_reset`, `env_keep`, and `secure_path` control escalation environments.
