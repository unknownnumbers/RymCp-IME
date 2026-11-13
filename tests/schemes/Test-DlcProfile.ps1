# SPDX-License-Identifier: GPL-3.0-only
# Full public profiles and optional catalogs, in a fresh isolated user directory.
param(
 [Parameter(Mandatory=$true)][string]$EngineDll,
 [Parameter(Mandatory=$true)][string]$ProfileRoot,
 [Parameter(Mandatory=$true)][string]$ModulesDirectory,
 [Parameter(Mandatory=$true)][string]$SharedDirectory,
 [Parameter(Mandatory=$true)][string]$OutputDirectory,
 [string]$PythonExe='python'
)
$ErrorActionPreference='Stop'
$utf8=New-Object Text.UTF8Encoding($false)
$out=[IO.Path]::GetFullPath($OutputDirectory)
if(Test-Path -LiteralPath $out){throw 'Use a fresh output directory.'}
$repo=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
$profileSource=[IO.Path]::GetFullPath($ProfileRoot)
$moduleSource=[IO.Path]::GetFullPath($ModulesDirectory)
$Profile=Split-Path $profileSource -Leaf
$RealModules=$true
if(@(Get-ChildItem -LiteralPath $profileSource -Directory -Filter '*.userdb').Count){throw 'ProfileRoot must contain public source files without learning databases.'}

