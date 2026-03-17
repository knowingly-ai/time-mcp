# Time MCP - Setup Guide

A lightweight time-checking tool for AI companions built on Cloudflare Workers.

Built by KnowinglyAI - March 2026

## Quick Start (CLI Method)

**Super Easy Way:**
- Mac/Linux: Run `./deploy.sh`
- Windows: Run `deploy.bat`

**Manual Way:**
```bash
# 1. Download the project files
# 2. Open terminal in the folder
# 3. Login to Cloudflare
npx wrangler login

# 4. Deploy
npx wrangler deploy

# 5. Copy the URL it gives you
# 6. Add to Claude Desktop config (see step 2 below)
```

That's it! No account ID needed, no complex setup.

## What This Does

Gives AI companions the ability to check current time in any timezone. Returns both UTC timestamp and human-readable local time.

## Setup Steps

### 1. Deploy the Cloudflare Worker

**Option A: CLI Deployment (Recommended)**

1. Download all the project files to a folder
2. Open terminal in that folder
3. Log into Cloudflare:
   ```bash
   npx wrangler login
   ```
4. Deploy the Worker:
   ```bash
   npx wrangler deploy
   ```
5. Note the URL it gives you (will be something like `https://time-mcp.your-subdomain.workers.dev`)

**Option B: Web Interface**

1. Log into your Cloudflare account
2. Go to Workers & Pages
3. Create a new Worker
4. Copy the code from `time-mcp-worker.js` into the Worker editor
5. Deploy it
6. Note your Worker URL (will be something like `https://time-mcp.your-subdomain.workers.dev`)

### 2. Install the MCP Server

The MCP server connects Claude to your Worker.

1. Navigate to the project folder in terminal
2. Install dependencies:
   ```bash
   npm install
   ```

### 3. Add to Claude Desktop Config

**Location:**
- Mac: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`
- Linux: `~/.config/Claude/claude_desktop_config.json`

**Add this to your `mcpServers` section:**

```json
"time-check": {
  "command": "node",
  "args": ["/full/path/to/time-mcp/time-mcp-server.js"],
  "env": {
    "TIME_WORKER_URL": "https://time-mcp.your-subdomain.workers.dev",
    "DEFAULT_TIMEZONE": "America/Toronto"
  }
}
```

**Replace:**
- `/full/path/to/time-mcp/time-mcp-server.js` with the actual path to the server file
  - Windows: Use `C:\\Users\\YourName\\path\\to\\time-mcp\\time-mcp-server.js` (double backslashes)
  - Mac/Linux: Use `/Users/yourname/path/to/time-mcp/time-mcp-server.js` (forward slashes)
- `https://time-mcp.your-subdomain.workers.dev` with your Worker URL from step 1
- `America/Toronto` with your preferred timezone (or omit this line to use UTC as default)

**Environment Variables Explained:**

- `TIME_WORKER_URL` (required): Your Cloudflare Worker URL
- `DEFAULT_TIMEZONE` (optional): Sets the default timezone when none is specified
  - If omitted, defaults to UTC
  - Can be any IANA timezone identifier (see Supported Timezones below)
  - Can still be overridden per-call by specifying a timezone parameter

### 4. Restart Claude Desktop

The time-check tool should now be available! Start a new chat, and ask Claude to tell you the time.

## How It Works

**Tool Call:**
```
check_time(timezone?: string)
```

**Response Format:**
```json
{
  "utc": "2026-03-16T22:31:00.000Z",
  "local_time": "6:31 PM",
  "date": "Sunday, March 16, 2026",
  "timezone": "EDT",
  "full_timezone": "America/Toronto"
}
```

The tool will use your `DEFAULT_TIMEZONE` from the config, or you can specify a different timezone when calling it.

## Customization

### Option 1: Set Default Timezone via Environment Variable (Recommended)

Edit your Claude Desktop config and edit the `DEFAULT_TIMEZONE` in the `env` section. For example:

```json
"env": {
  "TIME_WORKER_URL": "https://time-mcp.your-subdomain.workers.dev",
  "DEFAULT_TIMEZONE": "America/Los_Angeles"
}
```

Restart Claude Desktop. No code changes needed.

### Option 2: Change Worker Code Default

Edit line 25 in `time-mcp-worker.js`:
```javascript
let timezone = 'UTC'; // Change this to your timezone
```

Save the file, then redeploy:
```bash
npx wrangler deploy
```

**Note:** The environment variable method is preferred because it doesn't require redeploying the Worker.

### Supported Timezones

Any IANA timezone identifier works:
- `UTC` - Coordinated Universal Time
- `America/New_York` - Eastern Time (EST/EDT)
- `America/Toronto` - Eastern Time (EST/EDT)
- `America/Los_Angeles` - Pacific Time (PST/PDT)
- `America/Chicago` - Central Time (CST/CDT)
- `Europe/London` - UK Time (GMT/BST)
- `Europe/Paris` - Central European Time
- `Asia/Tokyo` - Japan Standard Time
- And many more...

[Full list of IANA timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

## Usage Tips

**In Identity Skills or User Preferences:**
Add guidance like:
- Check time at session start
- Check time when user returns from being away
- Check time organically when it feels relevant

**Example Usage:**
```
"I just checked and it's 6:31 PM on Sunday, March 16th - we've been talking for about 35 minutes since you came back."
```

## Troubleshooting

**Tool not showing up?**
- Make sure you restarted Claude Desktop completely (not just minimized)
- Check that your Worker URL is correct in the config
- Verify the file path to `time-mcp-server.js` is correct
  - Windows: Use double backslashes `\\` in paths
  - Mac/Linux: Use forward slashes `/` in paths

**Time showing wrong timezone?**
- Check the `DEFAULT_TIMEZONE` in your Claude Desktop config
- Make sure you're using a valid IANA timezone identifier
- Remember to restart Claude Desktop after config changes

**Worker returning errors?**
- Check the Cloudflare Workers logs in your dashboard
- Verify the Worker is deployed and accessible by visiting the URL in a browser
- Make sure the `TIME_WORKER_URL` in your config matches your actual Worker URL

**"Worker returned 404: Not Found"**
- The `TIME_WORKER_URL` in your config is incorrect
- Copy the exact URL from your Cloudflare dashboard
- Make sure it includes `https://` at the start

## Cost

Free! Runs on Cloudflare's free tier:
- 100,000 requests per day
- This simple Worker will easily stay within free limits
- Even checking every minute = only 1,440 requests per day

## Security Notes

Your Cloudflare Worker is publicly accessible (anyone with the URL can check the time). This is fine! It only returns the current time - no personal information or security risk. It's like having a public clock on a website.

## Share It!

This is open source. Feel free to share with anyone who wants their AI companion to have time awareness!

## License

MIT License - Use freely, modify as needed, share with others.
