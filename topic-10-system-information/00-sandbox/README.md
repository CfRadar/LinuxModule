# Topic 10 Sandbox — System Information

Open sandbox for free experimentation in a Linux/WSL2 environment. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `uname` — Print kernel and system architecture information (`-s` kernel name, `-r` kernel release, `-m` machine hardware, `-v` kernel version, `-a` all).
- `hostname` — Show or inspect the system hostname (`-s` short hostname, `-f` FQDN, `-i` / `-I` IP addresses).
- `uptime` — Show how long the system has been running, logged-in users, and load averages (`-p` pretty, `-s` boot timestamp).
- `date` — Display or format the system date and time (`-u` UTC, `-d` parse date/epoch string, `'+%s'` Unix epoch seconds).
- `cal` — Display a calendar for a month or year (`LC_ALL=C cal 2 2024`, `cal -y 2025`).
- `free` — Display amount of free and used memory and swap in the system (`-k` KiB, `-m` MiB, `-h` human-readable; focus on `available`, not `free`).
- `df` — Report filesystem disk space and inode usage (`-P` POSIX format, `-T` filesystem type, `-i` inodes, `-h` human-readable).
- `du` — Estimate file and directory space usage (`-s` summary, `-k` KiB, `-B1` bytes, `--apparent-size`, `--max-depth=1`, `--exclude`).
- `lsblk` — List block devices and mount hierarchies (`-P` `KEY="VALUE"` pairs, `-J` JSON, `-o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE`).
- `lscpu` — Display CPU architecture, socket, core, and thread topology (`LC_ALL=C lscpu`).

## Things to Try

1. Compare `uname -s`, `uname -r`, `uname -m`, and `uname -a`, and inspect `/etc/os-release`.
2. Run `hostname -s` vs `hostname -f`, and compare `date '+%Y-%m-%d %H:%M:%S %Z'` with `date -u '+%Y-%m-%dT%H:%M:%SZ'`.
3. Convert a Unix epoch to UTC with `date -u -d '@1700000000' '+%Y-%m-%d %H:%M:%S'` and compute `uptime -s` epoch with `date -d "$(uptime -s)" '+%s'`.
4. Run `LC_ALL=C cal 2 2024` vs `LC_ALL=C cal 2 2025` to observe leap-year February calendars.
5. Compare `free -m` on your live system with `files/free_sample.txt` and notice the difference between `free` and `available` memory.
6. Inspect `files/df_sample.txt` and `files/lsblk_pairs.txt`, and compare `df -PT` vs `df -Pi` on your live system.
7. Create a sparse file in `files/` using `truncate -s 10M files/sparse.bin` and compare `du -B1 files/sparse.bin` with `du -B1 --apparent-size files/sparse.bin`.