$user=Join-Path $out 'user';$shared=Join-Path $out 'shared';$logs=Join-Path $out 'logs'
foreach($dir in @($user,$shared,$logs,(Join-Path $user 'build'))){[IO.Directory]::CreateDirectory($dir)|Out-Null}
foreach($entry in Get-ChildItem -LiteralPath $profileSource -Force){Copy-Item -LiteralPath $entry.FullName -Destination $user -Recurse}
if(Test-Path -LiteralPath (Join-Path $user 'samples')){foreach($entry in Get-ChildItem -LiteralPath (Join-Path $user 'samples') -File){Copy-Item -LiteralPath $entry.FullName -Destination (Join-Path $user $entry.Name)}}
$standard=[IO.Path]::GetFullPath($SharedDirectory)
foreach($name in @('default.yaml','pinyin.yaml','grammar.yaml','key_bindings.yaml','punctuation.yaml','symbols.yaml','stroke.dict.yaml','stroke.schema.yaml')){
 $source=Join-Path $standard $name
 if(Test-Path -LiteralPath $source){Copy-Item -LiteralPath $source -Destination (Join-Path $shared $name)}
}
if(Test-Path -LiteralPath (Join-Path $standard 'opencc')){Copy-Item -LiteralPath (Join-Path $standard 'opencc') -Destination (Join-Path $shared 'opencc') -Recurse}
function Write-Text([string]$path,[string]$value){[IO.Directory]::CreateDirectory((Split-Path $path -Parent))|Out-Null;[IO.File]::WriteAllText($path,$value,$utf8)}
Write-Text (Join-Path $user 'default.custom.yaml') "patch:`n  schema_list:`n    - schema: pc_research`n"
Write-Text (Join-Path $user '.synthetic-profile.json') '{"format":1,"kind":"fixed-synthetic-dlc-profile","PersonalLearningCopied":false}'
$dll=[IO.Path]::GetFullPath($EngineDll);$env:PATH=(Split-Path $dll -Parent)+';'+$env:PATH
Add-Type -TypeDefinition ([IO.File]::ReadAllText((Join-Path $repo 'tests/RimeProbe.cs'),$utf8).Replace('__RIME_ENGINE_DLL__',$dll))
$ids=@('math','physics','computer','poetry')
$codes=@('ce shi jia jia','ce shi yi yi','ce shi bo bo','ce shi du du')
$words=@('DLCMathFixture','DLCPhysicsFixture','DLCComputerFixture','DLCPoetryFixture')
function Adler32([byte[]]$data){[long]$a=1;[long]$b=0;foreach($value in $data){$a=($a+$value)%65521;$b=($b+$a)%65521};return ('{0:x8}' -f [long]($b*65536+$a))}
function Write-Module([int]$index,[string]$text='',[string]$revision='1'){
 $id=$ids[$index];if(-not $text){$text=$words[$index]}
 $directory=Join-Path $user ('rymcp_dlc/'+$id)
 if($RealModules){
  Remove-Module $id
  [IO.Directory]::CreateDirectory((Split-Path $directory -Parent))|Out-Null
  Copy-Item -LiteralPath (Join-Path $moduleSource $id) -Destination $directory -Recurse
  foreach($file in Get-ChildItem -LiteralPath $directory -File -Filter '*.dict.yaml'){$value=[IO.File]::ReadAllText($file.FullName,$utf8);$value=$value -replace '(?m)^version:.*$',("version: '"+$revision+"'");Write-Text $file.FullName $value}
  $row="$text`t$($codes[$index])`t1000000`n"
  [IO.File]::AppendAllText((Join-Path $directory 'words.dict.yaml'),$row,$utf8)
  if($id -eq 'poetry'){[IO.File]::AppendAllText((Join-Path $directory 'words_00.dict.yaml'),$row,$utf8)}
  $manifest="format`t1`nid`t$id`nrevision`t$revision`nlanguages`t"+$(if($id -eq 'poetry'){'cn'}else{'cn,en'})+"`n"
  foreach($file in Get-ChildItem -LiteralPath $directory -File -Recurse|Sort-Object FullName){
   if($file.Name -eq 'manifest.tsv'){continue}
   $relative=$file.FullName.Substring($directory.Length+1).Replace('\','/')
   $bytes=[IO.File]::ReadAllBytes($file.FullName)
   $manifest+="file`t$relative`t$($bytes.Length)`t$(Adler32 $bytes)`n"
  }
  Write-Text (Join-Path $directory 'manifest.tsv') $manifest
  return
 }
 $data="---`nname: rymcp_dlc/$id/words`nversion: '$revision'`nsort: by_weight`nuse_preset_vocabulary: false`npatch:`n  translator/packs/+:`n    - rymcp_dlc_$id`n...`n$text`t$($codes[$index])`t1000000`n"
 Write-Text (Join-Path $directory 'words.dict.yaml') $data
 $bytes=$utf8.GetBytes($data)
 Write-Text (Join-Path $directory 'manifest.tsv') "format`t1`nid`t$id`nrevision`t$revision`nlanguages`tcn`nfile`twords.dict.yaml`t$($bytes.Length)`t$(Adler32 $bytes)`n"
}
$traits=New-Object RimeProbe+Traits;$traits.data_size=[Runtime.InteropServices.Marshal]::SizeOf($traits)-4
foreach($pair in @(@('shared_data_dir',$shared),@('user_data_dir',$user),@('prebuilt_data_dir',(Join-Path $user 'build')),@('staging_dir',(Join-Path $user 'build')),@('log_dir',$logs),@('app_name','rime.dlc_profile_synthetic'))){$traits.($pair[0])=[Runtime.InteropServices.Marshal]::StringToHGlobalAnsi($pair[1])}
$traits.min_log_level=2;$script:initialized=$false;$script:s=[UIntPtr]::Zero
$checks=[Collections.Generic.List[object]]::new()
function Check([string]$id,[bool]$passed,$actual=$null){$checks.Add([pscustomobject]@{Id=$id;Passed=$passed;Actual=$actual});if(-not $passed){throw ('CN DLC profile check failed: '+$id)}}
function Close-Engine{if($script:initialized){[RimeProbe]::RimeFinalize();$script:initialized=$false;$script:s=[UIntPtr]::Zero}}
function Start-Engine{[RimeProbe]::RimeInitialize([ref]$traits);$script:initialized=$true}
function Redeploy{
 Close-Engine;Start-Engine;[RimeProbe]::RimeDeployerInitialize([ref]$traits)
 Check 'deploy-api' ([RimeProbe]::RimeDeployWorkspace() -ne 0)
 Check 'compiled-schema' (Test-Path -LiteralPath (Join-Path $user 'build/pc_research.schema.yaml'))
 if(Test-Path -LiteralPath (Join-Path $user 'rymcp_dlc')){
  $installed=@(Get-ChildItem -LiteralPath (Join-Path $user 'rymcp_dlc') -Directory)
  if($installed.Count -eq 4){
   $script:capacityStep++
   & $PythonExe (Join-Path $PSScriptRoot 'Check-ChineseDlcTables.py') --build-dir (Join-Path $user 'build') --modules-dir (Join-Path $user 'rymcp_dlc') --output (Join-Path $out ('capacity-'+$script:capacityStep+'.json'))
   Check 'native-tables-complete-without-growth' ($LASTEXITCODE -eq 0)
  }
 }

 Close-Engine;Start-Engine
 $script:s=[RimeProbe]::RimeCreateSession();Check 'schema-select' ([RimeProbe]::RimeSelectSchema($script:s,'pc_research') -ne 0)
 [RimeProbe]::RimeSetOption($script:s,'probe_options_ready',1)
 [RimeProbe]::RimeSetOption($script:s,'ascii_mode',0)
 [RimeProbe]::RimeSetOption($script:s,'research_english',0)
 [RimeProbe]::RimeSetOption($script:s,'simplification',0)
}
function Query([string]$code){[RimeProbe]::RimeClearComposition($script:s);[void][RimeProbe]::ReadCommit($script:s);foreach($c in $code.Replace(' ','').ToCharArray()){[void][RimeProbe]::RimeProcessKey($script:s,[int]$c,0);[void][RimeProbe]::RimeProcessKey($script:s,[int]$c,0x40000000)};return [RimeProbe]::Snapshot($script:s,150)}
function Remove-Module([string]$id){$path=Join-Path $user ('rymcp_dlc/'+$id);if(-not ([IO.Path]::GetFullPath($path)).StartsWith(($user+'\'),[StringComparison]::OrdinalIgnoreCase)){throw 'Invalid synthetic module path.'};if(Test-Path -LiteralPath $path){Remove-Item -LiteralPath $path -Recurse}}
function Export-Learning([string]$name){Close-Engine;Start-Engine;[RimeProbe]::RimeDeployerInitialize([ref]$traits);$path=Join-Path $out $name;Check $name ([RimeProbe]::ExportUserDict('luna_pinyin',$path) -gt 0);Close-Engine;return @([IO.File]::ReadAllLines($path,$utf8)|Where-Object { $_ -and -not $_.StartsWith('#') }) -join "`n"}
$errorText=$null;$script:capacityStep=0
$inputHashes=[ordered]@{}
foreach($name in @('essay.txt','luna_pinyin.dict.yaml','luna_pinyin.research.dict.yaml','pc_research.schema.yaml','pc_research.custom.yaml','lua/cn_translator.lua','lua/cn_dlc.lua','lua/rymcp_dlc.lua')){$inputHashes[$name]=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $user $name)).Hash.ToLowerInvariant()}
try{
 [RimeProbe]::RimeSetup([ref]$traits)
 Redeploy
 Check 'neutral-no-dlc' (@((Query $codes[0]).Candidates) -notcontains $words[0])
 Check 'base-chinese' (@((Query 'ni hao').Candidates) -contains ([string][char]0x4f60+[char]0x597d))
 # Compile the exact distributed catalogs before adding learning fixtures.
 foreach($id in $ids){
  $directory=Join-Path $user ('rymcp_dlc/'+$id)
  [IO.Directory]::CreateDirectory((Split-Path $directory -Parent))|Out-Null
  Copy-Item -LiteralPath (Join-Path $moduleSource $id) -Destination $directory -Recurse
 }
 Redeploy
 Check 'distributed-catalogs-compiled' ($script:capacityStep -eq 1)
 for($i=0;$i -lt 4;$i++){Write-Module $i}
 Redeploy
 for($i=0;$i -lt 4;$i++){Check ('coexist-'+$ids[$i]) (@((Query $codes[$i]).Candidates) -contains $words[$i])}
 $snapshot=Query $codes[0];$index=[Array]::IndexOf([string[]]$snapshot.Candidates,$words[0])
 Check 'learn-selected-native-phrase' ([RimeProbe]::SelectCandidate($script:s,$index) -ne 0)
 [void][RimeProbe]::RimeCommitComposition($script:s);[void][RimeProbe]::ReadCommit($script:s)
 $before=Export-Learning 'synthetic-learning-before.tsv'
 Write-Module 2 'DLCComputerUpdatedFixture' '2'
 Redeploy
 $snapshot=Query $codes[2]
 Check 'update-new-word' (@($snapshot.Candidates) -contains 'DLCComputerUpdatedFixture')
 Check 'update-old-word-gone' (@($snapshot.Candidates) -notcontains $words[2])
 Close-Engine;Remove-Module 'physics';Redeploy
 Check 'uninstall-cache-retained' (Test-Path -LiteralPath (Join-Path $user 'build/rymcp_dlc_physics.table.bin'))
 Check 'uninstall-static-word-gone' (@((Query $codes[1]).Candidates) -notcontains $words[1])
 Check 'uninstall-keeps-others' (@((Query $codes[3]).Candidates) -contains $words[3])
 $after=Export-Learning 'synthetic-learning-after.tsv';Check 'learning-preserved' ($before -ceq $after)
 foreach($id in $ids){Remove-Module $id}
 Redeploy
 Check 'all-uninstalled-base-works' (@((Query 'ni hao').Candidates) -contains ([string][char]0x4f60+[char]0x597d))
 Check 'all-uninstalled-poetry-static-gone' (@((Query $codes[3]).Candidates) -notcontains $words[3])
 Close-Engine;Write-Module 0;Redeploy
 Check 'reinstall-candidate' (@((Query $codes[0]).Candidates) -contains $words[0])
 $reinstalled=Export-Learning 'synthetic-learning-reinstalled.tsv';Check 'reinstall-learning-preserved' ($before -ceq $reinstalled)
}catch{$errorText=$_.Exception.Message}finally{Close-Engine;@{Format='cn-dlc-profile-lifecycle-v1';Profile=$Profile;RealModules=[bool]$RealModules;InputHashes=$inputHashes;Completed=($null -eq $errorText);Error=$errorText;Checks=@($checks)}|ConvertTo-Json -Depth 8|Set-Content -LiteralPath (Join-Path $out 'results.json') -Encoding UTF8}
if($errorText){throw $errorText}
Write-Output ('CN DLC '+$Profile+': '+$checks.Count+' checks passed.')
