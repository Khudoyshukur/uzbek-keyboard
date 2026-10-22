# Installs the Uzbek Keyboard layout (uzbekkb.dll) for all users and adds it
# to the current user's language list. Re-running it is safe.
param([switch]$Quiet)
$ErrorActionPreference = 'Stop'

$Dll        = 'uzbekkb.dll'
$LayoutText = 'Uzbek Keyboard'
$Lcid       = '0443'      # Uzbek (Latin, Uzbekistan)
$LangTag    = 'uz-Latn'
$Root       = 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts'
$Here       = $PSScriptRoot

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"")
    exit
}

try {
    # 1. Copy the DLLs into the system folders
    $arch = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE }
    if ($arch -eq 'ARM64') { throw 'Windows on ARM is not supported yet (Microsoft''s kbdutool cannot build ARM64 layouts).' }
    # A 32-bit PowerShell on 64-bit Windows sees SysWOW64 as System32; Sysnative is the real one.
    $sys32 = if ([Environment]::Is64BitOperatingSystem -and -not [Environment]::Is64BitProcess) { "$env:SystemRoot\Sysnative" } else { "$env:SystemRoot\System32" }
    if ([Environment]::Is64BitOperatingSystem) {
        Copy-Item "$Here\amd64\$Dll" "$sys32\$Dll" -Force
        Copy-Item "$Here\wow64\$Dll" "$env:SystemRoot\SysWOW64\$Dll" -Force
    } else {
        Copy-Item "$Here\i386\$Dll" "$sys32\$Dll" -Force
    }

    # 2. Register the layout (reuse our key if already installed)
    $all = Get-ChildItem $Root | ForEach-Object { [pscustomobject]@{ Id = $_.PSChildName; Props = Get-ItemProperty $_.PSPath } }
    $mine = $all | Where-Object { $_.Props.'Layout File' -eq $Dll } | Select-Object -First 1
    if ($mine) {
        $klid = $mine.Id
    } else {
        $klid = $null
        foreach ($p in 'a', 'b', 'c', 'd', 'e', 'f') {
            $candidate = "${p}000$Lcid"
            if (-not ($all | Where-Object { $_.Id -eq $candidate })) { $klid = $candidate; break }
        }
        if (-not $klid) { throw 'No free keyboard layout ID found.' }
        $used = $all | ForEach-Object { $_.Props.'Layout Id' } | Where-Object { $_ } | ForEach-Object { [Convert]::ToInt32($_, 16) }
        $max = ($used | Measure-Object -Maximum).Maximum
        $layoutId = '{0:x4}' -f ([int]$max + 1)
        $key = New-Item -Path "$Root\$klid" -Force
        New-ItemProperty -Path $key.PSPath -Name 'Layout Id' -Value $layoutId -PropertyType String -Force | Out-Null
    }
    $path = "$Root\$klid"
    New-ItemProperty -Path $path -Name 'Layout File' -Value $Dll -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $path -Name 'Layout Text' -Value $LayoutText -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $path -Name 'Layout Display Name' -Value "@%SystemRoot%\system32\$Dll,-1000" -PropertyType String -Force | Out-Null
    Write-Host "Registered layout $klid ($LayoutText)"

    # 3. Add it to this user's input methods
    $tip = "${Lcid}:$($klid.ToUpper())"
    try {
        $list = Get-WinUserLanguageList
        $lang = $list | Where-Object { $_.LanguageTag -like "$LangTag*" } | Select-Object -First 1
        if (-not $lang) {
            $list.Add($LangTag)
            $lang = $list | Where-Object { $_.LanguageTag -like "$LangTag*" } | Select-Object -First 1
            $lang.InputMethodTips.Clear()   # drop the stock Uzbek layout that comes with the language
        }
        if ($lang.InputMethodTips -notcontains $tip) { $lang.InputMethodTips.Add($tip) }
        Set-WinUserLanguageList $list -Force
        Write-Host "Added to your languages. Switch with Win+Space."
    } catch {
        Write-Warning "Installed, but could not add it to your language list automatically: $_"
        Write-Warning "Add it in Settings > Time & language > Language & region > Uzbek (Latin) > Keyboards."
    }
    Write-Host 'Done. If the layout does not show up right away, sign out and back in.'
} catch {
    Write-Error $_
    if (-not $Quiet) { Read-Host 'Press Enter to close' }
    exit 1
}
if (-not $Quiet) { Read-Host 'Press Enter to close' }
