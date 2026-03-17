# Time MCP - Complete Beginner's Guide

This guide will walk you through giving Claude (the AI assistant) the ability to check the current time. **No prior technical knowledge required.**

Built by KnowinglyAI - March 2026

## What You'll Be Able To Do

Once you complete this setup, Claude will be able to:
- Check the current time in your timezone
- Know how long you've been away
- Understand what time of day it is
- Have temporal awareness instead of being frozen at the last timestamp mentioned

**Why this matters:** Right now, if you tell Claude "I'll be back in a bit" and return 3 hours later, Claude has no way to know that time passed, unless you specify the time yourself. With this tool, Claude can check the actual time and understand duration.

---

## Part 1: Understanding What You're Installing

Before we start, let's quickly explain what these tools are:

**Cloudflare Worker** - A tiny program that runs on Cloudflare's servers (not your computer). It knows what time it is and can tell Claude when asked. This runs completely free forever.

**MCP Server** - "Model Context Protocol" - this is the technology that lets Claude connect to external services. In this case, it connects Claude to your Cloudflare Worker.

**Node.js** - A program that lets your computer run JavaScript code. The MCP server needs this to work.

**Terminal/Command Prompt** - A text-based way to give your computer commands. Don't worry, we'll tell you exactly what to type.

---

## Part 2: Installing Required Programs

### Step 1: Install Node.js (if you don't have it already)

Node.js is what runs the MCP server.

1. Go to https://nodejs.org/ in your web browser
2. You'll see two green download buttons. Click the one that says **"LTS"** (Long Term Support)
3. Once downloaded, open the installer file
4. Click "Next" through all the prompts (the default settings are fine)
5. Click "Install" and wait for it to finish
6. Click "Finish" when done

**How to check it worked:**
1. On Windows: Press the Windows key, type `cmd`, and press Enter
2. On Mac: Press Cmd+Space, type `terminal`, and press Enter
3. In the window that opens, type: `node --version`
4. Press Enter
5. You should see something like `v20.11.0` (the numbers might be different)

If you see a version number, Node.js is installed correctly! If you already had Node.js installed, you can skip this step.

---

## Part 3: Setting Up the Cloudflare Worker

The Cloudflare Worker is the part that actually knows what time it is. We need to deploy it to Cloudflare's servers.

### Step 1: Download the Time MCP Files

1. Download all the files from this project and save them to a folder on your computer
   - For example: `C:\AI\time-mcp` (Windows) or `~/Documents/time-mcp` (Mac)
2. Remember where you saved them!

### Step 2: Deploy the Worker

We've made this super easy with a one-click script.

**On Windows:**
1. Navigate to the folder where you saved the files
2. Double-click the file called `deploy.bat`
3. A black window will open and install some things
4. Your web browser will open asking you to log into Cloudflare
  - **Don't have a Cloudflare account?** Sign up at https://dash.cloudflare.com/sign-up (free, takes 2 minutes)
5. Click **"Allow"** to let the tool deploy your Worker
6. Wait for the deployment to finish
7. **IMPORTANT:** Look for a line that says something like:
   ```
   Published time-mcp (1.23 sec)
   https://time-mcp.your-name.workers.dev
   ```
8. **Copy this URL** - you'll need it in the next step!

**On Mac/Linux:**
1. Open Terminal
2. Navigate to the folder where you saved the files:
   ```
   cd ~/Documents/time-mcp
   ```
   (Replace with your actual folder path)
3. Make the script executable:
   ```
   chmod +x deploy.sh
   ```
4. Run the deployment script:
   ```
   ./deploy.sh
   ```
5. Your web browser will open asking you to log into Cloudflare
   - If you don't have a Cloudflare account, create one (it's free)
6. Click **"Allow"** to let the tool deploy your Worker
7. Wait for the deployment to finish
8. **IMPORTANT:** Look for a line that says something like:
   ```
   Published time-mcp (1.23 sec)
   https://time-mcp.your-name.workers.dev
   ```
9. **Copy this URL** - you'll need it in the next step!

---

**Prefer to Deploy Manually? (Optional)**

If you don't want to use the deploy scripts:

