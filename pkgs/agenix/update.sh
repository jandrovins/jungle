#!/bin/sh

set -e

# All operations are done relative to root
GITROOT=$(git rev-parse --show-toplevel)
cd "$GITROOT"

REVISION=${1:-main}

TMPCLONE=$(mktemp -d)
trap "rm -rf ${TMPCLONE}" EXIT

git clone https://github.com/ryantm/agenix.git --revision="$REVISION" "$TMPCLONE" --depth=1

cp "${TMPCLONE}/pkgs/agenix.sh" pkgs/agenix/agenix.sh
cp "${TMPCLONE}/pkgs/agenix.nix" pkgs/agenix/default.nix
sed -i 's#../example#./example#' pkgs/agenix/default.nix

cp "${TMPCLONE}/example/"* pkgs/agenix/example/
cp "${TMPCLONE}/example_keys/"* pkgs/agenix/example_keys/

cp "${TMPCLONE}/modules/age.nix" m/module/agenix.nix
