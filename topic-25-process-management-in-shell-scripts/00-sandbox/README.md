# Topic 25 Sandbox — Process Management in Shell Scripts

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `&` — Run a command or subshell asynchronously in the background.
- `$$` — PID of the original shell process (does not change inside `(...)` subshells).
- `$BASHPID` — PID of the current executing Bash process (changes inside `(...)` subshells).
- `$!` — PID of the most recently launched background process.
- `wait` — Wait for all or specific background PIDs and return their exit status.
- `exec` — Replace the current shell process with a command, or apply permanent FD redirections.
- `trap` — Register a command or function to run when a signal or shell pseudo-signal (`EXIT`, `RETURN`, `ERR`) fires.
- `(...)` — Execute commands in an isolated subshell (variable and directory changes stay local).
- `{ ...; }` — Group commands in the current shell without spawning a subshell.
- `kill` — Send a signal (such as `TERM`, `INT`, `HUP`, or `0` to probe existence) to a PID.

## Things to Try

1. Compare `echo "main: $$ / $BASHPID"` with `( echo "sub: $$ / $BASHPID" )`.
2. Launch `bash files/mock_worker.sh taskA 0.2 0 &` and immediately inspect `$!`, then run `wait "$!" ; echo $?`.
3. Run two workers in parallel, one exiting `0` and one exiting `3`, and compare `wait` (no args) vs `wait "$pid1"; echo $?; wait "$pid2"; echo $?`.
4. Test `bash files/signal_probe.sh` in the background and send it `kill -TERM "$!"` to observe its `trap` handler.
5. Run `( x=changed; cd /tmp ) ; echo "$x $PWD"` vs `{ x=changed; } ; echo "$x"` to see subshell isolation.
