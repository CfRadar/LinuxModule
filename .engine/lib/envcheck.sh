#!/usr/bin/env bash
# .engine/lib/envcheck.sh - Detect shell/OS environment, available tools, and POSIX semantics.
set -u

detect_env_kind() {
    local uname_s
    uname_s="$(uname -s 2>/dev/null || echo unknown)"
    if [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
        echo "wsl"
    elif [[ "$uname_s" == MINGW* || "$uname_s" == MSYS* || "$uname_s" == CYGWIN* ]]; then
        if [[ "${EXEPATH:-}" == *"Git"* ]] || [[ -x "/mingw64/bin/git" && "${MSYSTEM:-}" == MINGW* ]]; then
            echo "gitbash"
        else
            echo "msys2"
        fi
    elif [[ "$uname_s" == Linux* ]]; then
        echo "linux"
    elif [[ "$uname_s" == Darwin* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

ENV_KIND="$(detect_env_kind)"
BASH_VER="${BASH_VERSION:-unknown}"
BASH_MAJOR="${BASH_VERSINFO[0]:-0}"
PWD_NOW="$(pwd)"

echo "=== Linux Course Environment Check ==="
echo "ENV_KIND=$ENV_KIND"
echo "MSYSTEM=${MSYSTEM:-none}"
echo "UNAME=$(uname -a 2>/dev/null || echo unknown)"
echo "BASH_VERSION=$BASH_VER (major=$BASH_MAJOR)"
echo "PWD=$PWD_NOW"

if [[ "$ENV_KIND" == "wsl" && "$PWD_NOW" == /mnt/[a-zA-Z]/* ]]; then
    echo "WARN_WSL_MNT=1 (Running on Windows drive $PWD_NOW; move repo into Linux filesystem ~/...)"
else
    echo "WARN_WSL_MNT=0"
fi

echo ""
echo "--- Core Engine Requirements ---"
core_tools=(bash openssl tar gzip sha256sum awk sed grep find timeout)
for t in "${core_tools[@]}"; do
    if command -v "$t" >/dev/null 2>&1; then
        printf "  [OK]   %-12s -> %s\n" "$t" "$(command -v "$t")"
    else
        printf "  [MISS] %-12s\n" "$t"
    fi
done

echo ""
echo "--- Syllabus & Utility Tool Matrix ---"
all_tools=(
    pwd ls mkdir rmdir touch cp mv rm tree file stat
    cat tac less more head tail nl wc nano vi vim
    chmod chown chgrp umask
    whoami who id users groups su sudo env printenv
    find locate which whereis grep xargs
    sort uniq cut paste tr sed awk column join comm diff cmp
    echo printf tee
    ps top htop pgrep pkill kill killall nohup
    uname hostname uptime date cal free df du lsblk lscpu
    ping ip ifconfig traceroute netstat ss nslookup dig host curl wget ssh scp sftp rsync nc
    tar gzip gunzip bzip2 xz zip unzip 7z
    apt apt-get dpkg yum dnf pacman snap
    expr bc crontab at watch
    python3 python sqlite3 git shellcheck man info getopt mkfifo
)

present_list=()
missing_list=()
for t in "${all_tools[@]}"; do
    if command -v "$t" >/dev/null 2>&1; then
        present_list+=("$t")
        printf "  [OK]   %-12s\n" "$t"
    else
        missing_list+=("$t")
        printf "  [MISS] %-12s\n" "$t"
    fi
done

echo ""
echo "Summary: ${#present_list[@]} present, ${#missing_list[@]} missing"
echo "Missing tools: ${missing_list[*]:-none}"

echo ""
echo "--- Functional Probes ---"
tmp_probe="$(mktemp -d 2>/dev/null || echo "/tmp/envcheck_$$")"
mkdir -p "$tmp_probe"

# 1. OpenSSL PBKDF2 round-trip
if command -v openssl >/dev/null 2>&1; then
    echo "probe-secret-payload" > "$tmp_probe/plain.txt"
    if CODE="ABCD-EFGH-2345" openssl enc -aes-256-cbc -pbkdf2 -iter 200000 -salt -pass env:CODE -in "$tmp_probe/plain.txt" -out "$tmp_probe/enc.bin" 2>/dev/null && \
       out="$(CODE="ABCD-EFGH-2345" openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -pass env:CODE -in "$tmp_probe/enc.bin" 2>/dev/null)" && \
       [[ "$out" == "probe-secret-payload" ]]; then
        echo "  [OK]   openssl aes-256-cbc pbkdf2 iter=200000 pass=env:CODE"
    else
        echo "  [FAIL] openssl aes-256-cbc pbkdf2"
    fi
else
    echo "  [FAIL] openssl missing"
fi

# 2. POSIX chmod 000 enforcement probe
touch "$tmp_probe/permtest.txt"
chmod 000 "$tmp_probe/permtest.txt" 2>/dev/null || true
if [[ -r "$tmp_probe/permtest.txt" ]]; then
    echo "  [WARN] chmod 000 file still readable (NTFS/root semantics)"
else
    echo "  [OK]   chmod 000 blocks read"
fi
chmod 644 "$tmp_probe/permtest.txt" 2>/dev/null || true

# 3. Symlink probe
if ln -s "$tmp_probe/plain.txt" "$tmp_probe/link.txt" 2>/dev/null && [[ -L "$tmp_probe/link.txt" ]]; then
    echo "  [OK]   ln -s creates real symlinks"
else
    echo "  [WARN] ln -s did not create a symlink (copy or blocked)"
fi

# 4. mkfifo probe
if command -v mkfifo >/dev/null 2>&1 && mkfifo "$tmp_probe/pipe.fifo" 2>/dev/null && [[ -p "$tmp_probe/pipe.fifo" ]]; then
    echo "  [OK]   mkfifo creates named pipes"
else
    echo "  [WARN] mkfifo unavailable or non-POSIX FIFO"
fi

# 5. Python3 + sqlite3 probe
py_bin=""
if command -v python3 >/dev/null 2>&1; then
    py_bin="python3"
elif command -v python >/dev/null 2>&1; then
    py_bin="python"
fi
if [[ -n "$py_bin" ]] && "$py_bin" -c "import sqlite3, http.server; print('ok')" >/dev/null 2>&1; then
    echo "  [OK]   $py_bin has sqlite3 and http.server"
else
    echo "  [WARN] python sqlite3/http.server check failed"
fi

rm -rf "$tmp_probe"
exit 0
