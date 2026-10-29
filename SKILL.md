---
name: speak-notify
description: Claude が質問したとき・権限の確認を求めたとき・返答を終えたときに、プロジェクト名を声で読み上げる（macOS）。「読み上げを入れて」と言われたとき、プロジェクトの読み方を足す・直すとき、読み上げを止めるときに使う。
---

# 読み上げ通知

セッションをいくつも並べていても、どのプロジェクトが返事を待っているかを耳で分かるようにする。Claude が質問するとき・権限の確認や入力を求めるときは「〇〇、質問があります」、返答を終えたときは「〇〇、作業が完了しました」と読み上げる。

読み上げるのはフック（決まった時に Claude Code が呼ぶコマンド）で、このスキルはそれを入れたり直したりする手順。

## 入れる

1. `say` があるか確かめる（macOS でだけ動く）
2. `~/.claude/settings.json` の `hooks` に次の3つを足す。ほかのフックはそのまま残し、`PreToolUse`・`Stop`・`Notification` がもうあれば、その配列に1つ足す
   ```json
   "PreToolUse": [{ "matcher": "AskUserQuestion", "hooks": [{ "type": "command", "command": "\"$HOME/.claude/skills/speak-notify/speak-notify.sh\" question", "async": true }] }],
   "Stop": [{ "hooks": [{ "type": "command", "command": "\"$HOME/.claude/skills/speak-notify/speak-notify.sh\" done", "async": true }] }],
   "Notification": [{ "matcher": "permission_prompt|elicitation_dialog", "hooks": [{ "type": "command", "command": "\"$HOME/.claude/skills/speak-notify/speak-notify.sh\" question", "async": true }] }]
   ```
   - `Notification` は、ユーザーが何かしないといけない通知（権限の確認 `permission_prompt`、MCP の入力依頼 `elicitation_dialog`）だけに絞る。60 秒入力が無いときの通知（`idle_prompt`）や認証の成功（`auth_success`）は読み上げない
   - `PermissionRequest` には足さない。権限の確認では `Notification` と両方が動き、2回読み上げる
   - 同じように読み上げるフック（別の場所の `speak-notify.sh` や、`say` を呼ぶもの）がすでにあれば、足さずに置き換える。両方あると2回読み上げる
3. 試しに鳴らし、聞こえたかをユーザーに確かめる: `echo "{\"cwd\":\"$PWD\"}" | ~/.claude/skills/speak-notify/speak-notify.sh done`
4. いまのセッションには効かないことがあるので、新しいセッションで確かめてもらう

## 読み方を足す

- 対応表は `~/.claude/hooks/dir-voice-names.tsv`。1行に `パターン<タブ>読み方`。なければ作る
- パターンには `*` `?` `[...]` が使える。`/` を含まないパターンはフォルダ名と、含むパターンはフォルダの絶対パスと照合する（例: `sks-webapp*`、`*/kanadevia/*`）。フォルダ名をそのまま書いた行は、そのフォルダ名にだけ当たる
- 上の行から順に見て、最初に当たった行の読み方を使う。空行と `#` で始まる行は読み飛ばす
- worktree のようにフォルダが増えていくものは、1つずつ書かずに、親フォルダのパスのパターンで1行にまとめる
- 載っていないフォルダは、フォルダ名をそのまま読む。英字の名前は英語読みや1文字ずつの読みになりやすいので、読み方はカタカナかひらがなで書く
- 対応表は鳴らすたびに読まれるので、書けばすぐ効く。足したら試しに鳴らす
- 対応表は人ごとのものなので、このスキルのフォルダには置かない

## 止める

- `settings.json` から、このスキルの `speak-notify.sh` を呼ぶフックを3つとも外す。対応表は残してよい
