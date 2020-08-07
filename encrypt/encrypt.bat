@echo off
C:\Windows\System32\WindowsPowerShell\v1.0\powershell -exec bypass -c "& {Import-Module ./xencrypt.ps1;Invoke-Xencrypt -InFile IESettings_source.ps1 -OutFile IESettings.ps1 -Iterations 50}"


pause

