# <#.SYNOPSIS
# My custom PowerShell user profile.#>

# # * -------------------------------------------------------------------------------- * #
# # * Stop on first error and enable native command error propagation
# $ErrorActionPreference = 'Stop'
# $PSNativeCommandUseErrorActionPreference = $true
# $PSNativeCommandUseErrorActionPreference | Out-Null

# # * -------------------------------------------------------------------------------- * #
# # * Variables affecting shell behavior
# #! Display more verbose errors
# $ErrorView = 'NormalView'
# $ErrorView | Out-Null  # https://github.com/PowerShell/PSScriptAnalyzer/issues/1749
# #! Fix leaky UTF-8 encoding settings
# # Now PowerShell pipes will be UTF-8. Note that fixing it from Control Panel and
# # system-wide has buggy downsides.
# # See: https://github.com/PowerShell/PowerShell/issues/7233#issuecomment-640243647
# [console]::InputEncoding = [console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# # * -------------------------------------------------------------------------------- * #
# # * Environment variables
# $Env:POWERSHELL_TELEMETRY_OPTOUT = 'true'
# $Env:PIP_DISABLE_PIP_VERSION_CHECK = 1
# $Env:PYDEVD_DISABLE_FILE_VALIDATION = 1
# #? Don't warn on this except in configured projects
# # $Env:PYTHONWARNDEFAULTENCODING = 1
# $Env:PYTHONPYCACHEPREFIX = "$Env:Temp/pycache"

# # * -------------------------------------------------------------------------------- * #
# # * Activate virtual environment
# if (Test-Path '.venv') {
#     if (Test-Path '.venv/Scripts') { .venv/Scripts/Activate.ps1 }
#     else { .venv/bin/activate.ps1 }
# }

# # * -------------------------------------------------------------------------------- * #
# # * Interactive
# # ! Everything in this section is skipped if virtual terminals are not supported.
# # ! Triggered by catching a System.ArgumentException from Set-PSReadLineOption.
# # ! https://github.com/PowerShell/PSReadLine/issues/1992#issuecomment-1385797536

# try {
#     # * ---------------------------------------------------------------------------- * #
#     # * PSReadLine
#     #? Press F2 to toggle between prediction view styles (PredictionViewStyle)
#     # ! ---------------------------------------------------------------------------- ! #
#     Set-PSReadLineOption -PredictionSource HistoryAndPlugin
#     # ! ---------------------------------------------------------------------------- ! #
#     $pred = 'CompletionPredictor'
#     if (!(Get-Module $pred -ListAvailable)) { Install-Module $pred -Force }
#     Import-Module $pred
#     #? Make word-by-word completion the default, Shift+Tab for full suggestion complete
#     Set-PSReadLineKeyHandler -Chord Tab -Function AcceptNextSuggestionWord
#     Set-PSReadLineKeyHandler -Chord Shift+Tab -Function TabCompleteNext
#     #? Rebind these to avoid VSCode keybind conflicts
#     Set-PSReadLineKeyHandler -Chord Shift+F1 -Function ShowCommandHelp  # Also F1
#     Set-PSReadLineKeyHandler -Chord F4 -Function CharacterSearch  # Also F3
#     Set-PSReadLineKeyHandler -Chord Shift+F4 -Function CharacterSearchBackward  # Sh+F3

#     # * ---------------------------------------------------------------------------- * #
#     # * Aliases
#     #! gc
#     Remove-Alias -Force 'gc'  # Read-only alias for Get-Content
#     function gc {
#         git commit @args
#     }
#     function gcn {
#         git commit --no-verify @args
#     }
#     #! gps
#     Remove-Alias -Force 'gps'  # Read-only alias for Get-Unique
#     function gps {
#         git push @args
#         try { dvc push } catch [System.Management.Automation.CommandNotFoundException] {}
#     }
#     #! Others
#     function gpsn {
#         git push --no-verify @args
#     }
#     function gpl {
#         git pull @args
#         try { dvc pull } catch [System.Management.Automation.CommandNotFoundException] {}
#     }
#     function gpln {
#         gpl --no-verify @args
#         try { dvc pull } catch [System.Management.Automation.CommandNotFoundException] {}
#     }
# }
# catch [System.ArgumentException] {}
