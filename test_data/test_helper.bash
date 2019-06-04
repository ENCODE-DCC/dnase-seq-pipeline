#!/bin/bash

function require_exe() {
  exitstatus=0
  for exe in "$@" ; do
    if ! command -v "$exe" >/dev/null; then
      exitstatus=1
      echo "Could not find $exe, will not run tests" > /dev/stderr
    fi
  done
  return $exitstatus
}

function cmp_text() {
  name=$1
  echo "Comparing $name..."
  diff "expected/$name" "output/$name"
}

function cmp_picard() {
  name=$1
  expected=$(grep -v '^#' "expected/$name")
  actual=$(grep -v '^#' "output/$name")

  echo "Comparing $name..."
  diff <(echo "$expected") <(echo "$actual")
}

function cmp_starch() {
  name=$1
  if ! command -v unstarch ; then
    echo "Cannot verify $name, unstarch is not available"
    return 0
  fi
  echo "Comparing $name..."
  cmp <(unstarch "expected/$name") <(unstarch "output/$name") \
    || (echo "$name does not match" ; false)
}

function cmp_bam() {
  name=$1
  if ! command -v samtools ; then
    echo "Cannot verify $name, samtools is not available"
    return 0
  fi
  echo "Comparing $name..."
  cmp <(samtools view "expected/$name") <(samtools view "output/$name") \
    || (echo "$name does not match" ; false)

}
