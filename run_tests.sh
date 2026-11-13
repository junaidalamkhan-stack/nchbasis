#!/bin/sh
# Runs every session in examples/ and tests/ with Singular and compares the
# output with the stored *_output.txt files.  With --update, the stored
# outputs are regenerated instead.
cd "$(dirname "$0")" || exit 1
ROOT="$(pwd)"
SINGULARPATH="$ROOT${SINGULARPATH:+:$SINGULARPATH}"; export SINGULARPATH
status=0
for s in examples/*.sing tests/*.sing; do
  d="$(dirname "$s")"; b="$(basename "$s" .sing)"
  out="$d/${b}_output.txt"
  ( cd "$d" && Singular -q "$b.sing" ) > "$out.new" 2>&1
  if [ "$1" = "--update" ]; then
    mv "$out.new" "$out"; echo "[UPDATED] $out"
  elif cmp -s "$out.new" "$out"; then
    rm -f "$out.new"; echo "[ OK ] $s reproduces $out"
  else
    echo "[DIFF] $s differs from $out (see $out.new)"; status=1
  fi
done
exit $status
