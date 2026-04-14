@echo off
title Polymarket Simulator Starter
echo [SYSTEM] Bereite die Live-Erfahrung vor...

:: Erstelle ein dynamisches powershell-Macro, das den Text eintippt
echo $wshell = New-Object -ComObject wscript.shell > type_macro.ps1
echo Start-Sleep -Seconds 4 >> type_macro.ps1
echo $success = $wshell.AppActivate("Claude-Backtest") >> type_macro.ps1
echo if (-not $success) { $wshell.AppActivate("Claude") } >> type_macro.ps1
echo Start-Sleep -Seconds 1 >> type_macro.ps1
echo $text = "Lies CLAUDE.md. Aufgabe: Simuliere genau 50 historische Paper-Trades nacheinander in einer Ausgabe. Mache detaillierte Einzelentscheidungen (UP/DOWN), simuliere realistische Kursdaten, Indikatoren und sofortige Polymarket-Settlements. Verbuche virtuellen Gewinn oder Verlust. Schreibe nichts in die jsonl Dateien. Zeige ganz am Ende des Reports die finale Win-Rate, die Anzahl Gewinne/Verluste und das Endguthaben bei Start mit 500 Dollar." >> type_macro.ps1

:: Schleife, die jeden Buchstaben wie von Geisterhand tippt
echo foreach($char in $text.ToCharArray()) { >> type_macro.ps1
echo     $wshell.SendKeys($char) >> type_macro.ps1
echo     Start-Sleep -Milliseconds 25 >> type_macro.ps1
echo } >> type_macro.ps1

:: Enter drücken
echo Start-Sleep -Milliseconds 500 >> type_macro.ps1
echo $wshell.SendKeys("{ENTER}") >> type_macro.ps1

:: Starte das neue Terminal in einem separaten Fenster
echo [SYSTEM] Claude Terminal öffnet sich...
start "Claude-Backtest" cmd.exe /c "title Claude-Backtest && claude"

:: Führe das Tipp-Makro im Hintergrund aus
powershell -ExecutionPolicy Bypass -File type_macro.ps1

:: Makro-Datei wieder wegräumen
del type_macro.ps1

echo [SYSTEM] Macro erfolgreich abgesetzt! Sie koennen dieses Starter-Fenster nun schliessen.
pause