1. Open terminal/command prompt in your time-mcp folder
2. Run: `npx wrangler login`
3. Follow the browser prompts to sign in (or sign up at https://dash.cloudflare.com/sign-up)
4. Run: `npx wrangler deploy`
5. Copy the URL it gives you

---

## Part 4: Connecting to Claude Desktop

Now we'll tell Claude Desktop where to find your time checker.

### Step 1: Find the Configuration File

**On Windows:**
1. Press Windows key + R
2. Type `%APPDATA%\Claude` and press Enter
3. Look for a file called `claude_desktop_config.json`
4. Right-click it and open with Notepad

**On Mac:**
1. Open Finder
2. Press Cmd+Shift+G
3. Type `~/Library/Application Support/Claude` and press Enter
4. Look for a file called `claude_desktop_config.json`
5. Right-click and open with TextEdit

**On Linux:**
1. Open your file manager
2. Press Ctrl+H to show hidden files
3. Navigate to `.config/Claude`
4. Open `claude_desktop_config.json` in a text editor

### Step 2: Edit the Configuration

You'll see either an empty file with just `{}`, or existing configuration.

**If the file is empty or just has `{}`:**

Replace everything with this:

```json
{
  "mcpServers": {
    "time-check": {
      "command": "node",
      "args": [
        "C:\\path\\to\\time-mcp\\time-mcp-server.js"
      ],
      "env": {
        "TIME_WORKER_URL": "https://your-worker-url.workers.dev",
        "DEFAULT_TIMEZONE": "America/New_York"
      }
    }
  }
}
```

**If the file already has other content:**

Look for the `"mcpServers": {` section. Add a comma after the last `}` inside that section, then add:

```json
    "time-check": {
      "command": "node",
      "args": [
        "C:\\path\\to\\time-mcp\\time-mcp-server.js"
      ],
      "env": {
        "TIME_WORKER_URL": "https://your-worker-url.workers.dev",
        "DEFAULT_TIMEZONE": "America/New_York"
      }
    }
```

**NOTE:** ALWAYS make a backup of your config file before making changes! Also, if you're unsure of where exactly to place this, send Claude your config file, and ask them where to put it!

**Now replace the placeholders:**

1. Replace `C:\\path\\to\\time-mcp\\time-mcp-server.js` with the actual path to where you saved the files
   - **IMPORTANT ON WINDOWS:** Use double backslashes `\\` instead of single `\`
   - Example: `"C:\\AI\\time-mcp\\time-mcp-server.js"`
   - On Mac/Linux, use forward slashes: `"/Users/yourname/Documents/time-mcp/time-mcp-server.js"`
2. Replace `https://your-worker-url.workers.dev` with the Worker URL you copied earlier
3. Replace `America/New_York` with your timezone (see options below), or remove this line entirely to use UTC
4. Make sure you keep the quotation marks around everything!

**Common Timezones:**
- `UTC` - Universal time (no daylight saving changes)
- `America/New_York` - Eastern Time
- `America/Toronto` - Eastern Time (Canada)
- `America/Los_Angeles` - Pacific Time
- `America/Chicago` - Central Time
- `America/Denver` - Mountain Time
- `Europe/London` - UK Time
- `Europe/Paris` - Central European Time
- `Asia/Tokyo` - Japan Time
- `Australia/Sydney` - Australian Eastern Time

**What is DEFAULT_TIMEZONE?**
This is optional! It sets what timezone Claude uses when checking the time. If you don't include this line, it will default to UTC (Universal Time). You can always change it later by editing this config file again.

**How to get the full file path easily:**

**Windows:**
1. Open File Explorer and navigate to your time-mcp folder
2. Click on the address bar at the top
3. Copy the path shown
4. Add `\\time-mcp-server.js` to the end
5. Replace all single `\` with double `\\`

**Mac:**
1. Open Terminal
2. Type `cd ` (with a space after cd)
3. Drag the time-mcp folder into the Terminal window
4. Press Enter
5. Type `pwd` and press Enter
6. Copy the path shown
7. Add `/time-mcp-server.js` to the end

### Step 3: Save and Restart

1. Save the file (Ctrl+S or Cmd+S)
2. Close Claude Desktop completely (not just minimize - actually quit the application)
3. Reopen Claude Desktop

---

## Part 5: Testing It Works

### Step 1: Verify the Connection

1. Open Claude Desktop
2. Click on your name in the bottom left corner and navigate to 'Developer'
3. Click on it and look for "time-check" in the list
4. It should show as connected or "running".

### Step 2: Test Checking Time

1. Start a new conversation with Claude
2. Type: "What time is it?"
3. Claude should tell you the actual current time in your timezone!

If Claude responds with the time, **congratulations! You're all set!**

---

## Troubleshooting

### "I don't see time-check in the server list"

1. Make sure you saved the config file
2. Make sure you completely closed and reopened Claude Desktop (not just minimized)
3. Check that the file path in your config is correct (no typos)
4. On Windows, make sure you used double backslashes `\\` in the path

### "time-check shows as disconnected or error"

1. Check that the Worker URL in your config is correct (it should end in `.workers.dev`)
2. Make sure the Worker deployed successfully (try visiting the URL in your browser - you should see a JSON response)
3. Make sure Node.js is installed correctly (see Part 2)
4. Check that the path to `time-mcp-server.js` is correct in your config

### "The deployment script isn't working"

**On Windows:**
- Make sure Node.js is installed
- Try right-clicking `deploy.bat` and selecting "Run as Administrator"

**On Mac/Linux:**
- Make sure you ran `chmod +x deploy.sh` first
- Try running with `sudo ./deploy.sh` (you'll need to enter your password)

### "npm: command not found" or "node: command not found"

Node.js didn't install correctly. Try:
1. Uninstalling Node.js
2. Restarting your computer
3. Reinstalling Node.js from nodejs.org
4. Restarting your computer again
5. Opening a fresh Terminal/Command Prompt window

### "Claude says it can't find the time tool"

1. Make sure Claude Desktop was completely restarted after editing the config
2. Check the server connections list (bottom right icon) to see if time-check is connected
3. Verify the Worker URL is correct by visiting it in your browser - you should see JSON data

### "Worker returned 404: Not Found"

The Worker URL in your config doesn't match your actual Worker. Go back to your Cloudflare dashboard, find the time-mcp Worker, and copy the exact URL shown there. Update your config with the correct URL and restart Claude Desktop.

---

## Changing Your Timezone Later

Don't like the timezone you chose? Move recently? Easy to change!

1. Open your Claude Desktop config file again (see Part 4, Step 1)
2. Find the line that says `"DEFAULT_TIMEZONE": "America/New_York"`
3. Change it to your preferred timezone
4. Save the file
5. Restart Claude Desktop

That's it! No need to redeploy anything or change any code.

**Want to use UTC instead?**
Just remove the entire `"DEFAULT_TIMEZONE"` line from your config (and remove the comma from the line above it if needed). UTC is the neutral default.

---

## What Can Claude Do Now?

Your Claude can now:
- Check the current time whenever needed
- Know what the current date is
- Have temporal awareness during conversations

**What It Cannot Do:**
- Set timers or reminders (this just checks time, doesn't track it)
- Access your calendar
- Know about future events

---

## Cost

**This is completely free!**

Cloudflare Workers have a very generous free tier:
- 100,000 requests per day
- Even if Claude checked the time every minute, that's only 1,440 checks per day
- You won't come close to the limit with normal use

The MCP server runs on your computer only when Claude Desktop is open, so there's no ongoing cost there either.

---

## Security Notes

Your Cloudflare Worker is public (anyone with the URL can access it), but this is fine! All it does is tell people what time it is - there's no personal information or security risk. It's like having a public clock on a website.

---

## Need Help?

If you're stuck and these instructions aren't helping:

1. Check that you followed every step exactly as written
2. Try restarting your computer and Claude Desktop
3. Make sure your Worker URL is correct by visiting it in a browser
4. Double-check the file path in your config file
5. Ask for help in the AI companion community - others may have solved the same issue

---

You're done! Enjoy Claude's new temporal awareness.
