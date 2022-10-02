Write-Host (Get-Location)
Set-Location $PSScriptRoot
Write-Host (Get-Location)

# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole)) {
    # We are running "as Administrator" - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"
}
else {
    # We are not running "as Administrator" - so relaunch as administrator
    Start-Process -FilePath "PowerShell" -Verb RunAs -WorkingDirectory (Get-Location) -ArgumentList $myInvocation.MyCommand.Definition;
    exit
}

while ($True) {
    Write-Host "Runing kmonad, close the second window to restart it!"
    $Process = Start-Process ".\kmonad-0.4.1-win.exe" -ArgumentList ".\keymap\user\ipsquiggle\us_ansi_100.kbd" -Verb RunAs -PassThru
    $Process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::AboveNormal
    $Process | Wait-Process

    Write-Host "Kmonad paused, press any key to resume..."
    [void][System.Console]::ReadKey($true)
}
