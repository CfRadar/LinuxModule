# Topic 11 Sandbox — Networking Commands

Open sandbox for free experimentation in a Linux/WSL2 environment. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `ip` — Show or manipulate routing, network devices, and addresses (`ip -br addr`, `ip -4 addr show dev lo`, `ip route`).
- `ifconfig` — Legacy interface configuration and counter inspection (`ifconfig lo`).
- `ping` — Send ICMP ECHO_REQUEST packets to test IPv4/IPv6 reachability (`ping -c 3 -W 1 127.0.0.1`, `ping -6 -c 2 ::1`).
- `traceroute` — Print the route packets take to a network host, showing hop RTTs and `* * *` timeouts.
- `ss` — Inspect sockets (`ss -tlnp` for listening TCP, `ss -uln` for UDP, `ss -H` to omit header).
- `netstat` — Legacy socket and routing table viewer (`netstat -tulnp`).
- `nc` — Netcat TCP/UDP Swiss-army knife (`nc -z -w 1 127.0.0.1 8080` for port probing, `nc -l` for listening).
- `nslookup` — Interactive or one-shot DNS query utility (`nslookup -port=5353 example.local 127.0.0.1`).
- `dig` — Detailed DNS lookup utility (`dig @127.0.0.1 -p 5353 +short example.local A`).
- `host` — Concise DNS lookup utility (`host -p 5353 example.local 127.0.0.1`).
- `curl` — Transfer data from or to a server over HTTP/HTTPS (`curl -sS -f`, `-i`, `-X POST`, `--data-urlencode`).
- `wget` — Non-interactive network downloader (`wget -q -O`, `-P`, `--spider`, `-r -np -nH`).
- `ssh` — OpenSSH remote login client and config inspector (`ssh -F config -G alias`).
- `scp` — Secure copy over SSH (`scp -P 2222 -p file user@host:/dir/`).
- `sftp` — Interactive or batch (`sftp -b batch.txt`) file transfer over SSH.
- `rsync` — Fast incremental file transfer (`rsync -a --delete --exclude='*.tmp' src/ dst/`).

## Things to Try

1. Inspect loopback addresses with `ip -br addr show dev lo` and `ping -c 2 127.0.0.1` / `ping -6 -c 2 ::1`.
2. Start the local HTTP fixture in the background: `python3 files/server.py 18080 &`, then probe it with `ss -tln`, `nc -z -w 1 127.0.0.1 18080`, `curl -sS http://127.0.0.1:18080/manifest.json`, and `wget -q -O - http://127.0.0.1:18080/index.html`.
3. Inspect `files/traceroute_sample.txt` and `files/zone_sample.txt` with `awk` or `grep`.
4. Test `rsync -avn --exclude='*.log' files/sync_src/ /tmp/sandbox_dst/` (with trailing slash vs without).
