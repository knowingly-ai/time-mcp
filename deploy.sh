#!/bin/bash

echo "🕐 Time MCP - Deployment Script"
echo "================================"
echo ""

# Install dependencies
echo "Installing dependencies..."
npm install

echo ""

# Check if user is logged in
echo "Checking Cloudflare authentication..."
if ! npx wrangler whoami &> /dev/null; then
    echo "Not logged in. Opening browser for authentication..."
    npx wrangler login
fi

echo ""
echo "Deploying Worker..."
npx wrangler deploy

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Next steps:"
echo "1. Copy the Worker URL from above"
echo "2. Add it to your Claude Desktop config (see README.md)"
echo "3. Update the path to time-mcp-server.js in your config"
echo "4. Restart Claude Desktop"
echo ""
echo "See README.md for full instructions."
