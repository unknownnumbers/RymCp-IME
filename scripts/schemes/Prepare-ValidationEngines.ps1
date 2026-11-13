# SPDX-License-Identifier: GPL-3.0-only
# Download and extract fixed public runtimes; never run either installer.
param([Parameter(Mandatory=$true)][string]$OutputDirectory)
$ErrorActionPreference = 'Stop'
$out = [IO.Path]::GetFullPath($OutputDirectory)
if (Test-Path -LiteralPath $out) { throw 'Choose a fresh runtime output directory.' }
New-Item -ItemType Directory -Path $out | Out-Null
$archiveCommand = Get-Command 7z.exe -ErrorAction SilentlyContinue
$archiveTool = if ($archiveCommand) { $archiveCommand.Source } else { Join-Path $env:ProgramFiles '7-Zip/7z.exe' }
if (-not (Test-Path -LiteralPath $archiveTool)) { throw '7-Zip is required for installer extraction.' }
$assets = @(
    @{Id='official';Url='https://github.com/rime/weasel/releases/download/0.17.4/weasel-0.17.4.0-installer.exe';Hash='cf509534a8f5f8af9c98ed7cbb8f135439f145a8cbe7e50ede42bb5b5ab45c29'},
    @{Id='stellae';Url='https://github.com/unknownnumbers/rime-stellae/releases/download/v0.17.4.61052/stellae-0.17.4.61052-installer.exe';Hash='747f4a86ae77c519731bc441ed90e1cbb954decb78473d0e945441dd681c44e7'}
)
function Machine([string]$path) {
    $bytes = [IO.File]::ReadAllBytes($path)
    if ($bytes.Length -lt 64 -or $bytes[0] -ne 0x4d -or $bytes[1] -ne 0x5a) { return 0 }
    $offset = [BitConverter]::ToInt32($bytes,0x3c)
    if ($offset -lt 0 -or $offset + 6 -gt $bytes.Length) { return 0 }
    return [BitConverter]::ToUInt16($bytes,$offset+4)
}
$records = @()
foreach ($asset in $assets) {
    $archive = Join-Path $out ($asset.Id + '.exe')
    Invoke-WebRequest -Uri $asset.Url -OutFile $archive -UseBasicParsing
    $actualHash = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actualHash -cne $asset.Hash) { throw ('Download hash mismatch: ' + $asset.Id) }
    $extract = Join-Path $out ($asset.Id + '-extracted')
    & $archiveTool x $archive ('-o'+$extract) -aou -y | Out-Null
    if ($LASTEXITCODE -ne 0) { throw ('Extraction failed: ' + $asset.Id) }
    $machines = if ($asset.Id -eq 'official') { @{x64=0x8664} } else { @{x64=0x8664;Win32=0x14c} }
    foreach ($architecture in $machines.Keys) {
        $matches = @(Get-ChildItem -LiteralPath $extract -File -Filter 'rime*.dll' | Where-Object { (Machine $_.FullName) -eq $machines[$architecture] })
        if ($matches.Count -ne 1) { throw ('Expected one runtime for ' + $asset.Id + '/' + $architecture) }
        $engineDir = Join-Path $out ($asset.Id + '-' + $architecture)
        New-Item -ItemType Directory -Path $engineDir | Out-Null
        Copy-Item -LiteralPath $matches[0].FullName -Destination (Join-Path $engineDir 'rime.dll')
        $records += [pscustomobject]@{Source=$asset.Id;Architecture=$architecture;ArchiveSha256=$actualHash;RuntimeSha256=(Get-FileHash -LiteralPath (Join-Path $engineDir 'rime.dll') -Algorithm SHA256).Hash.ToLowerInvariant()}
    }
}
$officialShared = Join-Path $out 'official-extracted/data'
foreach ($required in @('default.yaml','pinyin.yaml','stroke.schema.yaml','stroke.dict.yaml','key_bindings.yaml','punctuation.yaml','symbols.yaml')) {
    if (-not (Test-Path -LiteralPath (Join-Path $officialShared $required))) { throw ('Missing shared data: ' + $required) }
}
[pscustomobject]@{Format='rymcp-validation-runtimes-v1';InstallersExecuted=$false;Runtimes=$records} |
    ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $out 'runtimes.json') -Encoding UTF8
Write-Output 'Fixed public runtimes and official shared data extracted.'
