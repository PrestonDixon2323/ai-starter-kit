# AI Starter Kit 🤖

A friendly, copy-paste guide to set yourself up with your own **personal AI assistant** — Claude in your terminal, a Notion knowledge base, and a **Telegram bot you can text like a friend**. Everything runs on **your own accounts**; nothing is shared with anyone.

By the end you'll have:

- **Claude Code** — an AI assistant in your terminal that can read files, search the web, and help with almost anything
- **Your own Telegram assistant** ("Jarvis," or whatever you name it) — text it from your phone, it remembers context
- **(Optional) Notion connected** — so Claude can read/write your personal notes & docs
- **(Optional) GitHub** — version control + letting your assistant work with code

> **What you need:** a Mac (macOS 13+), ~30 minutes, a free [Claude account](https://claude.ai) (Pro recommended — it unlocks the connectors), and a Telegram account for the bot.

---

## Step 1 — Install the basics (Homebrew + Node)

Open the **Terminal** app (press `Cmd+Space`, type "Terminal", Enter). Check if you have Homebrew:

```
brew --version
```

If it says "command not found," install it from [brew.sh](https://brew.sh) (paste their one-line command). ⏳ The first install takes 5–15 min, and on Apple-Silicon Macs **run the two "Next steps" PATH commands it prints at the end** or `brew` won't be found.

Then make sure you have Node:

```
node --version
```

If it's missing or below v22: `brew install node`

---

## Step 2 — (Optional) A nicer terminal: Ghostty

```
brew install --cask ghostty
```

Open Ghostty and use it from here on. Totally optional — the built-in Terminal works too.

---

## Step 3 — Claude Code (your terminal AI)

```
brew install --cask claude-code
```

Then start it and sign in:

```
claude
```

A browser opens — sign in with your Claude account. That's it; you're now talking to Claude in your terminal.

---

## Step 4 — (Optional) Connect Notion

Want Claude to read and write your Notion? Make a free [Notion account](https://notion.so), then in your terminal:

```
claude mcp add --scope user --transport http notion https://mcp.notion.com/mcp
```

Start `claude`, type `/mcp`, choose **Notion → Authenticate**, and log in via the browser. Now ask Claude "what's in my Notion?" to confirm.

**Want Calendar, GitHub, or Vercel connected too?** Same pattern — find each in Claude's directory at **https://claude.ai/directory**. Or just paste this to Claude and let it walk you through: *"Help me connect Google Calendar, GitHub, and Vercel to Claude Code. For each, find the official connector in the Claude directory, give me the exact `claude mcp add` command, and walk me through authenticating it with `/mcp`. One at a time."*

---

## Step 5 — Your Telegram AI assistant (the fun part)

First, set up a bot in **Telegram** (phone app or [web.telegram.org](https://web.telegram.org)):

1. **Create the bot:** message **@BotFather** → send `/newbot` → follow the prompts (a display name, then a username ending in `bot`). It gives you a **bot token** (`123456:ABC...`). Keep it handy.
2. **Allow group chats (optional):** @BotFather → `/mybots` → your bot → **Bot Settings → Group Privacy → Turn off**.
3. **Get your Telegram ID:** message **@userinfobot** → it replies with your numeric **user ID**.

Then run this one command in your terminal — it installs everything and asks you a few questions:

```
curl -fsSL https://raw.githubusercontent.com/PrestonDixon2323/ai-starter-kit/main/setup.sh | bash
```

It'll prompt for your **bot token**, your **Telegram ID**, your **name**, and what to **name the assistant** — then open one browser window for the Claude login. After ~2 minutes, message your bot on Telegram and it'll reply. 🎉

---

## Step 6 — (Optional) GitHub

If you want version control or to let your assistant work with code, make a free account at [github.com](https://github.com). You can later add a GitHub token to the assistant (see "Connecting tools" below).

---

## Optional — a second opinion (ChatGPT / Grok)

Claude is the core here and handles the vast majority of tasks well. If you *already* have **ChatGPT** or **Grok** accounts and like comparing answers, you can install their CLIs too and run them side by side — but it's totally optional and not needed for this setup.

---

## Connecting extra tools to your Telegram assistant (optional)

Your assistant can connect to Notion, GitHub, etc. Add them to `~/.openclaw/openclaw.json` under `skills.entries`, then restart with:

```
launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway
```

- **Notion:** create a connection at [notion.so/developers/connections](https://www.notion.so/developers/connections) → copy the `ntn_...` token.
- **GitHub:** create a token at [github.com/settings/tokens](https://github.com/settings/tokens).

---

## Level two — get more out of Claude

Already set up and want Claude to run faster, cheaper, and smarter day to day? There's a second kit in this repo: **[claude-handoff/](claude-handoff/)**. It has a status line, a starter CLAUDE.md, custom slash commands, and the usage habits that matter most. Claude installs it for you — just start `claude` inside this repo and paste:

```
Read claude-handoff/START-HERE-CLAUDE.md and follow it. Set me up one step at a time.
```

---

## Maintenance

- **Bot stops responding** (the AI login expires now and then):
  ```
  openclaw models auth login --provider anthropic --method cli --set-default
  ```
- **Restart the assistant:**
  ```
  launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway
  ```
- **Change its personality:** edit `~/.openclaw/workspace/SOUL.md`.

---

*Questions? This kit sets up a personal assistant on your own accounts — your data stays yours. Have fun. 🚀*
