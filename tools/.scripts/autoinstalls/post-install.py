#!/usr/bin/env python3
"""Install selected Arch workstation package groups as a regular user."""

import argparse
import os
import shlex
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class PackageGroup:
    # Immutable definitions keep installation state out of the package catalogue.
    label: str
    packages: tuple[str, ...]
    aur: bool = False


@dataclass(frozen=True)
class InstallerGroup:
    # The interpreter tuple also records whether this installer needs sudo.
    label: str
    url: str
    interpreter: tuple[str, ...]


# Maintain package selections here. Keys are the names accepted by --only/--skip;
# dictionary order determines installation order, regardless of CLI argument order.
GROUPS = {
    "basic": PackageGroup(
        "Basic system packages",
        (
            "git",
            "pacman-contrib",
            "fastfetch",
            "less",
            "bluez",
            "bluez-utils",
            "bluez-obex",
            "bluez-deprecated-tools",
            "dosfstools",
            "ntfsprogs",
            "rsync",
            "openssh",
            "rclone",
            "sshfs",
            "ripgrep",
            "imagemagick",
            "wl-clipboard",
        ),
    ),
    "python-build": PackageGroup(
        "Python build dependencies",
        (
            "base-devel",
            "openssl",
            "zlib",
            "xz",
            "tk",
        ),
    ),
    "cli": PackageGroup(
        "Command line utilities",
        (
            "btop",
            "nvtop",
            "lsd",
            "tmux",
            "yazi",
            "kitty",
            "zoxide",
            "starship",
            "fzf",
            "stow",
            "keyd",
            "timeshift",
            "cronie",
            "pdftk",
            "jq",
        ),
    ),
    "dev": PackageGroup(
        "Development tools",
        (
            "neovim",
            "jdk-openjdk",
            "github-cli",
            "marksman",
            "ruff",
            "prettier",
            "nodejs",
            "go",
            "tree-sitter-cli",
            "python-pynvim",
            "uv",
        ),
    ),
    "desktop": PackageGroup(
        "Desktop software",
        (
            "inkscape",
            "obs-studio",
            "noto-fonts-cjk",
            "kcolorchooser",
            "filelight",
            "flatpak",
            "gnome-disk-utility",
            "okular",
            "gwenview",
            "haruna",
        ),
    ),
    "latex": PackageGroup(
        "LaTeX dependencies",
        (
            "texlive",
            "zathura",
            "zathura-pdf-mupdf",
        ),
    ),
    "aur": PackageGroup(
        "AUR packages",
        (
            "ttf-blex-nerd-font-git",
            "zotero-bin",
            "youtube-music-for-desktop-bin",
            "wps-office-cn",
            "ttf-wps-fonts",
            "wechat-bin",
            # my own packages
            "suisave",
            "gremux",
        ),
        aur=True,
    ),
    # Verified: standalone CLI installer; desktop installer configures OpenAI's repo.
    "codex": InstallerGroup(
        "Codex CLI (OpenAI standalone)",
        "https://chatgpt.com/codex/install.sh",
        ("sh",),
    ),
    "chatgpt": InstallerGroup(
        "ChatGPT desktop (OpenAI repository)",
        "https://persistent.oaistatic.com/codex-app-prod/linux/install-arch.sh",
        ("sudo", "bash"),
    ),
}

# final checks
# check binaries in path for kei, rpy, and reicloud-sync, if not warn to install them
FINAL_COMMANDS = ("kei", "rpy", "reicloud")
# reicloud-sync is the project name; its executable is named reicloud.


def status(label: str, message: str) -> None:
    # Keep redirected output free of ANSI codes and respect the NO_COLOR convention.
    colors = {"OK": "32", "WARN": "33", "ERROR": "31", "PLAN": "36", "INFO": "34"}
    tag = f"[{label}]"
    if sys.stdout.isatty() and "NO_COLOR" not in os.environ:
        tag = f"\033[{colors.get(label, '0')}m{tag}\033[0m"
    print(f"{tag} {message}", flush=True)


def group_names(value: str) -> list[str]:
    # Validate during argument parsing so typos fail before any installation starts.
    names = value.split(",")
    unknown = set(names) - GROUPS.keys()
    if unknown:
        raise argparse.ArgumentTypeError(
            f"unknown group(s): {', '.join(sorted(unknown))}; choose from {', '.join(GROUPS)}"
        )
    return names


def parse_args(argv=None):
    # Accept an explicit argv for callers; None uses the command line as usual.
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dry-run", action="store_true", help="print commands without installing"
    )
    parser.add_argument(
        "--only",
        type=group_names,
        metavar="GROUPS",
        help="comma-separated groups to install",
    )
    parser.add_argument(
        "--skip",
        type=group_names,
        default=[],
        metavar="GROUPS",
        help="comma-separated groups to omit",
    )
    parser.add_argument(
        "--list-groups",
        action="store_true",
        help="list groups and package targets, then exit",
    )
    parser.add_argument(
        "--yes", action="store_true", help="pass --noconfirm to pacman and paru"
    )
    return parser.parse_args(argv)


def install_command(group: PackageGroup, assume_yes: bool) -> list[str]:
    # AUR builds run as the invoking user; only pacman is elevated here.
    command = ["paru"] if group.aur else ["sudo", "pacman"]
    command.extend(["-S", "--needed"])
    # --needed avoids reinstalling current packages when rerunning the script.
    if assume_yes:
        command.append("--noconfirm")
    return command + list(group.packages)


