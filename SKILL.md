---
name: speak-notify
description: Claude が質問したとき・返答を終えたときに、プロジェクト名を声で読み上げる（macOS）。「読み上げを入れて」と言われたとき、プロジェクトの読み方を足す・直すとき、読み上げを止めるときに使う。
---

# 読み上げ通知

セッションをいくつも並べていても、どのプロジェクトが返事を待っているかを耳で分かるようにする。Claude が質問するときは「〇〇、質問があります」、返答を終えたときは「〇〇、作業が完了しました」と読み上げる。

読み上げるのはフック（決まった時に Claude Code が呼ぶコマンド）で、このスキルはそれを入れたり直したりする手順。

## 入れる

1. `say` があるか確かめる（macOS でだけ動く）
2. `~/.claude/settings.json` の `hooks` に次の2つを足す。ほかのフックはそのまま残し、`PreToolUse` や `Stop` がもうあれば、その配列に1つ足す
   ```json
   "PreToolUse": [{ "matcher": "AskUserQuestion", "hooks": [{ "type": "command", "command": "\"$HOME/.claude/skills/speak-notify/speak-notify.sh\" question", "async": true }] }],
   "Stop": [{ "hooks": [{ "type": "command", "command": "\"$HOME/.claude/skills/speak-notify/speak-notify.sh\" done", "async": true }] }]
   ```
   - 同じように読み上げるフック（別の場所の `speak-notify.sh` や、`say` を呼ぶもの）がすでにあれば、足さずに置き換える。両方あると2回読み上げる
3. 試しに鳴らし、聞こえたかをユーザーに確かめる: `echo "{\"cwd\":\"$PWD\"}" | ~/.claude/skills/speak-notify/speak-notify.sh done`
4. いまのセッションには効かないことがあるので、新しいセッションで確かめてもらう

## 読み方を足す

- 対応表は `~/.claude/hooks/dir-voice-names.tsv`。1行に `フォルダ名<タブ>読み方`。なければ作る
- 載っていないフォルダは、フォルダ名をそのまま読む。英字の名前は英語読みや1文字ずつの読みになりやすいので、読み方はカタカナかひらがなで書く
- 対応表は鳴らすたびに読まれるので、書けばすぐ効く。足したら試しに鳴らす
- 対応表は人ごとのものなので、このスキルのフォルダには置かない

## 止める

- `settings.json` から、このスキルの `speak-notify.sh` を呼ぶフックを2つとも外す。対応表は残してよい
