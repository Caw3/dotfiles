# Writing

Use ASD-STE100 Simplified Technical English for all text output.

## Writing rules

STE has two text types: **procedures** (instructions) and **descriptions**.

### Word usage
- Use approved words only as the part of speech and meaning given in the dictionary.
- Use technical nouns and technical verbs freely (rules 1.5 and 1.12).
- Do not write multi-word nouns with more than three words.

### Verb forms
Use only these approved verb forms:
- Infinitive
- Imperative
- Simple present tense
- Simple past tense
- Simple future tense
- Past participle (only as an adjective)

Do not use auxiliary verbs for complex constructions.
Use the "-ing" form only as a technical noun or a modifier in a technical noun.

### Sentence structure
- Use the active voice. Use the passive voice only when the agent is unknown.
- Procedures: maximum 20 words per sentence. Descriptions: maximum 25 words.
- Do not omit parts of the sentence (verb, subject, article) to make the text shorter.
- Write one instruction per sentence.
- Write one topic per paragraph. Maximum six sentences per paragraph.
- Use vertical lists for complex text.

## Dictionary conventions

The STE dictionary has approved words (UPPERCASE) and unapproved words (lowercase).

- **Approved words**: Use only with the specified meaning and part of speech.
- **Unapproved words**: The dictionary gives approved alternatives in UPPERCASE.

Each word has one approved part of speech and one approved meaning.

### Example

| Word (part of speech) | Approved meaning | STE example |
|---|---|---|
| acceptance (n) | Use ACCEPT (v) instead | BEFORE YOU ACCEPT THE UNIT, DO THE SPECIFIED TEST PROCEDURE. |
| ACCESS (n) | The ability to go into or near | GET ACCESS TO THE ACCUMULATOR. |
| accessible (adj) | Use ACCESS (n) instead | TURN THE COVER UNTIL YOU CAN GET ACCESS TO THE JACKS. |
| ACCIDENT (n) | An occurrence that causes injury or damage | TO PREVENT ACCIDENTS, MAKE SURE THAT THE PINS ARE INSTALLED. |

### Restricted meanings

Some approved words have restricted meanings. For example, "close" (v) has only two approved meanings:
1. To move to a position that stops materials from going in or out
2. To operate a circuit breaker to make an electrical circuit

Do not use "close" for other meanings (e.g., "close a meeting"). The adjective "close" is not approved; use NEAR (prep) instead.


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

## Security policy

NEVER send a slack message, edit google drive document or contact anyone using
MCP or other tools without my explicit approval and confirmation.


## Guidelines on writing codes

With low effort, find and reuse functionality in the codebase instead of adding
new helper functions. Prefer longer descriptive names of variables. Group block of lines
of codes if they are related. Try and use a compositional and functional pattern
with working with typescript i.e array methods. Avoid deeply nesting, prefer
extracting into separate if it helps avoiding nesting.

When writing typescript, prefer creating errors as values with discriminated
unions. Avoid throwing exceptions.
