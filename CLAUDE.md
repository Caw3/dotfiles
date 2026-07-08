## File format

Always return filelocations in this format: <path>:<line>:<col>

Example:
```
.config/nvim/init.lua:133:2
.config/nvim/init.lua:248:13
.config/nvim/init.lua:257:13
```

## Quickfix list

Creating an errors.err file:

Just write one location per line in file:line:col: message format:

src/main.ts:42:5: unused variable 'foo'
src/utils.ts:18:1: missing return type
lib/handler.ts:99:12: possible null dereference

You can generate it from any tool by piping to that format, e.g.:

# eslint
eslint -f unix src/ > errors.err

# grep -n already gives file:line:
grep -rn 'TODO' src/ > errors.err
