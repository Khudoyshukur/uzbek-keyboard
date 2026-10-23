# Özbekça klaviatura (Uzbek Latin) - one-command install for Windows.
#   Install:  irm https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/windows/get.ps1 | iex
#   Remove:   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/windows/get.ps1))) -Uninstall
# Downloads the latest release, then runs install.ps1 / uninstall.ps1 as administrator.
# No `exit` here: under `iex` it would close the user's PowerShell window.
& {
    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'
    $action = if ($args -contains '-Uninstall') { 'uninstall' } else { 'install' }
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    # Release files carry the version, so look up the latest tag first.
    $req = [Net.WebRequest]::Create('https://github.com/khudoyshukur/uzbek-keyboard/releases/latest')
    $res = $req.GetResponse(); $tag = $res.ResponseUri.Segments[-1]; $res.Close()
    $url = "https://github.com/khudoyshukur/uzbek-keyboard/releases/download/$tag/UzbekKeyboard-Windows-$($tag.TrimStart('v')).zip"
    $tmp = Join-Path $env:TEMP ('uzbek-keyboard-' + [guid]::NewGuid())
    try {
        New-Item -ItemType Directory $tmp | Out-Null
        Write-Host 'Yuklab olinmoqda...'
        Invoke-WebRequest $url -OutFile "$tmp\uzk.zip" -UseBasicParsing
        Expand-Archive "$tmp\uzk.zip" $tmp
        $dir = Get-ChildItem $tmp -Directory | Select-Object -First 1
        Get-ChildItem $dir.FullName -Recurse -File | Unblock-File
        Write-Host 'Administrator ruxsati söraladi - "Yes" ni bosing.'
        $psArgs = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$($dir.FullName)\$action.ps1`"")
        if ($env:CI) { $psArgs += '-Quiet' }   # no "press Enter" prompt in automated tests
        $p = Start-Process powershell.exe -Verb RunAs -Wait -PassThru -ArgumentList $psArgs
        if ($p.ExitCode -ne 0) { Write-Warning "Xatolik yuz berdi (kod $($p.ExitCode))." }
    } catch {
        Write-Warning "Bajarilmadi: $($_.Exception.Message)"
    } finally {
        Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
    }
} @args
