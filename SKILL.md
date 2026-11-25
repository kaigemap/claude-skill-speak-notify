---
name: speak-notify
description: Claude が質問したとき・返答を終えたときに、プロジェクト名を音声で読み上げる（macOS）。「読み上げを入れて」と言われたとき、プロジェクトの読み方を追加・修正するとき、読み上げを止めるときに使う。
---

# 読み上げ通知

複数のセッションを同時に開いていても、どのプロジェクトが返事を待っているかを音で分かるようにする。Claude が質問するときは「〇〇、質問があります」、返答を終えたときは「〇〇、作業が完了しました」と読み上げる。

読み上げはフック（特定のタイミングで Claude Code が実行するコマンド）で行う。このスキルは、そのフックを設定・修正するための手順。

## 設定する

1. `say` コマンドがあるか確認する（macOS でのみ動作する）
2. `~/.claude/settings.json` の `hooks` に次の 2 つを追加する。ほかのフックはそのまま残し、`PreToolUse` や `Stop` がすでにあれば、その配列に 1 つずつ追加する
   ```json
   "PreToolUse": [{ "matcher": "AskUserQuestion", "hooks": [{ "type": "command", "command": "\"$HOME/.claude/skills/speak-notify/speak-notify.sh\" question", "async": true }] }],
   "Stop": [{ "hooks": [{ "type": "command", "command": "\"$HOME/.claude/skills/speak-notify/speak-notify.sh\" done", "async": true }] }]
   ```
   - 同じように読み上げるフック（別の場所にある `speak-notify.sh` や、`say` を呼ぶもの）がすでにあれば、追加せずに置き換える。両方あると 2 回読み上げられる
3. テストで再生し、聞こえたかをユーザーに確認する: `echo "{\"cwd\":\"$PWD\"}" | ~/.claude/skills/speak-notify/speak-notify.sh done`
4. 現在のセッションには反映されないことがあるので、新しいセッションで確認してもらう

## 読み方を追加する

- 対応表は `~/.claude/hooks/dir-voice-names.tsv`。1 行に `フォルダ名<タブ>読み方` の形式で書く。ファイルがなければ作成する
- 対応表にないフォルダは、フォルダ名をそのまま読み上げる。英字の名前は英語読みや 1 文字ずつの読みになりやすいので、読み方はカタカナかひらがなで書く
- 対応表は再生するたびに読み込まれるので、書いたらすぐ反映される。追加したらテストで再生する
- 対応表はユーザーごとのものなので、このスキルのフォルダには置かない

## 止める

- `settings.json` から、このスキルの `speak-notify.sh` を呼ぶフックを 2 つとも削除する。対応表は残してよい
