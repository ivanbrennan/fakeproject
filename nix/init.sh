#! /usr/bin/env nix-shell
#! nix-shell -i bash -p git gnugrep coreutils

set -eu

# ensure script is run from correct project root
if ! git remote get-url origin 2>/dev/null | grep -q 'fakeproject'; then
    echo 'This script must be run from the fakeproject repo'
    exit 1
elif ! [ $(git rev-parse --show-toplevel) == "$PWD" ]; then
    echo 'This script must be run from the toplevel directory'
    exit 1
fi

# git ignore local nix without changing .gitignore
mkdir -p .git/info
touch .git/info/exclude
grep -q '/nix' .git/info/exclude || echo '/nix' >> .git/info/exclude
grep -q '/shell.nix' .git/info/exclude || echo '/shell.nix' >> .git/info/exclude

# grab nix files from prepared branch
git fetch
git cherry-pick --no-commit origin/master..origin/nix
git reset nix/ shell.nix
