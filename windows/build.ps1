# Build the keyboard DLLs from UzbekKeyboard.klc with Microsoft's kbdutool.exe
# and package them with the install scripts into dist\.
# Used by CI; also works on any Windows machine (MSKLC is downloaded if missing).
$ErrorActionPreference = 'Stop'
$repo    = Split-Path -Parent $PSScriptRoot
$version = (Get-Content "$repo\VERSION").Trim()
$klc     = "$PSScriptRoot\UzbekKeyboard.klc"
$work    = Join-Path $env:TEMP 'uzbek-keyboard-build'
$out     = "$repo\dist"
$pkgName = "UzbekKeyboard-Windows-$version"
$pkg     = Join-Path $work $pkgName

Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $work, $out, $pkg | Out-Null

# 1. Find or fetch kbdutool.exe (ships inside Microsoft Keyboard Layout Creator 1.4)
$kbdutool = Get-ChildItem "${env:ProgramFiles(x86)}\Microsoft Keyboard Layout Creator*\bin\i386\kbdutool.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $kbdutool) {
    Write-Host 'Downloading MSKLC 1.4...'
    $exe = Join-Path $work 'MSKLC.exe'
    Invoke-WebRequest 'https://download.microsoft.com/download/6/f/5/6f5ce43a-e892-4fd1-b9a6-1a0cbb64e6e2/MSKLC.exe' -OutFile $exe
    $extract = Join-Path $work 'msklc'
    Start-Process $exe -ArgumentList "/Q /T:`"$extract`" /C" -Wait
    $msi = Get-ChildItem $extract -Filter *.msi -Recurse | Select-Object -First 1
    # Administrative install just unpacks the files (no .NET 2.0 prerequisite check)
    $files = Join-Path $work 'msklc-files'
    Start-Process msiexec.exe -ArgumentList "/a `"$($msi.FullName)`" /qn TARGETDIR=`"$files`"" -Wait
    $kbdutool = Get-ChildItem $files -Filter kbdutool.exe -Recurse | Select-Object -First 1
}
if (-not $kbdutool) { throw 'kbdutool.exe not found' }
Write-Host "Using $($kbdutool.FullName)"

# 2. Compile one DLL per architecture
$arches = @{ 'i386' = '-x'; 'amd64' = '-m'; 'wow64' = '-o' }
foreach ($arch in $arches.Keys) {
    $dir = Join-Path $work "build-$arch"
    New-Item -ItemType Directory -Force $dir | Out-Null
    Copy-Item $klc $dir
    Push-Location $dir
    try {
        & $kbdutool.FullName -u -v $arches[$arch] 'UzbekKeyboard.klc'
        if ($LASTEXITCODE -ne 0) { throw "kbdutool failed for $arch (exit $LASTEXITCODE)" }
        $dll = Get-ChildItem $dir -Filter uzbekkb.dll -Recurse | Select-Object -First 1
        if (-not $dll) { Get-ChildItem $dir -Recurse | Format-Table FullName; throw "no DLL produced for $arch" }
        New-Item -ItemType Directory -Force "$pkg\$arch" | Out-Null
        Copy-Item $dll.FullName "$pkg\$arch\uzbekkb.dll"
    } finally { Pop-Location }
}

# 3. Package
Copy-Item "$PSScriptRoot\install.ps1", "$PSScriptRoot\uninstall.ps1", "$PSScriptRoot\install.cmd", "$PSScriptRoot\uninstall.cmd", $klc $pkg
Copy-Item "$repo\LICENSE" $pkg
$zip = "$out\$pkgName.zip"
Remove-Item $zip -ErrorAction SilentlyContinue
Compress-Archive -Path $pkg -DestinationPath $zip
Get-ChildItem $pkg -Recurse | Select-Object FullName, Length | Format-Table -AutoSize
Write-Host "Built $zip"
