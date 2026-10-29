# speak-notify（読み上げ通知）

Claude Code 用のスキル。Claude が質問したとき、権限の確認を求めたとき、返答を終えたときに、プロジェクト名を声で読み上げます。

- 質問するとき・権限の確認や入力を求めるとき:「〇〇、質問があります」
- 返答を終えたとき:「〇〇、作業が完了しました」

セッションをいくつも並べていても、どのプロジェクトが返事を待っているかが耳で分かります。プロジェクト名はフォルダ名から取り、読み方を決めておくこともできます。

## 入れ方

```sh
git clone https://github.com/kaigemap/claude-skill-speak-notify.git ~/.claude/skills/speak-notify
```

そのあと Claude Code に「読み上げを入れて」と言うと、`~/.claude/settings.json` にフックを足します。新しいセッションから読み上げます。

- 読み方を決める:「このプロジェクトは〇〇と読んで」
- 止める:「読み上げを止めて」

読み方の対応表は `~/.claude/hooks/dir-voice-names.tsv` に置きます（1行に `パターン<タブ>読み方`）。パターンには `sks-webapp*` や `*/kanadevia/*` のようなワイルドカードが使えます。`/` を含むパターンはフォルダの絶対パスと、含まないパターンはフォルダ名と照合し、上の行から順に見て最初に当たった行を使います。

## 注意

- macOS の `say` で読み上げます。声は Kyoko で、入っていなければ既定の声になります
- `jq` があればフックから届いたフォルダを読み、なければ今いるフォルダを使います
- 対応表の引き方のテストは `bash test/speak-notify.test.sh` で流せます（`say` は鳴らしません）

## English

A Claude Code skill that speaks the project name aloud (macOS `say`) when Claude asks a question, asks for permission, or finishes a reply, so you can tell which session is waiting for you. Install with `git clone https://github.com/kaigemap/claude-skill-speak-notify.git ~/.claude/skills/speak-notify`, then ask Claude Code to set it up (「読み上げを入れて」). The spoken phrases and the skill text are in Japanese.

## License

MIT
