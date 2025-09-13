#!/bin/sh -x

TRIES=0

while ! git clone $FORGEJO_CLONE_URL QDash; do
  echo "Clone failed!"
  TRIES=$(($TRIES + 1))
  if [ "$TRIES" = 10 ]; then
    echo "Failed to clone after ten tries. Exiting."
    exit 1
  fi

  sleep 5
  echo "Trying clone again..."
  rm -rf ./QDash || true
done

cd QDash
git fetch --all
git checkout $FORGEJO_REF

git rev-parse --abbrev-ref HEAD > GIT-REFSPEC
git rev-parse --short=10 HEAD > GIT-COMMIT
git describe --tags HEAD --abbrev=0 > GIT-TAG || echo '1.0.0' > GIT-TAG