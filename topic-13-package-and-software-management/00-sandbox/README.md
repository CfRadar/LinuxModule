# Topic 13 Sandbox — Package and Software Management

Open sandbox for free experimentation in a Linux/WSL2 environment. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `dpkg` — Low-level Debian package tool: query installed packages (`dpkg -l`), list package files (`dpkg -L <pkg>`), find file owners (`dpkg -S <path>`), or compare versions (`dpkg --compare-versions <v1> <op> <v2>`).
- `dpkg-deb` — Inspect `.deb` archive metadata (`dpkg-deb -I`, `dpkg-deb -f`) and contents (`dpkg-deb -c`) without installing.
- `apt` — High-level Debian/Ubuntu interactive package manager (`apt list --installed`, `apt show <pkg>`, `apt-cache policy <pkg>`, `apt -s install <pkg>`).
- `apt-get` — Script-stable Debian/Ubuntu package manager (`apt-get -s install`, `apt-get -s upgrade`, `apt-get -s autoremove`) for dry-run simulations and automation.
- `yum` / `dnf` — RPM-family package managers (`dnf repoquery`, `dnf check-update`, `dnf history`, `dnf module list`) using `.repo` configs and `Epoch:Version-Release` versioning.
- `pacman` — Arch Linux package manager using compact flags (`-S` sync/install, `-Syu` full upgrade, `-Q` query local, `-Qe` explicit, `-Qm` foreign, `-Qdt` orphans, `-Rns` remove with unused deps).
- `snap` — Confined universal package manager (`snap list`, `snap connections`, `snap info`) distinguishing `strict` vs `--classic` confinement and `stable`/`candidate`/`beta`/`edge` tracks.

## Things to Try

1. Run `dpkg -l bash coreutils` and `dpkg-query -W -f='${Package}\t${Version}\t${db:Status-Abbrev}\n' bash` to see script-friendly output.
2. Run `dpkg -S "$(readlink -f /bin/bash)"` and compare with `dpkg -S /bin/bash` to observe merged-`/usr` symlink behavior.
3. Run `apt-cache policy bash` and `apt-cache depends bash` to inspect candidate versions and dependency trees.
4. Test `dpkg --compare-versions 1:2.4-1 gt 2.9-5 && echo newer` to see how epochs override version numbers.
5. Inspect `files/dpkg_status.sample`, `files/sources.list.sample`, and `files/fedora.repo.sample` with `awk` or `grep`.
6. Compare `files/pacman_sync.tsv` and `files/snap_list.tsv` to practice spotting orphaned dependencies and `--classic` confinement snaps.
