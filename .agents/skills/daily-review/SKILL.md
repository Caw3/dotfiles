---
name: daily-review
description: Create a daily Markdown review of open GitHub pull requests, new pull request comments, replies to the user's reviews, merged backstage-portal pull requests, open Linear issues, and comments on Google Docs that the user owns. Use when the user asks for a daily review, work summary, PR review, review replies, merged PR summary, Linear task summary, or document comment summary.
---

# Daily Review

Create one current work report at `~/Documents/daily-review.md`.

## Set the review period

1. Read the existing report when it exists.
2. Use its `Generated` value as the period start.
3. Use the prior 24 hours when the report has no valid value.
4. Use the current local time as the period end.
5. Show both values with the local time zone.

## Get GitHub data

1. Get the GitHub host from the current repository remote or authenticated `gh` hosts.
2. Get the authenticated login from the selected host.
3. Search all repositories for open pull requests from that login.
4. Get each pull request status, review decision, checks, comments, reviews, and review threads.
5. Include new issue comments, reviews, and review-thread comments from the review period.
6. Search open pull requests that the login reviewed.
7. Include new replies after the user's review-thread comments.
8. Include unresolved threads when they need a response from the user.
9. Follow pagination until the search returns all results.
10. Add direct links to pull requests, comments, review replies, and failed checks.
11. Search `backstage-external/backstage-portal` for pull requests merged during the review period.
12. Include each merged pull request title, author, and direct link.
13. Keep the merged pull request overview brief.

Use `GH_HOST=<host> gh search prs` for cross-repository GitHub Enterprise searches.
Use `gh pr view` for pull request data.
Use `gh api graphql` when review-thread comments are not present in the pull request data.

Do not include the user's comments as comments that need a response.
Do not treat bot comments as action items unless they report a failed check or a security problem.

## Get Linear data

1. Use the Linear connector to list issues with `assignee: "me"`.
2. Include issues in active or unstarted states.
3. Exclude completed, canceled, duplicate, and archived issues.
4. Follow pagination until the connector returns all issues.
5. Sort issues by priority and update time.
6. Include the identifier, title, state, priority, due date, and direct link.

If the connector cannot filter all closed states, get more results and filter the returned state values.

## Write the report

Use this structure:

```markdown
# Daily review

Generated: <local ISO date and time with time zone>
Period: <start> to <end>

## Action items

- [<short action>](<direct link>) — <reason>

## My open pull requests

### [<owner/repository>#<number>: <title>](<pull request URL>)

- Status: <draft, review state, and merge state>
- Checks: <failed, pending, or passed summary>
- New comments: <linked summary or None>

## Replies to my reviews

- [<pull request and thread>](<comment URL>) — <author>: <short summary>

## My open Linear issues

- [<identifier>: <title>](<issue URL>) — <state>, <priority>, due <date or None>

## Merged backstage-portal pull requests

- [#<number>: <title>](<pull request URL>) — <author>


## Display the report

Display the report in the chat.
