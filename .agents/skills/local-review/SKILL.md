---
name: local-review
description: When asked to do a code review agaisnt a locally checked out branch, use this skill.
---

# Local Review

Your task is to review the checked out code against the main branch of this git
repository. 

1. Detect `main` or `master`.
1. Find the merge base between HEAD and the base branch.
1. Read each commit message and hash after the merge base.
1. Read the PR title and description when local or connected PR metadata is available.
1. State that PR metadata is unavailable when you cannot retrieve it.
1. Read the complete diff from the merge base to HEAD.
1. Read affected files and nearby code for context.
1. Analyze and review the code for bugs and defects.
1. Report only defects that the reviewed diff introduces or exposes.

If subagents are not available, run everything in the main agent. Create a
subagent that finds existing abstractions, helpers and so on and report the
results in the summary.

State your assumptions. Add a summary of the changes in the branch and the
architectural impacts. List the potential issues.

For each potential issue you can find in the first phase, spawn subagents in
parallel with a suitable fast coding model to write a FAILING test. Then run the
test in isolation where you ONLY RUN THE NEW TEST (with --filter) for each subagent before
reporting back the result to the main agent. If subagents are not available, do
this in the main agent.

Evaluate the findings. In order for you to report a bug. YOU MUST PRODUCE A
FAILING TEST AND PROPOSE A FIX. Report your results in a list where you rank the
severity of each issue. INCLUDE YOUR ASSUMPTIONS.

You do not need to clean the worktree when finished.

Always use ASD-STE100 style. Max 20 words per sentence in instructions, 25 in
descriptions. Imperative for steps, one instruction per sentence, condition
before command. Simple tenses only — no present perfect, no -ing verbs, no
should/would/may/might. Active voice. One word per meaning — no synonym
rotation. No contractions, keep articles and "that". Delete filler: simply,
robust, seamlessly, leverage. Code and identifiers stay exact.

Follow this format:

# Review
[Summary of the changes introduced]
[list of confirmed issues]

[duplicated abstractions helpers]

## Assumptions
[assumptions made during the review]

## Architecture:

[summary of architecural issues]
for each issues:

# [number] [Title] (LOW-HIGH)

## Summary

## Test case

Test case:
```
the added failing test
```

## Proposed fix

[Proposed fix]

