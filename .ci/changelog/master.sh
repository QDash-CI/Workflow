#!/bin/sh -ex

TAG=${TIMESTAMP}-${FORGEJO_REF}
REF=${FORGEJO_REF}

brief() {
  echo "This is ref [\`$FORGEJO_REF\`](https://git.crueter.xyz/QFRC/QDash/commit/$FORGEJO_REF) of QDash's master branch."
}

changelog() {
  echo "## Changelog"
  echo
  echo "Full changelog: [\`$FORGEJO_BEFORE...$FORGEJO_REF\`](https://git.crueter.xyz/QFRC/QDash/compare/$FORGEJO_BEFORE...$FORGEJO_REF)"
  echo
}

.ci/changelog/generate.sh