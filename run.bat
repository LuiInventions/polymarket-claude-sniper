@echo off
title Polymarket Live Bot Starter
echo [SYSTEM] Bereite die ultimative Live-Trading Erfahrung vor...
echo [SYSTEM] Einsatz-Limit in .env auf 1$ gesenkt.

:: Erstelle das endlose RPA-Makro für Claude
echo $wshell = New-Object -ComObject wscript.shell > live_macro.ps1
echo Start-Sleep -Seconds 5 >> live_macro.ps1

echo while($true) { >> live_macro.ps1
echo     $success = $wshell.AppActivate("Claude-LiveBot") >> live_macro.ps1
echo     if (-not $success) { $wshell.AppActivate("Claude") } >> live_macro.ps1
echo     Start-Sleep -Seconds 1 >> live_macro.ps1

:: Der kurze Prompt für den Einzel-Zyklus
echo     $text = "Guck in deine CLAUDE.md und setze exakt nach dieser Architektur einen Trade ab." >> live_macro.ps1

echo     foreach($char in $text.ToCharArray()) { >> live_macro.ps1
echo         $wshell.SendKeys($char) >> live_macro.ps1
echo         Start-Sleep -Milliseconds 15 >> live_macro.ps1
echo     } >> live_macro.ps1

echo     Start-Sleep -Milliseconds 500 >> live_macro.ps1
echo     $wshell.SendKeys("{ENTER}") >> live_macro.ps1

:: Lasse Claude 90 Sekunden Zeit zum Arbeiten, dann beginnt der nächste Zyklus
echo     Start-Sleep -Seconds 90 >> live_macro.ps1
echo } >> live_macro.ps1

:: Starte das neue Terminal OHNE -p Flag, also interaktiv! Aber mit uebersprungenen Berechtigungen.
echo [SYSTEM] Claude Terminal öffnet sich...
start "Claude-LiveBot" cmd.exe /c "title Claude-LiveBot && claude --dangerously-skip-permissions --model haiku"

:: Führe das Tipp-Makro im Hintergrund endlos aus
powershell -ExecutionPolicy Bypass -File live_macro.ps1

:: Falls der User das Skript manuell abbricht
del live_macro.ps1
pause
