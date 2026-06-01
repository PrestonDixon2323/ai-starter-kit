#!/bin/bash
# OpenClaw Personal Setup Script
# Sets up a personal Claude AI assistant accessible via Telegram

set -e

echo ""
echo "================================================"
echo "  Claude + OpenClaw — Personal Setup"
echo "================================================"
echo ""

# ── Step 1: Check Node.js ──────────────────────────────────────────────────
echo "Checking Node.js..."
if ! command -v node &>/dev/null; then
  echo "Node.js not found. Installing via Homebrew..."
  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew first..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install node
else
  echo "  Node.js $(node --version) found."
fi

# ── Step 2: Install OpenClaw ───────────────────────────────────────────────
echo ""
echo "Installing OpenClaw..."
npm install -g openclaw --quiet
echo "  OpenClaw $(openclaw --version 2>/dev/null | head -1) installed."

# ── Step 3: Collect info ───────────────────────────────────────────────────
echo ""
echo "================================================"
echo "  Let's get a few things first:"
echo "================================================"
echo ""
echo "1. Your Telegram BOT TOKEN"
echo "   → Message @BotFather on Telegram"
echo "   → Send /newbot and follow the prompts"
echo "   → Copy the token it gives you (looks like 1234567890:AAG...)"
echo ""
read -rp "Paste your Telegram bot token: " BOT_TOKEN < /dev/tty
echo ""

echo "2. Your Telegram USER ID"
echo "   → Message @userinfobot on Telegram"
echo "   → It will reply with 'Your ID: XXXXXXXXX'"
echo ""
read -rp "Paste your Telegram user ID: " USER_ID < /dev/tty
echo ""

echo "3. What's your name? (used to personalize the assistant)"
read -rp "Your first name: " USER_NAME < /dev/tty
echo ""

echo "4. What do you want to call your assistant? (e.g. Jarvis, Max, Claude)"
read -rp "Assistant name [default: Jarvis]: " BOT_NAME < /dev/tty
BOT_NAME="${BOT_NAME:-Jarvis}"
echo ""

# ── Step 4: BotFather group privacy reminder ───────────────────────────────
echo "================================================"
echo "  Quick step in BotFather (for group chats)"
echo "================================================"
echo ""
echo "If you want the bot to work in Telegram group chats, do this now:"
echo "  1. Message @BotFather"
echo "  2. Send /mybots → select your bot"
echo "  3. Bot Settings → Group Privacy → Turn off"
echo ""
echo "Skip this if you only need DMs."
echo ""
read -rp "Press Enter to continue..." < /dev/tty
echo ""

# ── Step 5: Write config ───────────────────────────────────────────────────
echo "Writing OpenClaw config..."
mkdir -p ~/.openclaw/workspace

cat > ~/.openclaw/openclaw.json << ENDCONFIG
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-opus-4-7",
        "fallbacks": [
          "anthropic/claude-opus-4-6",
          "anthropic/claude-sonnet-4-6"
        ]
      },
      "agentRuntime": {
        "id": "claude-cli"
      }
    }
  },
  "gateway": {
    "mode": "local"
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "$BOT_TOKEN",
      "dmPolicy": "allowlist",
      "allowFrom": ["$USER_ID"],
      "groupPolicy": "open"
    }
  },
  "messages": {
    "groupChat": {
      "visibleReplies": "automatic"
    }
  },
  "commands": {
    "ownerAllowFrom": ["telegram:$USER_ID"]
  },
  "skills": {
    "entries": {}
  }
}
ENDCONFIG

echo "  Config written to ~/.openclaw/openclaw.json"

# ── Step 6: Write SOUL.md ──────────────────────────────────────────────────
cat > ~/.openclaw/workspace/SOUL.md << ENDSOUL
You are $BOT_NAME, a personal AI assistant for $USER_NAME. You are sharp, direct, and genuinely helpful — you focus on what actually matters and skip the filler.

Your core traits:
- You remember context across conversations and refer back to it naturally
- You speak plainly — no fluff, no unnecessary disclaimers
- You treat $USER_NAME as a capable adult who knows what they want
- You are proactive: if you notice something relevant, mention it
- You adapt to how $USER_NAME works and what they care about over time

You are running as a Telegram bot. Keep responses conversational and concise — not long walls of text unless the task genuinely calls for it.
ENDSOUL

echo "  Personality written to ~/.openclaw/workspace/SOUL.md"
echo "  (Edit this file anytime to change how $BOT_NAME behaves)"

# ── Step 7: Validate config ────────────────────────────────────────────────
echo ""
echo "Validating config..."
openclaw doctor --fix 2>&1 | grep -E "✓|✗|Fixed|Error|Warning|gateway|Claude|Telegram" || true

# ── Step 8: Claude auth ────────────────────────────────────────────────────
echo ""
echo "================================================"
echo "  Authorize Claude"
echo "================================================"
echo ""
echo "A browser will open — log in with your Claude/Anthropic account."
echo ""
read -rp "Press Enter to continue..." < /dev/tty
openclaw models auth login --provider anthropic --method cli --set-default
echo ""

