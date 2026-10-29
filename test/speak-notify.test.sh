#!/bin/bash

set -u

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT

export HOME="$test_dir/home"
fake_bin="$test_dir/bin"
map_file="$HOME/.claude/hooks/dir-voice-names.tsv"
export SAY_OUTPUT="$test_dir/say-output"
mkdir -p "$fake_bin" "$(dirname "$map_file")"

cat > "$fake_bin/say" <<'EOF'
#!/bin/bash
for arg in "$@"; do
  last=$arg
done
printf '%s' "$last" > "$SAY_OUTPUT"
EOF
chmod +x "$fake_bin/say"
export PATH="$fake_bin:$PATH"

failures=0

check() {
  name=$1
  event=$2
  cwd=$3
  expected=$4

  printf '{"cwd":"%s"}\n' "$cwd" | "$repo_dir/speak-notify.sh" "$event"
  actual=$(cat "$SAY_OUTPUT")
  if [ "$actual" != "$expected" ]; then
    printf 'FAIL: %s\n  expected: %s\n  actual:   %s\n' "$name" "$expected" "$actual" >&2
    failures=$((failures + 1))
  fi
}

printf 'project\tプロジェクト\n' > "$map_file"
check '完全一致' 'done' '/x/project' 'プロジェクト、作業が完了しました'

printf 'sks-webapp*\tウェブアプリ\n' > "$map_file"
check 'フォルダ名パターン' 'done' '/x/sks-webapp-1168' 'ウェブアプリ、作業が完了しました'

printf '*/kanadevia/*\tカナデビア\n' > "$map_file"
check 'パスパターン' 'done' '/x/kanadevia/wt-472' 'カナデビア、作業が完了しました'

printf '*\t先頭\nsks-webapp*\t後続\n' > "$map_file"
check '先頭優先' 'done' '/x/sks-webapp-1701' '先頭、作業が完了しました'

printf 'other\tその他\n' > "$map_file"
check '該当なし' 'done' '/x/unknown' 'unknown、作業が完了しました'

printf '\n#comment\t誤り\n' > "$map_file"
check '空行とコメント' 'done' '/x/#comment' '#comment、作業が完了しました'

printf 'no-newline\t改行なし' > "$map_file"
check '末尾改行なし' 'done' '/x/no-newline' '改行なし、作業が完了しました'

rm "$map_file"
check '対応表なし' 'done' '/x/no-map' 'no-map、作業が完了しました'

printf 'events\tイベント\n' > "$map_file"
check 'question' 'question' '/x/events' 'イベント、質問があります'
check 'done' 'done' '/x/events' 'イベント、作業が完了しました'
check 'その他イベント' 'other' '/x/events' 'イベント、通知です'

if [ "$failures" -ne 0 ]; then
  printf '%s test(s) failed\n' "$failures" >&2
  exit 1
fi
