#!/bin/bash
# Claude Code hook: ディレクトリ名に応じた音声通知 (macOS `say`)
# stdin: フック入力JSON / $1: イベント種別 (question | done)

input=$(cat)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
[ -z "$cwd" ] && cwd=$PWD
dir=$(basename "$cwd")

# ディレクトリのパターン → 読み上げ名 のマッピング (タブ区切り)
map_file="$HOME/.claude/hooks/dir-voice-names.tsv"
spoken="$dir"
if [ -f "$map_file" ]; then
  while IFS=$'\t' read -r pattern reading || [ -n "$pattern$reading" ]; do
    [ -z "$pattern" ] && continue
    case "$pattern" in
      \#*) continue ;;
      */*) target="$cwd" ;;
      *)   target="$dir" ;;
    esac
    # shellcheck disable=SC2254
    case "$target" in
      $pattern) spoken="$reading"; break ;;
    esac
  done < "$map_file"
fi

case "$1" in
  question) msg="${spoken}、質問があります" ;;
  done)     msg="${spoken}、作業が完了しました" ;;
  *)        msg="${spoken}、通知です" ;;
esac

say -v Kyoko "$msg" 2>/dev/null || say "$msg"
