# Claude Handoff Kit

You already have Claude Code installed (if not, do the main [AI Starter Kit](../README.md) first). This folder is level two: helpers and habits that make Claude noticeably more effective and cheaper to run day to day.

It was put together by a work associate who uses Claude Code daily and wanted to pass along the setup that made the biggest difference. Nothing in here touches anyone else's accounts. Everything runs on your machine, under your login.

## How to use it (2 minutes)

1. Open your terminal and grab this repo if you have not already:

```
git clone https://github.com/PrestonDixon2323/ai-starter-kit
cd ai-starter-kit
```

2. Start Claude:

```
claude
```

3. Paste this one line to Claude:

```
Read claude-handoff/START-HERE-CLAUDE.md and follow it. Set me up one step at a time.
```

That is it. Claude will read the instructions meant for it, explain each piece, and ask you before it changes anything.

## What is inside

| File | What it is |
|---|---|
| `START-HERE-CLAUDE.md` | Instructions addressed to your Claude, telling it how to install everything below |
| `CLAUDE-template.md` | A starter global CLAUDE.md, your standing instructions that load into every session |
| `statusline.sh` | A status line showing your current folder, git branch, and which model you are on |
| `settings-example.json` | Shows how the status line gets wired into settings |
| `commands/` | Three custom slash commands: `/qa`, `/teach`, `/handoff` |
| `TIPS.md` | The habits that matter most: managing context, picking models, using memory |

Read `TIPS.md` yourself too. The tools help, but the habits in there are where most of the value is.
