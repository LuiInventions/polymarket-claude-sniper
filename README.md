# Polymarket Claude Sniper

Der **Polymarket Claude Sniper** ist ein vollautomatisierter AI-Trading-Bot, der direkt über Anthropic's **Claude Code** auf der Polymarket Prognose-Plattform handelt. Der Bot nutzt "Model Context Protocol" (MCP) Server, um Marktdaten von Binance abzugreifen und auf Grundlage von komplexer, dokumentierter Architekturanalyse selbstständige Kaufentscheidungen (UP/DOWN Limits) zu treffen.

## Was passiert im Hintergrund (Die KI-Logik)?

1. **Claude Code als Motor:** Der Bot verwendet das offizielle `claude` CLI-Tool, um in einem interaktiven Agenten-Terminal zu laufen.
2. **Endlos-Makro:** Das `live_macro.ps1` skript sendet alle 90 Sekunden als virtueller User eine Aufgabe an Claude, wieder neue Trades nach dem Regelwerk (`CLAUDE.md`) zu analysieren.
3. **Kontext / MCP:** Claude greift über die MCP-Server in Echtzeit auf Binance-Daten zu (z.B. BTC, ETH Volatilität).
4. **Trading:** Wenn ein polymarket-Event günstige Deltas aufweist und die AI es als wahrscheinlich einschätzt, rechnet das Skript Live-Guthaben und Chance/Risiko aus und platziert einen Live-Trade via Polymarket API.

## 🛠 Voraussetzungen / Abhängigkeiten

- **Node.js**: (Version 18 oder neuer) - Nötig für den Polymarket MCP Server.
- **Python**: (Version 3.10 oder neuer) - Nötig für den Binance MCP Server und globale Module.
- **Claude Code CLI**: Du musst das offizielle Claude CLI installiert und konfiguriert haben. (`npm install -g @anthropic-ai/claude-code`)

## 🔑 Installations-Anleitung & API Keys vorbereiten

Bevor du den Bot startest, musst du folgende Accounts und API-Keys vorbereiten:

### 1. Polymarket Keys
- **Zweck:** Authentifizierung und Durchführung von Trades bei Polymarket.
- **Bezugsquelle:** Gehe auf [polymarket.com](https://polymarket.com/), melde dich an, navigiere in dein Profil / Wallet Einstellungen und exportiere den **Private Key** sowie die **Wallet / Funder Address**. 
- **ACHTUNG:** Teile deinen Private Key niemals!

### 2. Polygon RPC URL (Alchemy)
- **Zweck:** Polymarket läuft auf der Polygon-Blockchain. Eine RPC (Remote Procedure Call) Node verbindet den Bot schnell und stabil mit der Blockchain.
- **Bezugsquelle:** Registriere dich bei [Alchemy](https://dashboard.alchemy.com/), erstelle eine "App" auf dem **Polygon Mainnet** und kopiere die HTTPS URI (z.B. `https://polygon-mainnet.g.alchemy.com/v2/DEIN_API_KEY`).

### 3. Binance API Keys
- **Zweck:** Der Bot nutzt Binance, um hochfrequente Kryptodaten und Markttrends abzufragen, die zur Vorhersage in Polymarket-Events dienen.
- **Bezugsquelle:** Registriere dich auf [Binance](https://www.binance.com/), gehe in die "API Management" (API-Verwaltung) Einstellungen, erstelle einen API Key und erteile im Zweifel nur Lese-Rechte. Du erhältst einen **API Key** und einen **Secret Key**.

---

## 🚀 Setup & Start

1. **Repository klonen** oder entpacken.
2. **Setup Skript ausführen:**
   Mache einen **Rechtsklick auf `setup.ps1` -> 'Mit PowerShell ausführen'**.
   Das Skript wird:
   - Deine API-Keys abfragen.
   - Das gewünschte KI-Modell abfragen (wir empfehlen `claude-3-7-sonnet-20250219`).
   - Die Dateien `.env` und `.mcp.json` sicher mit deinen Anmeldedaten generieren (diese Dateien werden nicht auf Github geladen!).
   - Die Python `requirements.txt` installieren.
   - Den Node-basierten Polymarket MCP-Server bauen.
3. **Bot Starten:**
   Doppelklick auf `run.bat`. Dies startet Claude Code sowie das Tipp-Makro, welches die Live-Überwachung initiiert.

## ⚠️ Warnungen & Datenschutz

Dieses Projekt ist für jeden Computer portabel geschrieben. Im Code sind keine fest codierten Dateipfade (z.B. Festplatte C:\) oder Entwickler-Variablen vorhanden. Sensible `.env` und `.mcp.json` Daten werden von Git durch `.gitignore` blockiert. Es erfolgt keine Weitergabe eurer Keys außerhalb der offiziellen Anthropic- (Claude) und Börsen-APIs. 
Nutzung auf eigene Gefahr!
