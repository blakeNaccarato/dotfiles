<#.SYNOPSIS
My custom PowerShell user profile.#>

# ? Error-handling
$ErrorActionPreference = 'Stop'
($PSNativeCommandUseErrorActionPreference = $true) | Out-Null
($ErrorView = 'NormalView') | Out-Null

# ? Environment variables
$Env:POWERSHELL_TELEMETRY_OPTOUT = 'true'
$Env:PYDEVD_DISABLE_FILE_VALIDATION = 1

# ? Prepend path and activate virtual environment
$Env:PATH = "bin;$Env:PATH"
if (Test-Path '.venv') {
    if (Test-Path '.venv/Scripts') { .venv/Scripts/Activate.ps1 }
    else { .venv/bin/Activate.ps1 }
}

# ! Everything below skipped by early return if virtual terminal is unsupported.
# ! https://github.com/PowerShell/PSReadLine/issues/1992#issuecomment-1385797536

# ? PSReadLine
#? Press F2 to toggle between prediction view styles (PredictionViewStyle)
try { Set-PSReadLineOption -PredictionSource HistoryAndPlugin } catch [System.ArgumentException] { 
    return
}
$pred = 'CompletionPredictor'
if (!(Get-Module $pred -ListAvailable)) { Install-Module $pred -Force }
Import-Module $pred
#? Make word-by-word completion the default, Shift+Tab for full suggestion complete
Set-PSReadLineKeyHandler -Chord Tab -Function AcceptNextSuggestionWord
Set-PSReadLineKeyHandler -Chord Shift+Tab -Function TabCompleteNext
#? Rebind these to avoid VSCode keybind conflicts
Set-PSReadLineKeyHandler -Chord Shift+F1 -Function ShowCommandHelp  # Also F1
Set-PSReadLineKeyHandler -Chord F4 -Function CharacterSearch  # Also F3
Set-PSReadLineKeyHandler -Chord Shift+F4 -Function CharacterSearchBackward  # Sh+F3

#? Aliases
#! gc
Remove-Alias -Force 'gc'  # Read-only alias for Get-Content
function gc {
    git commit @args
}
function gcn {
    git commit --no-verify @args
}
#! gps
Remove-Alias -Force 'gps'  # Read-only alias for Get-Unique
function gps {
    git push @args
    try { dvc push } catch [System.Management.Automation.CommandNotFoundException] {}
}
#! Others
function gpsn {
    git push --no-verify @args
}
function gpl {
    git pull @args
    try { dvc pull } catch [System.Management.Automation.CommandNotFoundException] {}
}
function gpln {
    gpl --no-verify @args
    try { dvc pull } catch [System.Management.Automation.CommandNotFoundException] {}
}
