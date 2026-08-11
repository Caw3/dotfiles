---
name: quickfix
description: Use when the user asks for a quickfix list in vim. Generates an errors.err file in Vim quickfix format from Claude findings or tool output
user_invocable: true
---

# Quickfix errors.err generator

Generate an `errors.err` file in the working directory that can be loaded in Vim/Neovim with `:cfile`.

## Behavior

1. If `args` contains a shell command (e.g. `eslint src/`, `grep -rn TODO .`), run the command and convert its output to quickfix format.
2. If `args` describes what to search for (e.g. `unused imports`, `TODO comments`, `type errors`), find matching locations in the codebase and write them in quickfix format.
3. If no args are given, ask what to look for.

## Output format

Every line in `errors.err` must follow:

```
<path>:<line>:<col>: <message>
```

- `<path>` — relative file path from the project root
- `<line>` — 1-indexed line number
- `<col>` — 1-indexed column number (use `1` if unknown)
- `<message>` — short description of the finding

## Rules

- Write the file to `errors.err` in the current working directory.
- One finding per line. No blank lines, no headers, no comments.
- Sort by file path, then line number.
- After writing, report the count of entries and remind the user to run `:cfile` in Vim.
- If a tool command produces output already in `file:line:col: message` format, write it directly without re-parsing.
- Some tools have a `--vimgrep` flag (e.g. `rg --vimgrep`) that outputs in quickfix-compatible format. Prefer `--vimgrep` when available.
