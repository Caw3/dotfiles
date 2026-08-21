---
name: local-review
description: When asked to do a code review agaisnt a locally checked out branch, use this skill.
---

# Local Review

Your task is to review the checked out code against the main branch of this git
repository.

1. Begin with collecting the diff against the main/master branch as context.
2. Get the shared parent with main/master, read the commit messages and
   individual diffs.
3. Review the code for bugs, defects and other issues reading the affected files
   for context.
3. It is important that you only report bugs that are related to the diff.
4. Read the PR desc. 


In order for you to report a bug. YOU MUST PRODUCE A FAILING TEST AND PROPOSE A FIX.
Report your results in a list where you rank the severity of each issue. INCLUDE
YOUR ASSUMPTIONS.

Include as section where you asses the architectural impact of the issue.

Always use ASD-STE100 style. Max 20 words per sentence in instructions, 25 in
descriptions. Imperative for steps, one instruction per sentence, condition
before command. Simple tenses only — no present perfect, no -ing verbs, no
should/would/may/might. Active voice. One word per meaning — no synonym
rotation. No contractions, keep articles and "that". Delete filler: simply,
robust, seamlessly, leverage. Code and identifiers stay exact.

Follow this format:

[Summary of the changes]


for each issues:

# [Title] (LOW-HIGH)

## Summary

## Test case
Test case:
```
the added failing test
```

## Assumptions

## Proposed fix

propposed fix

# Architecture:

[summary of architecural issues]
