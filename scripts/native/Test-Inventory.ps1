# SPDX-License-Identifier: GPL-3.0-only
param([string]$WeaselSourceArchivePath)
. (Join-Path $PSScriptRoot 'Common.ps1')
$manifest = Get-NativeManifest
if ($manifest.schema -cne 'rymcp-native-sources/1') { throw 'Unknown native manifest schema.' }
foreach ($patch in $manifest.patches) {
    $path = Get-NativeRepositoryPath $patch.path
    $null = Assert-NativeHash $path $patch.sha256
    $stats = @(& git apply --numstat $path)
    if ($LASTEXITCODE -ne 0 -or $stats.Count -eq 0) { throw "Unparseable or empty patch: $($patch.id)" }
    Write-Host "$($patch.id): $($stats.Count) source files"
}
foreach ($test in $manifest.tests) {
    $path = Get-NativeRepositoryPath $test.path
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing public test source: $($test.path)" }
    if ($test.ContainsKey('sha256')) { $null = Assert-NativeHash $path $test.sha256 }
}
$scripts = @(Get-ChildItem -LiteralPath $PSScriptRoot -File -Filter '*.ps1') +
           @(Get-ChildItem -LiteralPath (Get-NativeRepositoryPath 'native/tests') -Recurse -File -Filter '*.ps1')
foreach ($script in $scripts) {
    $tokens = $null; $errors = $null
    $null = [Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$errors)
    if ($errors.Count -ne 0) { throw "PowerShell syntax errors in $($script.Name): $errors" }
}
if ($WeaselSourceArchivePath) {
    foreach ($variant in @('weasel-61033','weasel-61020')) {
        & (Join-Path $PSScriptRoot 'Apply-Patches.ps1') -Variant $variant -SourcePath $WeaselSourceArchivePath -CheckOnly -AllowSourceArchive
    }
}
[ordered]@{inventoryPassed=$true; patches=$manifest.patches.Count; parsedScripts=$scripts.Count; compilerRun=$false} | ConvertTo-Json -Compress
