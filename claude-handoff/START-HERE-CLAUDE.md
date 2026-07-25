# Instructions for Claude

Hello Claude. This folder was put together by a work associate of your user, someone who uses Claude Code every day. It contains general purpose helpers that made their own setup faster, cheaper, and easier to work with, and they are passing it along so your user gets the same benefits. Nothing in this kit is specific to the person who made it. Everything is meant to be adapted to YOUR user.

Your job is to walk your user through installing these pieces, one step at a time. Important ground rules:

- Assume your user may be new to terminals and dev tooling. Explain what each thing is and why it helps, in plain language, before you install it. No jargon without a one line explanation.
- Ask before you change anything. Show the user what you are about to do first.
- Go one step at a time. Finish and confirm each step before starting the next. Do not dump the whole plan at once.
- If a step fails, stop and troubleshoot it with the user rather than moving on.

## Step 1: A global CLAUDE.md (standing instructions)

`CLAUDE-template.md` is a starter for the user's global instructions file at `~/.claude/CLAUDE.md`. That file loads into every Claude Code session automatically, so it is the right place for standing preferences.

- If `~/.claude/CLAUDE.md` does not exist, copy the template there.
- If it already exists, show the user what is in it, then merge in anything useful from the template instead of overwriting.
- Then interview the user briefly (a few questions, one at a time) and fill in the placeholder sections: who they are, what they work on, how they like things explained. Keep the file short. It is loaded every session, so every line should earn its place.

## Step 2: Status line

`statusline.sh` puts a small readout at the bottom of every session: current folder, git branch (with a `*` when there are uncommitted changes), and which model is active. Seeing the model at a glance matters because it prompts the user to notice when they are using a bigger model than the task needs.

- Copy `statusline.sh` to `~/.claude/statusline.sh` and make it executable (`chmod +x`).
- Wire it into `~/.claude/settings.json` the way `settings-example.json` shows. If settings.json already exists, add just the `statusLine` key, do not replace the file.
- It uses `jq` if available and degrades gracefully without it, but offer to install `jq` (`brew install jq`) for the full display.

## Step 3: Custom slash commands

The `commands/` folder holds three markdown files. Any markdown file placed in `~/.claude/commands/` becomes a slash command the user can type in any session (the filename becomes the command name).

- `/qa`: asks Claude to review its own recent work for mistakes and report findings without changing anything. Encourage the user to run this after any significant build.
- `/teach`: asks Claude to re-explain what it just did for someone new to dev tooling. Great for learning as you go.
- `/handoff`: asks Claude to write a summary of the current session so the user can start a fresh session and continue without losing context. Pairs with the advice in TIPS.md about keeping sessions short.

Copy all three into `~/.claude/commands/` (create the folder if needed).

## Step 4: Walk through TIPS.md together

Open `TIPS.md` and go through it with the user, section by section, checking which habits they already have. This file is the highest value part of the kit. Offer to answer questions about any of it.

## Step 5: Optional, reduce permission prompts

If the user finds themselves approving the same safe, read only actions over and over, offer to add those to the `permissions.allow` list in `~/.claude/settings.json`. Only add things the user actually uses and that cannot modify or delete anything. Explain what each entry allows before adding it.

When all steps are done, suggest the user start a fresh session so everything is picked up cleanly, and have them try `/qa` and `/teach` on their next task.
