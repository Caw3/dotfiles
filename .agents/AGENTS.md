# Global agent instructions

- Technical text: ASD-STE100 style. Max 20 words per sentence in instructions,
  25 in descriptions. Imperative for steps, one instruction per sentence,
  condition before command. Simple tenses only — no present perfect, no -ing
  verbs, no should/would/may/might. Active voice. One word per meaning — no
  synonym rotation. No contractions, keep articles and "that". Delete filler:
  simply, robust, seamlessly, leverage. Code and identifiers stay exact.

- Implementation: Always prefer implementing vertical slices: that means that if you
  have a larger set of tasks, write the related tests, frontend, backend, and
  database tables for iteratively. DO NOT IMPLEMENT IT LAYER BY LAYER.

## File format

Always return filelocations in this format: <project-path>:<line>:<col>

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

remind the user to load it in vim with `:cfile`


## General typescript code guide

With low effort, find and reuse functionality in the codebase instead of adding
new helper functions. Prefer longer descriptive names of variables. Try and use
a compositional and functional pattern with working with typescript i.e array
methods. Avoid deeply nesting, prefer extracting into separate functions if it
helps avoiding nesting. Prefer creating errors as values with discriminated
unions. Avoid throwing exceptions. Create type for the results and return them.
