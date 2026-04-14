# 🎯 Polymarket Claude Sniper

A fully automated AI trading bot that trades directly on the Polymarket prediction platform using Anthropic's **Claude Code**. Powered by real-time data from Binance and the reasoning capabilities of modern Large Language Models (LLMs).

---

## 📖 Table of Contents
1. [About the Project](#-about-the-project)
2. [Background Architecture](#-background-architecture)
3. [System Requirements](#-system-requirements)
4. [API Keys and Credentials (Step-by-Step)](#-api-keys-and-credentials)
5. [Installation & Setup](#-installation--setup)
6. [Start Trading](#-start-trading)
7. [Disclaimer & Security](#-disclaimer--security)

---

## 🧠 About the Project

The **Polymarket Claude Sniper** is more than just a simple trading script. It utilizes Anthropic's advanced developer environment *Claude Code* as its cognitive engine. Instead of relying on hardcoded "if-then" rules, the AI accesses live blockchain and crypto data through **Model Context Protocol (MCP)** servers.

Based on a profound architectural analysis (defined in `CLAUDE.md`), the agent autonomously evaluates the success probability of events, calculates risks, and executes **fully automated orders directly on the Polymarket orderbook level**.

---

## 🏗 Background Architecture

To understand what the bot does under the hood, here is the detailed workflow:

1. **Claude Code as the Engine:** The bot uses the official `claude` CLI tool. We launch Claude in the terminal bypassing standard restrictions (`--dangerously-skip-permissions`) so it can operate completely autonomously.
2. **Infinite Macro (`live_macro.ps1`):** Since LLMs typically wait for user input, this PowerShell script simulates a real user by running a continuous loop every 90 seconds. It continuously sends a prompt instructing the AI to re-evaluate the market based on its given strategy.
3. **MCP Server Integration:** 
   - **Binance MCP (Python):** Provides real-time volatility data for cryptos like BTC, ETH, or SOL.
   - **Polymarket MCP (Node.js):** Translates AI decisions into actual on-chain transactions via Polygon.
4. **Order Logic:** The AI analyzes market depth, selects events with a minimum score (e.g., > 35), and places strategic `UP` or `DOWN` limits directly into the orderbook using your wallet signature.

---

## 🛠 System Requirements

To run the sniper smoothly on your PC, the following base applications must be installed system-wide **(Note: The actual dependencies for the bot itself are installed automatically by the setup script later on):**

* **Node.js** (v18.x or newer) - *Required for the Polymarket MCP Server*
* **Python** (v3.10 or newer) - *Required for the Binance MCP Server and backend tools*
* **Claude Code CLI** - *The Anthropic CLI environment*
  ```bash
  npm install -g @anthropic-ai/claude-code
  ```
* **Git** - *For clean repository management*

---

## 🔑 API Keys and Credentials

For fully automated trading, the bot requires specific permissions and access points. **All keys remain entirely local on your PC and are only transmitted to the official exchange APIs.**

### 1. Polymarket Keys (Trading & Signing)
**Purpose:** To execute buy and sell orders on your behalf.
* **Source:** Go to [Polymarket.com](https://polymarket.com/) and log in.
* Navigate to your **Profile** > **Settings** (or Wallet Export) in the top right corner.
* **Private Key:** Export your key (Looks like `0xabc123...`). **NEVER SHARE THIS!**
* **Funder / Public Address:** Copy your public deposit address (e.g., `0x721...`).

### 2. Polygon RPC URL (Blockchain Connection)
**Purpose:** Polymarket runs on the Polygon network. A fast RPC node ensures the bot isn't hindered by the lag of public servers.
* **Source:** Create an account at [Alchemy](https://dashboard.alchemy.com/).
* Click on **Create new App**.
* Select **Polygon** as the chain and **Polygon Mainnet** as the network.
* Go to your new project's **API Keys** and copy the HTTPS URL.
  ```text
  Format: https://polygon-mainnet.g.alchemy.com/v2/YOUR_API_KEY
  ```

### 3. Binance API Keys (Market Data)
**Purpose:** The bot analyzes crypto prices and orderbooks on Binance to derive forecasts for Polymarket events (e.g., future Bitcoin prices). We only need read permissions for this data.
* **Source:** Log into [Binance](https://www.binance.com/).
* Go to your profile and access **API Management**.
* Create a new API. **IMPORTANT:** You only need `Read Only` permissions. Do *not* enable spot/margin trading.
* Copy both the **API Key** and the **Secret Key**.

---

## 🚀 Installation & Setup

To seamlessly link all variables, we have written an intelligent installation script. This prevents human errors when editing config files manually.

1. **Clone the repository to your desired folder:**
   ```bash
   git clone https://github.com/LuiInventions/polymarket-claude-sniper
   cd polymarket-claude-sniper
   ```

2. **Run the installer:**
   **Right-click on `setup.ps1`** and select **Run with PowerShell** (or navigate there in your terminal and execute `./setup.ps1`).

3. **Follow the setup wizard:**
   The script will interactively guide you through the setup process:
   * It will ask for all the **API keys** gathered above.
   * It will ask for your preferred **AI Model**. *(Recommendation: `claude-3-7-sonnet-20250219` for maximum strategic intelligence)*
   * It safely generates the hidden environment variables (`.env` and `.mcp.json`).
   * **Automated Dependency Installation:** The script takes care of downloading and installing all required Python dependencies (via `pip`) and Node.js dependencies (via `npm`), and builds the repositories in the background. You do not have to manually run any download commands.

---

## 🎯 Start Trading

Once the setup is completed without errors, you are ready to go!

1. Double-click the `run.bat` file.
2. Two things will happen simultaneously:
   * A **Terminal window ("Claude-LiveBot")** opens, initializing the Claude environment in this folder.
   * A **PowerShell macro runs in the background**, focusing on the terminal after 5 seconds and typing the initial trading prompt.
3. Sit back and relax. Claude is now analyzing your setup, loading the MCP tools, and actively searching for profitable setups on Polymarket.

*(If you want to stop the bot: Simply close the terminal window and press `CTRL + C` in the other window)*

---

## 🛡️ Disclaimer & Security

* **Portability:** The repository is programmed to be completely portable. There are **no hardcoded paths** (like `C:\Users\...`); the scripts resolve system paths locally.
* **Privacy:** Thanks to `.gitignore`, files like `.env` and `.mcp.json` are excluded from tracking. Your private keys will never be uploaded to GitHub, even if you create your own fork of this setup.
* **Risk Warning:** This bot trades with real money based on algorithmic AI models. Markets are entirely unpredictable. You trade at your own risk. Neither the developers nor Anthropic assume any liability for financial losses.

---
*Happy Sniping! 🎯*
