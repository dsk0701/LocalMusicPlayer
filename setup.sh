#!/bin/bash

mint bootstrap

while read -r f; do
  echo "file: $f"
  cp -f $f .git/hooks/.
  chmod +x $f
done < <(find ./hooks -mindepth 1 -maxdepth 1)

