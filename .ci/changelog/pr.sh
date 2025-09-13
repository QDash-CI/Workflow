#!/bin/sh -ex

TAG=${FORGEJO_NUMBER}-${FORGEJO_REF}
REF=${FORGEJO_NUMBER}-${FORGEJO_REF}

brief() {
  echo "This is pull request number [$FORGEJO_NUMBER]($FORGEJO_PR_URL), ref [\`$FORGEJO_REF\`](https://git.crueter.xyz/QFRC/QDash/commit/$FORGEJO_REF) of QDash."
}

changelog() {
  echo "## Changelog"
  echo
  FIELD=body DEFAULT_MSG="No changelog provided" FORGEJO_NUMBER=$FORGEJO_NUMBER python3 .ci/changelog/pr_field.py
  echo
}

.ci/generate.sh