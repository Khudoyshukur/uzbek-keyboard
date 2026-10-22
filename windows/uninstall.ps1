# Removes the Uzbek Keyboard layout.
param([switch]$Quiet)
$ErrorActionPreference = 'Stop'
$Dll  = 'uzbekkb.dll'
$Root = 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts'

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"")
    exit
}

$keys = Get-ChildItem $Root | Where-Object { (Get-ItemProperty $_.PSPath).'Layout File' -eq $Dll }
foreach ($k in $keys) {
    $klid = $k.PSChildName.ToUpper()
    try {
        $list = Get-WinUserLanguageList
        foreach ($lang in $list) {
            $tips = @($lang.InputMethodTips | Where-Object { $_ -like "*:$klid" })
            foreach ($t in $tips) { [void]$lang.InputMethodTips.Remove($t) }
        }
        # A language with no keyboards left is invalid; drop it
        $empty = @($list | Where-Object { $_.InputMethodTips.Count -eq 0 })
        foreach ($l in $empty) { [void]$list.Remove($l) }
        Set-WinUserLanguageList $list -Force
    } catch { Write-Warning "Could not update your language list: $_" }
    Remove-Item $k.PSPath -Recurse -Force
    Write-Host "Unregistered $klid"
}

$sys32 = if ([Environment]::Is64BitOperatingSystem -and -not [Environment]::Is64BitProcess) { "$env:SystemRoot\Sysnative" } else { "$env:SystemRoot\System32" }
foreach ($f in "$sys32\$Dll", "$env:SystemRoot\SysWOW64\$Dll") {
    if (Test-Path $f) {
        try { Remove-Item $f -Force; Write-Host "Deleted $f" }
        catch { Write-Warning "$f is in use; it will be harmless, or delete it after a restart." }
    }
}
Write-Host 'Done. Sign out and back in to finish.'
if (-not $Quiet) { Read-Host 'Press Enter to close' }
