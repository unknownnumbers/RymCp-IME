# SPDX-License-Identifier: GPL-3.0-only
param(
    [Parameter(Mandatory=$true)][string]$EngineDir,
    [Parameter(Mandatory=$true)][string]$SharedDir,
    [Parameter(Mandatory=$true)][string]$WorkRoot
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$work = [IO.Path]::GetFullPath($WorkRoot)
if (Test-Path -LiteralPath $work) { throw 'Use a fresh synthetic work directory.' }
New-Item -ItemType Directory -Path $work | Out-Null
$engine = Join-Path ([IO.Path]::GetFullPath($EngineDir)) 'rime.dll'
if (-not (Test-Path -LiteralPath $engine)) { throw 'Missing engine DLL.' }
$env:PATH = ([IO.Path]::GetFullPath($EngineDir)) + ';' + $env:PATH
$hostExe = (Get-Process -Id $PID).Path
$compiled = Join-Path $work 'compiled'
& $hostExe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repo 'tests/Probe-Configuration.ps1') -EngineDll $engine -SharedData $SharedDir -Output $compiled -Phase Compile -Revision release
if ($LASTEXITCODE -ne 0) { throw 'Full scheme compilation failed.' }
$results = @()
foreach ($scenario in @('Bracket','Mixed')) {
    $user = Join-Path $work ($scenario.ToLowerInvariant() + '-user')
    Copy-Item -LiteralPath (Join-Path $compiled 'publicuser') -Destination $user -Recurse
    '{"kind":"fixed-synthetic-profile","format":1}' | Set-Content -LiteralPath (Join-Path $user '.synthetic-profile.json') -Encoding UTF8
    $out = Join-Path $work ($scenario.ToLowerInvariant() + '-results')
    $scriptName = 'Test-' + $scenario + 'Learning.ps1'
    & $hostExe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repo ('tests/schemes/' + $scriptName)) -EngineDll $engine -SharedData $SharedDir -UserData $user -OutputDirectory $out
    if ($LASTEXITCODE -ne 0) { throw ($scenario + ' learning checks failed.') }
    $rows = Get-Content -LiteralPath (Join-Path $out 'results.json') -Raw | ConvertFrom-Json
    if (-not $rows.Count -or @($rows | Where-Object { -not $_.Passed }).Count) { throw 'Missing or failed learning assertions.' }
    $results += [pscustomobject]@{Scenario=$scenario;Checks=$rows.Count;Passed=$true}
}
$summary = [pscustomobject]@{Format='rymcp-full-scheme-validation-v1';Version='2026.11.14';Passed=$true;Results=$results}
$summary | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $work 'validation.json') -Encoding UTF8
$summary | ConvertTo-Json -Depth 5
