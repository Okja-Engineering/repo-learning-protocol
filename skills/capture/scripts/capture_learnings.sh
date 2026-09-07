#!/usr/bin/env bash
set -euo pipefail

inbox="docs/learnings/inbox.md"
date_str="$(date +%Y-%m-%d)"
link=""
slug=""
sentence=""
from=""

usage() {
  cat <<EOF
Usage: capture.sh [-i inbox] [-d date] -l link -s slug -t sentence
       capture.sh [-i inbox] -f source-file

Options:
  -i, --inbox     Inbox path (default: docs/learnings/inbox.md)
  -d, --date      Entry date as YYYY-MM-DD (default: today)
  -l, --link      Source link or reference
  -s, --slug      Class slug for recurrence counting
  -t, --sentence  One-sentence learning
  -f, --from      Path to a file of candidate lines to import
  -h, --help      Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--inbox)
      inbox="$2"; shift 2 ;;
    -d|--date)
      date_str="$2"; shift 2 ;;
    -l|--link)
      link="$2"; shift 2 ;;
    -s|--slug)
      slug="$2"; shift 2 ;;
    -t|--sentence)
      sentence="$2"; shift 2 ;;
    -f|--from)
      from="$2"; shift 2 ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

append_line() {
  printf -- '- %s\n' "$1" >> "$inbox"
}

if [[ -n "$from" ]]; then
  if [[ ! -f "$from" ]]; then
    echo "Source file not found: $from" >&2
    exit 1
  fi
  while IFS= read -r line; do
    line="${line#"${line%%[![:space:]]*}"}"   # trim leading
    line="${line%"${line##*[![:space:]]}"}" # trim trailing
    [[ -z "$line" ]] && continue
    fields="$(printf '%s' "$line" | awk -F' · ' '{print NF}')"
    if [[ "$fields" -eq 4 ]]; then
      append_line "$line"
    elif [[ "$fields" -eq 3 ]]; then
      append_line "$date_str · $line"
    fi
  done < "$from"
  exit 0
fi

if [[ -z "$link" || -z "$slug" || -z "$sentence" ]]; then
  usage >&2
  exit 1
fi

mkdir -p "$(dirname "$inbox")"
append_line "$date_str · $link · $slug · $sentence"
