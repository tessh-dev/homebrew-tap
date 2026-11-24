#!/usr/bin/env bash
# Points Casks/tessh.rb at the DMG named in https://tessh.dev/updates/mac/latest.json, which moves only when a
# release is published in the Hub (tessh.dev's release gate). Run hourly by .github/workflows/follow-latest.yml.
# Refuses to write the cask unless the downloaded DMG's SHA-256 matches latest.json. Prints what it did.
set -euo pipefail
LATEST_URL=${LATEST_URL:-https://tessh.dev/updates/mac/latest.json}
cd "$(dirname "$0")/.."

json=$(curl -fsSL "$LATEST_URL")
read -r VERSION BUILD SHA URL < <(python3 -I -c '
import json, re, sys
r = json.loads(sys.argv[1])
v, b, sha, url = r["version"], r["build"], r["sha256"], r["dmgUrl"]
assert isinstance(v, str) and re.fullmatch(r"[0-9]+(\.[0-9]+)*", v), "version"
assert isinstance(b, int) and not isinstance(b, bool) and b > 0, "build"
assert isinstance(sha, str) and re.fullmatch(r"[0-9a-f]{64}", sha), "sha256"
assert url == "https://tessh.dev/updates/mac/Tessh-%s-%d.dmg" % (v, b), "dmgUrl"
print(v, b, sha, url)' "$json")

if grep -q "version \"$VERSION,$BUILD\"" Casks/tessh.rb && grep -q "sha256 \"$SHA\"" Casks/tessh.rb; then
  echo "cask already at $VERSION ($BUILD)"
  exit 0
fi
live=$(curl -fsSL "$URL" | sha256sum | cut -d' ' -f1)
[[ $live == "$SHA" ]] || { echo "DMG sha256 $live differs from latest.json $SHA" >&2; exit 1; }

python3 -I - "$VERSION,$BUILD" "$SHA" <<'PY'
import re, sys
version, sha = sys.argv[1:]
p = "Casks/tessh.rb"
s = open(p).read()
s, n1 = re.subn(r'^  version "[^"]*"$', '  version "%s"' % version, s, count=1, flags=re.M)
s, n2 = re.subn(r'^  sha256 "[0-9a-f]{64}"$', '  sha256 "%s"' % sha, s, count=1, flags=re.M)
assert n1 == 1 and n2 == 1, "cask layout changed"
open(p, "w").write(s)
PY
echo "updated cask to $VERSION ($BUILD)"
