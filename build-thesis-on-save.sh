#!/usr/bin/env bash
set -u

input="${1:-}"

if [ -n "$input" ] && [ -e "$input" ]; then
  if [ -d "$input" ]; then
    search_dir="$input"
  else
    search_dir="$(cd "$(dirname "$input")" && pwd)"
  fi
else
  search_dir="$(pwd)"
fi

thesis_dir=""
while [ "$search_dir" != "/" ]; do
  if [ -f "$search_dir/ctufit-thesis.tex" ]; then
    thesis_dir="$search_dir"
    break
  fi
  search_dir="$(dirname "$search_dir")"
done

if [ -z "$thesis_dir" ]; then
  echo "Could not find ctufit-thesis.tex from input: ${input:-<empty>}" >&2
  exit 1
fi

cd "$thesis_dir" || exit 1

latexmk -f -xelatex -synctex=1 -interaction=nonstopmode -file-line-error ctufit-thesis.tex
status=$?

# The CTU FIT template can hit a creation-date rerun limit while still writing a
# valid PDF. A second invocation makes sure generated lists such as the table of
# contents, figures, and tables are read back into the PDF after saves.
latexmk -f -xelatex -synctex=1 -interaction=nonstopmode -file-line-error ctufit-thesis.tex
second_status=$?

if [ -f ctufit-thesis.pdf ]; then
  exit 0
fi

if [ "$second_status" -ne 0 ]; then
  exit "$second_status"
fi

exit "$status"
