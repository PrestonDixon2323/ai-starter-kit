# Using Claude effectively: the habits that matter

The scripts in this kit help, but these habits are where most of the value is. They come from months of daily use. Each one saves either money (usage limits), time, or quality.

## 1. Keep sessions short and focused

Claude reads the entire conversation every time it responds. A long, wandering session makes every response slower, more expensive against your usage limits, and often worse, because old irrelevant stuff crowds out what matters now.

- One task or topic per session. When you switch to something unrelated, type `/clear` to start fresh.
- Mid task but the session is getting long? `/compact` squeezes the history down while keeping what matters.
- Ending for the day mid project? Run `/handoff` (from this kit) so Claude writes itself a note, then start clean next time and tell it to read HANDOFF.md. (Claude Code also has `/resume` to reopen a past session exactly where it left off, useful when you closed the terminal by accident.)

This single habit is the biggest efficiency win on this list.

## 2. Match the model to the task

Type `/model` to see what is available and switch. The rule of thumb:

- Biggest model: planning, architecture, hard debugging, anything where a wrong answer is expensive.
- Middle: everyday building and editing. This is the right default for most work.
- Smallest and fastest: renaming, reformatting, simple questions, quick lookups.

Running the biggest model for everything burns through usage limits fast. The status line in this kit shows the active model at all times, so glance at it when starting a task.

## 3. Give Claude the goal, not the steps

"Make the contact form send me an email when submitted" beats "open form.js and add a function on line 40." Claude is better at finding the path than you are at dictating it, and step by step micromanagement wastes turns. State the outcome, the constraints, and anything you already know, then let it work.

Same idea with errors: paste the entire error message verbatim instead of describing it. Claude reads error text better than summaries of it.

## 4. Plan first on anything big

For anything beyond a small edit, ask Claude to make a plan before touching anything: "Before you change anything, give me a plan and wait for my ok." Reviewing a plan takes one minute. Unwinding a wrong build takes an hour. Claude Code also has a built in plan mode that keeps Claude read only while planning; ask Claude to use it.

## 5. Put standing instructions in CLAUDE.md, not in every prompt

Anything you find yourself repeating ("explain jargon," "plain text for emails," "ask before installing things") belongs in `~/.claude/CLAUDE.md`, which loads into every session automatically. A project folder can have its own CLAUDE.md too, for stuff specific to that project.

Two cautions: keep these files short (they cost context in every session), and prune them when things change. Stale instructions quietly make Claude worse.

## 6. Use memory

Tell Claude "remember this" when you settle something you will want later: a preference, a decision, where something lives. Claude Code has persistent memory across sessions and will save it. If Claude keeps getting the same thing wrong, correct it once and say "remember this so it doesn't happen again."

## 7. Make your own slash commands

Any prompt you type regularly can become a command. Drop a markdown file in `~/.claude/commands/` and the filename becomes a slash command in every session. This kit ships three (`/qa`, `/teach`, `/handoff`). When you notice yourself typing the same request a third time, ask Claude to turn it into a command for you.

## 8. Have Claude check its own work

After any significant build, run `/qa`. Claude finds a surprising number of its own mistakes when explicitly asked to look, especially things it claimed were done but never actually verified. Make it a reflex: build, then QA, then done.

## 9. Ask Claude about Claude

Claude Code knows its own features. "How do I do X in Claude Code," "what does /compact do," "set up a nicer status line for me" all work. When you are not sure whether something is possible, asking costs one prompt.

## 10. Approve less, but carefully

If Claude keeps asking permission for the same harmless read only things, have it add those to the allow list in your settings (see `settings-example.json`). Do not blanket approve write or delete permissions to make prompts go away. The prompts on destructive actions are the guardrail you will want the one time it matters.