def installer_commands(group: InstallerGroup, path: str) -> list[list[str]]:
    # Separate download and execution so curl failures prevent the second step.
    # --yes belongs to our package-manager calls, not these upstream installers.
    return [
        ["curl", "--proto", "=https", "--tlsv1.2", "-fL", "-o", path, group.url],
        [*group.interpreter, path],
    ]


def run_command(command: list[str], dry_run: bool) -> None:
    # Shell quoting is for display only: execute argument lists without a shell.
    # Inherited stdin/stdout keep sudo and package-manager prompts interactive.
    print(f"  $ {shlex.join(command)}", flush=True)
    if not dry_run:
        subprocess.run(command, check=True)


def install_group(group, assume_yes: bool, dry_run: bool) -> None:
    # Package groups share one transaction; external installers have their own flow.
    if isinstance(group, PackageGroup):
        run_command(install_command(group, assume_yes), dry_run)
        return
    if group is GROUPS["chatgpt"]:
        status("WARN", "The desktop installer configures OpenAI's signed repository and performs a full system upgrade. Its confirmation prompt is retained, including with --yes.")
    if dry_run:
        # Use a readable placeholder rather than creating files during a preview.
        for command in installer_commands(group, "/tmp/<private-installer-dir>/install.sh"):
            run_command(command, True)
        return
    # Download fully before execution; a failed transfer must never run a partial script.
    with tempfile.TemporaryDirectory(prefix="post-install-") as directory:
        # The context manager removes the private download directory on failure too.
        for command in installer_commands(group, str(Path(directory) / "install.sh")):
            run_command(command, False)
    if group is GROUPS["codex"]:
        status("INFO", "Use the installer's PATH instructions; an existing pacman-managed Codex is left installed.")


def final_checks() -> None:
    # These optional tools may be installed outside pacman. Report PATH visibility
    # without installing them or turning their absence into an installation error.
    for command in FINAL_COMMANDS:
        path = shutil.which(command)
        if path:
            status("OK", f"{command}: {path}")
        else:
            status("WARN", f"{command} is missing from PATH; install it separately.")


def main(argv=None) -> int:
    args = parse_args(argv)
    if args.list_groups:
        # Listing is informational and needs neither privileges nor install tools.
        for name, group in GROUPS.items():
            if isinstance(group, InstallerGroup):
                print(f"{name:14} {group.label} (official installer)")
                print(f"               {group.url}")
            else:
                print(f"{name:14} {group.label} ({len(group.packages)} targets)")
                print(f"               {' '.join(group.packages)}")
        return 0

    # --skip wins over --only; omitting --only selects every group by default.
    selected = [
        name
        for name in GROUPS
        if name in (args.only or GROUPS) and name not in args.skip
    ]
    if not selected:
        status("ERROR", "No groups selected.")
        return 2
    if not args.dry_run:
        # Refuse a root invocation so AUR builds and standalone user installs keep
        # the correct ownership. Individual system operations request sudo instead.
        if os.geteuid() == 0:
            status(
                "ERROR", "Run as your regular user; the script uses sudo for pacman."
            )
            return 2
        # Check all selected prerequisites before making any changes. Dry runs
        # intentionally work even on machines without these commands installed.
        required = set()
        for name in selected:
            group = GROUPS[name]
            if isinstance(group, InstallerGroup):
                required.update(("curl", *group.interpreter))
                if name == "chatgpt":
                    required.add("pacman")
            else:
                required.update(("paru",) if group.aur else ("sudo", "pacman"))
        missing = sorted(command for command in required if not shutil.which(command))
        if missing:
            status(
                "ERROR",
                f"Missing required commands: {', '.join(missing)}. Install them before retrying.",
            )
            status("WARN", f"No groups were attempted: {', '.join(selected)}.")
            if "paru" in missing:
                status("INFO", "To install the non-AUR groups first, use --skip aur. To install only OpenAI tools, use --only codex,chatgpt.")
            return 2

    status("INFO", f"Selected groups: {', '.join(selected)}")
    completed = []
    # Stop at the first failure. Successful earlier groups are not rolled back,
    # and an upstream installer or AUR group can also fail after partial changes.
    for index, name in enumerate(selected, 1):
        group = GROUPS[name]
        status(
            "PLAN" if args.dry_run else "INFO",
            f"{index}/{len(selected)} — {group.label}",
        )
        try:
            install_group(group, args.yes, args.dry_run)
        except (subprocess.CalledProcessError, OSError) as error:
            status("ERROR", f"{name} failed: {error}")
            status(
                "INFO",
                f"Completed groups: {', '.join(completed) or 'none'}. Later groups were not attempted.",
            )
            status(
                "WARN",
                "The failed transaction may have made changes; review its output before retrying.",
            )
            pending = selected[index:]
            if pending:
                status("WARN", f"Not attempted: {', '.join(pending)}.")
                status("INFO", f"To run those groups separately: python3 {shlex.quote(sys.argv[0])} --only {','.join(pending)}")
            return 1
        if args.dry_run:
            continue
        # Only record completion after every command in the group has succeeded.
        completed.append(name)
        status("OK", f"{group.label} completed")

    if args.dry_run:
        status("OK", f"Dry run complete: {len(selected)} groups; no commands executed.")
    else:
        status("OK", f"Installation complete: {len(completed)} groups.")
    final_checks()
    return 0


if __name__ == "__main__":
    # Return useful shell exit codes: 1 for install failures, 2 for setup errors,
    # and 130 for an interrupt. Importing the module never starts installation.
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        status("WARN", "Interrupted; review package manager output before retrying.")
        sys.exit(130)
