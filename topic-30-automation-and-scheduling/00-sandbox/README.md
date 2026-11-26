# Topic 30 Sandbox — Automation and Scheduling

Open sandbox for free experimentation in a Linux/WSL2 environment. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`. Never modify system crontabs (`/var/spool/cron` or `/etc/cron*`); use the local staging files in `files/` instead.

## Command Quick Reference

- `crontab` — View (`-l`), install from a file (`crontab file`), or remove (`-r`) user cron tables using 5-field syntax (`min hour dom month dow cmd`) or `@daily`/`@hourly`/`@weekly`/`@monthly`/`@reboot`.
- `at` — Schedule a one-shot command read from stdin (`echo "cmd" | at 14:30`, `at -f script.sh now + 15 minutes`, `at teatime`); inspect queue with `atq` and remove with `atrm`.
- `watch` — Execute a command periodically (`-n <seconds>` interval, `-d` highlight differences, `-e` exit on non-zero status, `-g` exit on output change).
- `flock` — Manage advisory file locks from shell scripts (`flock -n /tmp/job.lock -c '...'`) to prevent overlapping cron runs.
- `tar` — Create and verify compressed archives (`tar -czf`, `tar -tzf`, `tar -xzf`) for automated rotating backups.
- `date` — Format timestamps (`date +%Y%m%d_%H%M%S`) and compute relative times (`date -u -d 'now + 15 minutes'`); escape `%` as `\%` inside crontab lines.

## Things to Try

1. Inspect `files/sample.crontab` and spot unescaped `%` characters, relative command paths, and lines where both day-of-month and day-of-week are non-`*`.
2. Test non-blocking locking with `flock -n files/demo.lock -c 'sleep 1; echo acquired'` in overlapping background subshells (`&`).
3. Practice relative time calculations with `date -u -d` against the expressions in `files/at_specs.txt`.
4. Simulate a `watch -n 1 -d` polling loop in Bash over `files/metrics.log` while appending new lines.
5. Practice byte-offset and inode tracking (`stat -c '%i %s' files/app.log` and `tail -c +<offset> files/app.log`).
6. Test `find files/dropzone -type f -mmin +10` and safe handling of spaces in filenames.
