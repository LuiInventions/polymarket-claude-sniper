Write-Host "=================================="
Write-Host " Polymarket Claude Sniper - Setup"
Write-Host "=================================="
Write-Host "Bitte gib deine API Keys und Credentials an. Druecke Enter, um einen Wert leer zu lassen."
Write-Host ""

$polyKey = Read-Host "Polymarket Private Key (0x...)"
$polyFunder = Read-Host "Polymarket Funder / Public Address (0x...)"
$polyRpc = Read-Host "Polygon RPC URL (z.B. Alchemy) (https://...)"
$binanceKey = Read-Host "Binance API Key"
$binanceSecret = Read-Host "Binance Secret Key"
$claudeModel = Read-Host "Welches KI-Modell soll genutzt werden? (Standard: claude-3-7-sonnet-20250219)"

if ([string]::IsNullOrWhiteSpace($claudeModel)) {
    $claudeModel = "claude-3-7-sonnet-20250219"
}

Write-Host "`nErstelle .env Datei..."
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
Write-Host "[OK] .env erfolgreich erstellt."


Write-Host "`nErstelle .mcp.json Datei..."
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
Write-Host "[OK] .mcp.json erfolgreich erstellt."

Write-Host "`nAktualisiere Model in run.bat..."
if (Test-Path run.bat) {
    (Get-Content run.bat) -replace '--model \S+', "--model $claudeModel" | Out-File run.bat -Encoding UTF8
    Write-Host "[OK] run.bat Model gesetzt auf: $claudeModel"
}

Write-Host "`nInstalliere Python Abhängigkeiten..."
pip install -r requirements.txt

Write-Host "`nInstalliere und Baue Polymarket MCP (Node.js)..."
Set-Location mcp_servers\polymarket-mcp
npm install
npm run build
Set-Location ..\..

Write-Host "`n=================================="
Write-Host "Setup Abgeschlossen! Starte den Bot mit run.bat"
Write-Host "=================================="
cmd /c echo Setup abgeschlossen, schliesse dieses Fenster.
