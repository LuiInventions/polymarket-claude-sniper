Write-Host "=================================="
Write-Host " Polymarket Claude Sniper - Setup"
Write-Host "=================================="
Write-Host "Please provide your API Keys and Credentials. Press Enter to leave a value empty."
Write-Host ""

$polyKey = Read-Host "Polymarket Private Key (0x...)"
$polyFunder = Read-Host "Polymarket Funder / Public Address (0x...)"
$polyRpc = Read-Host "Polygon RPC URL (e.g. Alchemy) (https://...)"
$binanceKey = Read-Host "Binance API Key"
$binanceSecret = Read-Host "Binance Secret Key"
$claudeModel = Read-Host "Which AI model should be used? (Default: claude-3-7-sonnet-20250219)"

if ([string]::IsNullOrWhiteSpace($claudeModel)) {
    $claudeModel = "claude-3-7-sonnet-20250219"
}

Write-Host "`nCreating .env file..."
$envTemplate = @"
# ============================================================
# TRADING MODE
# ============================================================
MODE=live
LOG_LEVEL=INFO

# ============================================================
# POLYMARKET
# ============================================================
POLY_PRIVATE_KEY=$polyKey
POLY_FUNDER=$polyFunder
POLY_SIGNATURE_TYPE=1

# Polymarket CLOB
POLY_CLOB_HOST=https://clob.polymarket.com
POLY_CHAIN_ID=137

# ============================================================
# POLYGON RPC
# ============================================================
POLYGON_RPC_URL=$polyRpc

# ============================================================
# BINANCE
# ============================================================
BINANCE_API_KEY=$binanceKey
BINANCE_SECRET_KEY=$binanceSecret

# ============================================================
# STRATEGY PARAMETERS
# ============================================================
ASSETS=BTC,ETH,SOL,XRP
TIMEFRAMES=5m,15m
MAX_TRADE_PCT=50
MAX_CONCURRENT_POSITIONS=8
DAILY_LOSS_LIMIT=-50.0
MIN_COMPOSITE_SCORE=35
MIN_DELTA_PCT=0.07
MAX_TOKEN_PRICE=0.65

# ============================================================
# ORACLE SOURCE
# ============================================================
ORACLE_SOURCE=polymarket
"@
$envTemplate | Out-File -FilePath .env -Encoding UTF8
Write-Host "[OK] .env successfully created."


Write-Host "`nCreating .mcp.json file..."
$mcpTemplate = @"
{
  "mcpServers": {
    "binance": {
      "type": "stdio",
      "command": "python",
      "args": ["./mcp_servers/binance-mcp/run_server.py"],
      "env": {
        "BINANCE_API_KEY": "$binanceKey",
        "BINANCE_SECRET_KEY": "$binanceSecret"
      }
    },
    "polymarket": {
      "type": "stdio",
      "command": "cmd",
      "args": ["/c", "node", "./mcp_servers/polymarket-mcp/dist/index.js"],
      "env": {
        "POLYMARKET_PRIVATE_KEY": "$polyKey",
        "POLYMARKET_KEY": "$polyKey",
        "POLYMARKET_FUNDER": "$polyFunder",
        "POLYMARKET_RPC_URL": "$polyRpc",
        "CHAIN_ID": "137",
        "CLOB_HOST": "https://clob.polymarket.com"
      }
    }
  }
}
"@
$mcpTemplate | Out-File -FilePath .mcp.json -Encoding UTF8
Write-Host "[OK] .mcp.json successfully created."

Write-Host "`nUpdating model in run.bat..."
if (Test-Path run.bat) {
    (Get-Content run.bat) -replace '--model \S+', "--model $claudeModel" | Out-File run.bat -Encoding UTF8
    Write-Host "[OK] run.bat model set to: $claudeModel"
}

Write-Host "`nAutomatically installing Python dependencies (pip)..."
pip install -r requirements.txt

Write-Host "`nAutomatically installing and building Polymarket MCP (Node.js)..."
Set-Location mcp_servers\polymarket-mcp
npm install
npm run build
Set-Location ..\..

Write-Host "`n=================================="
Write-Host "Setup Complete! Start the bot with run.bat"
Write-Host "=================================="
cmd /c echo Setup complete, close this window.
