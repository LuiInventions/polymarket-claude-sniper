# 🎯 Polymarket Claude Sniper

Ein vollautomatisierter AI-Trading-Bot, der direkt über Anthropic's **Claude Code** auf der Polymarket-Prognoseplattform handelt. Gestützt durch Echtzeitdaten von Binance und die Leistungsfähigkeit moderner Large Language Models (LLMs).

---

## 📖 Inhaltsverzeichnis
1. [Über das Projekt](#-über-das-projekt)
2. [Die Architektur im Hintergrund](#-die-architektur-im-hintergrund)
3. [Systemvoraussetzungen](#-systemvoraussetzungen)
4. [API-Keys und Credentials (Schritt-für-Schritt)](#-api-keys-und-credentials)
5. [Installation & Setup](#-installation--setup)
6. [Trading starten](#-trading-starten)
7. [Disclaimer & Sicherheit](#-disclaimer--sicherheit)

---

## 🧠 Über das Projekt

Der **Polymarket Claude Sniper** ist mehr als nur ein einfaches Trading-Skript. Er nutzt Anthropic's fortschrittliche Entwicklerumgebung *Claude Code* als kognitiven Motor. Anstatt harte "Wenn-Dann"-Regeln zu verwenden, greift die KI über sogenannte **Model Context Protocol (MCP)** Server live auf Blockchain- und Kryptodaten zu.

Auf Basis einer tiefgreifenden Architekturanalyse (definiert in `CLAUDE.md`) bewertet der Agent selbstständig die Erfolgswahrscheinlichkeit von Events, kalkuliert das Risiko und führt **vollautomatisch Orders auf Ebene des Polymarket-Orderbooks** aus.

---

## 🏗 Die Architektur im Hintergrund

Damit du verstehst, was der Bot unter der Haube macht, hier der detaillierte Ablauf:

1. **Claude Code als Motor:** Der Bot verwendet das offizielle `claude` CLI-Tool. Wir starten Claude im Terminal außerhalb der regulären Beschränkungen (`--dangerously-skip-permissions`), damit er vollständig autonom handeln kann.
2. **Endlos-Makro (`live_macro.ps1`):** Da LLMs normalerweise auf User-Input warten, simuliert dieses PowerShell-Skript in einem Loop von 90 Sekunden einen echten User. Es tippt fortlaufend den Befehl ein, den Markt anhand der Strategie neu zu evaluieren.
3. **MCP Server Integration:** 
   - **Binance MCP (Python):** Liefert Echtzeit-Volatilitätsdaten zu Kryptos wie BTC, ETH oder SOL.
   - **Polymarket MCP (Node.js):** Übersetzt die KI-Entscheidungen in tatsächliche On-Chain-Transaktionen via Polygon.
4. **Order-Logik:** Die KI prüft die Markttiefe, wählt Events mit einem Mindest-Score (z.B. > 35) aus und platziert strategische `UP` oder `DOWN` Limits direkt im Orderbuch mithilfe deiner Wallet-Signatur.

---

## 🛠 Systemvoraussetzungen

Um den Sniper reibungslos auf deinem PC auszuführen, müssen folgende Abhängigkeiten systemweit installiert sein:

* **Node.js** (v18.x oder neuer) - *Erforderlich für den Polymarket MCP Server*
* **Python** (v3.10 oder neuer) - *Erforderlich für den Binance MCP Server und Backend-Tools*
* **Claude Code CLI** - *Die Anthropic CLI*
  ```bash
  npm install -g @anthropic-ai/claude-code
  ```
* **Git** - *Für sauberes Repository-Management*

---

## 🔑 API-Keys und Credentials

Für den vollautomatisierten Handel benötigt der Bot eine Reihe von Berechtigungen und Zugängen. **Alle Schlüssel bleiben lokal auf deinem PC und werden ausschließlich an die offiziellen APIs der Börsen gesendet.**

### 1. Polymarket Keys (Trading & Signierung)
**Wofür gebraucht?** Um Kauf- und Verkaufsorders in deinem Namen abzuwickeln.
* **Bezugsquelle:** Gehe auf [Polymarket.com](https://polymarket.com/) und logge dich ein.
* Gehe oben rechts auf dein **Profil** > **Settings** (oder Wallet Export).
* **Private Key:** Exportiere den Schlüssel (Sieht aus wie `0xabc123...`). **NIEMALS TEILEN!**
* **Funder / Public Address:** Kopiere deine öffentliche Einzahlungsadresse (z.B. `0x721...`).

### 2. Polygon RPC URL (Blockchain Verbindung)
**Wofür gebraucht?** Polymarket basiert auf dem Polygon-Netzwerk. Eine schnelle RPC-Node stellt sicher, dass der Bot nicht an Lags öffentlicher Server scheitert.
* **Bezugsquelle:** Erstelle einen Account bei [Alchemy](https://dashboard.alchemy.com/).
* Klicke auf **Create new App**.
* Wähle als Chain **Polygon** und als Network **Polygon Mainnet**.
* Klicke in deinem neuen Projekt auf **API Keys** und kopiere die HTTPS-URL.
  ```text
  Format: https://polygon-mainnet.g.alchemy.com/v2/DEIN_API_KEY
  ```

### 3. Binance API Keys (Marktdaten)
**Wofür gebraucht?** Der Bot analysiert Krypto-Kurse und Orderbücher bei Binance, um Ableitungen für Polymarket-Prognosen zu treffen (z.B. Bitcoin-Preise in der Zukunft). Für diese Daten brauchen wir Lese-Rechte.
* **Bezugsquelle:** Logge dich auf [Binance](https://www.binance.com/) ein.
* Gehe ins Profil zu **API Management**.
* Erstelle eine neue API. **WICHTIG:** Du brauchst *nur* Lese-Rechte (`Read Only`). Aktiviere *kein* Trading auf Binance.
* Kopiere den **API Key** und den **Secret Key**.

---

## 🚀 Installation & Setup

Um alle Variablen nahtlos miteinander zu verknüpfen, haben wir ein intelligentes Installations-Skript geschrieben. Dies verhindert menschliche Fehler beim Editieren von Config-Dateien.

1. **Klone das Repository in deinen Wunsch-Ordner:**
   ```bash
   git clone https://github.com/LuiInventions/polymarket-claude-sniper.git
   cd polymarket-claude-sniper
   ```

2. **Starte den Installer:**
   Mache einen **Rechtsklick auf `setup.ps1`** und wähle **Mit PowerShell ausführen** (bzw. navigiere im Terminal dorthin und führe `./setup.ps1` aus).

3. **Dem Setup folgen:**
   Das Skript wird dich interaktiv durch die Einrichtung führen:
   * Es fragt alle oben gesammelten **API-Keys** ab.
   * Es fragt nach dem **KI-Modell** deiner Wahl. *(Empfehlung: `claude-3-7-sonnet-20250219` für maximale strategische Intelligenz)*
   * Es erstellt die versteckten Umgebungsvariablen (`.env` und `.mcp.json`).
   * Es installiert alle Python-Packages (`requirements.txt`).
   * Es kompiliert die Node.js Repositories im Hintergrund via `npm install` und `npm run build`.

---

## 🎯 Trading starten

Sobald das Setup fehlerfrei durchgelaufen ist, bist du bereit!

1. Klicke doppelt auf die Datei `run.bat`.
2. Es öffnen sich zwei Dinge:
   * Ein **Terminal-Fenster ("Claude-LiveBot")**, das die Claudeumgebung in diesem Ordner initialisiert.
   * Ein **PowerShell-Makro im Hintergrund**, das nach 5 Sekunden das Terminal fokussiert und den initialen Trading-Prompt absendet.
3. Lehne dich zurück. Claude analysiert nun das Setup, lädt die MCP-Tools und sucht aktiv nach profitablen Setups auf Polymarket.

*(Falls du den Bot stoppen willst: Schließe das Terminal und drücke im anderen Fenster `STRG + C`)*

---

## 🛡️ Disclaimer & Sicherheit

* **Portabilität:** Das Repository ist absolut portabel programmiert. Es gibt **keine hardcodierten Pfade** (wie `C:\Users\...`), die Skripte lösen Systempfade lokal auf.
* **Privatsphäre:** Dank `.gitignore` sind Dateien wie `.env` und `.mcp.json` gesperrt. Deine privaten Schlüssel werden niemals auf GitHub hochgeladen, falls du einen eigenen Fork deines Setups erstellst.
* **Risk Warning:** Dieser Bot agiert mit echtem Geld auf Basis algorithmischer KI-Modelle. Märkte sind unvorhersehbar. Du handelst auf eigenes Risiko. Weder die Entwickler noch Anthropic übernehmen Haftung für finanzielle Verluste.

---
*Happy Sniping! 🎯*
