# Topic 09 Sandbox — Process and Job Management

Open sandbox for free experimentation in a Linux/WSL2 environment. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `ps` — Report a snapshot of current processes (`ps aux`, `ps -ef`, `ps -eo pid,ppid,ni,stat,comm,args`).
- `top` — Display real-time or batch (`top -b -n 1`) process CPU, memory, and load-average telemetry.
- `htop` — Interactive process viewer with tree view (`F5` / `-t`) and signal/nice controls.
- `pgrep` — Look up process PIDs by name or full command line (`-f`, `-a`, `-P <ppid>`).
- `pkill` — Send signals to processes matched by name or pattern (`pkill -TERM -f ...`).
- `kill` — Send a specific signal (`-TERM`, `-KILL`, `-HUP`, `-USR1`, `-STOP`, `-CONT`, or `-0` to probe) to a PID or job spec.
- `killall` — Send a signal to all processes running a given exact command name.
- `jobs` — List active and stopped background jobs in the current shell (`jobs -l`, `jobs -p`).
- `bg` — Resume a stopped job in the background (`bg %1`).
- `fg` — Bring a background or stopped job to the foreground (`fg %1`).
- `nohup` — Run a command immune to `SIGHUP`, redirecting output when stdout/stderr are not redirected.
- `wait` — Block until background child PIDs finish and return their exit status (prevents zombie processes).
- `nice` — Launch a command with an adjusted scheduling niceness (`-20` highest to `19` lowest; unprivileged users can only increase niceness).
- `renice` — Alter the scheduling priority of an already-running process (`renice -n 10 -p <pid>`).

## Things to Try

1. Run `ps -eo pid,ppid,ni,stat,comm` and trace your own shell's `PPID` chain up to PID `1`.
2. Start `bash files/worker_loop.sh 15 &`, inspect it with `jobs -l` and `pgrep -af worker_loop`, then stop it with `kill -TERM %1`.
3. Test `set -m` in a subshell: start `sleep 10 &`, send `kill -STOP %1`, check `jobs`, resume with `bg %1`, and `kill %1`.
4. Launch `nohup bash files/worker_loop.sh 5 > /tmp/w.log 2>&1 &` and observe how redirecting stdout/stderr prevents `nohup.out` creation.
5. Run `nice -n 12 sleep 4 &` and verify its `NI` column using `ps -o pid,ni,comm -p $!`.
6. Parse `files/sample_ps.txt` with `awk` to list all processes in `Z` (zombie) or `T` (stopped) state.
