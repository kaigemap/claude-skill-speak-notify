# speak-notify（読み上げ通知）

Claude が質問したときと返答を終えたときに、プロジェクト名を音声で読み上げる Claude Code スキルです。

- 質問するとき:「〇〇、質問があります」
- 返答を終えたとき:「〇〇、作業が完了しました」

複数のセッションを同時に開いていても、どのプロジェクトが返事を待っているかが音で分かります。プロジェクト名はフォルダ名から取得し、読み方を指定することもできます。

## インストール

```sh
git clone https://github.com/kaigemap/claude-skill-speak-notify.git ~/.claude/skills/speak-notify
```

インストール後に Claude Code で「読み上げを入れて」と頼むと、`~/.claude/settings.json` にフックが設定されます。読み上げは次のセッションから有効になります。

- 読み方を指定する:「このプロジェクトは〇〇と読んで」
- 止める:「読み上げを止めて」

読み方の対応表は `~/.claude/hooks/dir-voice-names.tsv` に保存されます（1 行に `フォルダ名<タブ>読み方`）。

## 注意

- macOS の `say` コマンドで読み上げます。音声は Kyoko で、インストールされていなければデフォルトの音声になります
- `jq` があればフックから渡されたフォルダを使い、なければカレントディレクトリを使います

## English

A Claude Code skill that speaks the project name aloud (macOS `say`) when Claude asks a question or finishes a reply, so you can tell which session is waiting for you. Install with `git clone https://github.com/kaigemap/claude-skill-speak-notify.git ~/.claude/skills/speak-notify`, then ask Claude Code to set it up (「読み上げを入れて」). The spoken phrases and the skill text are in Japanese.

## License

MIT