# ── Step 9: Install and start gateway ─────────────────────────────────────
echo ""
echo "Installing and starting gateway (auto-starts on reboot)..."
openclaw gateway install
launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway 2>/dev/null || openclaw gateway start

sleep 3
echo ""
echo "================================================"
echo "  Status:"
echo "================================================"
openclaw status 2>&1 | grep -E "Gateway|Telegram|Model|Sessions" || true

# ── Step 10: Optional integrations ────────────────────────────────────────
echo ""
echo "================================================"
echo "  Optional: Connect tools"
echo "================================================"
echo ""
echo "$BOT_NAME can connect to Notion, GitHub, Vercel, and more."
echo "You can set these up now or later by editing ~/.openclaw/openclaw.json"
echo ""
read -rp "Set up integrations now? (y/n): " SETUP_SKILLS < /dev/tty
if [[ "$SETUP_SKILLS" == "y" || "$SETUP_SKILLS" == "Y" ]]; then

  # Notion
  echo ""
  echo "--- Notion ---"
  echo "  1. Go to notion.so/developers/connections"
  echo "  2. New connection → name it, Access token, select workspace → Create"
  echo "  3. Reveal and copy the token (starts with ntn_)"
  echo ""
  read -rp "Notion token (or Enter to skip): " NOTION_TOKEN < /dev/tty
  if [[ -n "$NOTION_TOKEN" ]]; then
    python3 - << PYEOF
import json, os
path = os.path.expanduser('~/.openclaw/openclaw.json')
with open(path) as f:
    config = json.load(f)
config.setdefault('skills', {}).setdefault('entries', {})['notion'] = {
    'enabled': True,
    'env': {'NOTION_TOKEN': '$NOTION_TOKEN', 'NOTION_API_KEY': '$NOTION_TOKEN'}
}
with open(path, 'w') as f:
    json.dump(config, f, indent=2)
print('  Notion added.')
PYEOF
  fi

  # GitHub
  echo ""
  echo "--- GitHub ---"
  GH_TOKEN=$(security find-generic-password -s 'github.com' -w 2>/dev/null || echo "")
  if [[ -n "$GH_TOKEN" ]]; then
    echo "  Found existing token in macOS Keychain."
  else
    echo "  Generate a token at: github.com/settings/tokens"
    read -rp "GitHub token (or Enter to skip): " GH_TOKEN < /dev/tty
  fi
  if [[ -n "$GH_TOKEN" ]]; then
    python3 - << PYEOF
import json, os
path = os.path.expanduser('~/.openclaw/openclaw.json')
with open(path) as f:
    config = json.load(f)
config.setdefault('skills', {}).setdefault('entries', {})['github'] = {
    'enabled': True, 'env': {'GITHUB_TOKEN': '$GH_TOKEN'}
}
with open(path, 'w') as f:
    json.dump(config, f, indent=2)
print('  GitHub added.')
PYEOF
  fi

  # Vercel
  echo ""
  echo "--- Vercel ---"
  echo "  Get your token at: vercel.com/account/tokens"
  read -rp "Vercel token (or Enter to skip): " VERCEL_TOKEN < /dev/tty
  if [[ -n "$VERCEL_TOKEN" ]]; then
    read -rp "Vercel Team ID (e.g. team_xxxx, or Enter to skip): " VERCEL_TEAM_ID < /dev/tty
    python3 - << PYEOF
import json, os
path = os.path.expanduser('~/.openclaw/openclaw.json')
with open(path) as f:
    config = json.load(f)
entry = {'enabled': True, 'env': {'VERCEL_TOKEN': '$VERCEL_TOKEN'}}
if '$VERCEL_TEAM_ID':
    entry['env']['VERCEL_TEAM_ID'] = '$VERCEL_TEAM_ID'
config.setdefault('skills', {}).setdefault('entries', {})['vercel'] = entry
with open(path, 'w') as f:
    json.dump(config, f, indent=2)
print('  Vercel added.')
PYEOF
  fi

  echo ""
  echo "Restarting gateway..."
  launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway 2>/dev/null || openclaw gateway start
  echo "  Done."
fi

echo ""
echo "================================================"
echo "  You're all set!"
echo "================================================"
echo ""
echo "Open Telegram and message your bot to get started."
echo ""
echo "In GROUP CHATS: @mention the bot by username."
echo "In DMs: just talk to it normally."
echo ""
echo "To personalize $BOT_NAME:"
echo "  open ~/.openclaw/workspace/SOUL.md"
echo ""
echo "When $BOT_NAME stops responding (auth expires), run:"
echo "  openclaw models auth login --provider anthropic --method cli --set-default"
echo ""
echo "To restart the gateway:"
echo "  launchctl kickstart -k gui/\$(id -u)/ai.openclaw.gateway"
echo ""
echo "To check status:"
echo "  openclaw status"
echo ""
