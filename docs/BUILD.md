# 源碼與構建

本倉庫以固定上游提交及完整補丁提供原生修改, 構建步驟見[native/BUILD.md](../native/BUILD.md). 源碼組裝與原生編譯分開驗證; 本次提供源碼與配置, 不含獨立安裝器.

## 原生來源

- Weasel 的 `weasel-61047` 完整補丁對應 x86/x64 TSF.
- Weasel 的 `weasel-server-61042` 完整補丁對應 x64 Server.
- Weasel 的 `weasel-61020` 完整補丁對應保留的 x86/x64 IME.
- librime 及 librime-lua 的 `engine-n01` 完整補丁對應 step-only N01 x64 執行時引擎.
- `engine-r5` 另從固定源碼與補丁構建 x64/x86 前端 SDK.

三份 Weasel 補丁各自套在相同固定官方提交, 不能順序疊加. 工具鏈、submodules、外部依賴、下載與測試入口由原生 manifest 及 workflow 列出. 公開 Actions 只串接當次構建產物.

## 配置與資料

- 配置及Lua位於`config/pc`, 需配套原生介面及官方共用資料.
- 新日語基底的規則生成與驗證見[日語說明](../config/pc/JAPANESE.md).
- q詞庫可用獨立假名inventory從官方JMdict重建, 輸出必須是新目錄:

```powershell
python scripts/data/build_japanese_q.py --source <官方JMdict_e.gz路徑> --out out/japanese-q
```

固定2026-10-19來源的SHA256見[q來源說明](sources/jp-q-sources.md), 也可加`--expected-source-sha256`要求相符. 本次已用該來源完整重生423,663行q詞典, 與隨附詞典SHA256完全一致; 後續新版JMdict的差異需另行核對.

- 英文索引可由隨附詞表重建:

```powershell
python scripts/data/build_english_index.py config/pc/english_index/vocabulary.tsv --out out/english-index
```

這個命令使用新的輸出目錄, 不改現有詞表或使用者學習庫. 生成的`words.txt`、`keys.bin`及`postings.bin`對應Lua索引讀取格式. 詞表的來源、授權與歷史未知仍須保留, 不能因重建索引就改標原資料授權.

## 驗證與重現範圍

發布清單保存實際檔案的SHA256, 檢查工具核對檔案完整性、必要依賴與不應隨包出現的個人材料. 構建記錄須分清"來源可組裝""原生可編譯""隔離引擎功能通過"與"真實應用已驗收".

已固定的成品來源與本工程變換可以重跑, 不代表全部歷史上游語料已逐源重建. 也不承諾不同Windows runner/compiler/SDK產出的二進位逐位元一致.

## 隔離配置測試

Windows、PowerShell及配套引擎可用時, 在新的輸出目錄部署配置:

```powershell
./tests/Probe-Configuration.ps1 -EngineDll <配套rime.dll路徑> -SharedData <官方共享資料目錄> -Output out/config-check -Phase Compile
./tests/Probe-Configuration.ps1 -EngineDll <配套rime.dll路徑> -SharedData <官方共享資料目錄> -Output out/config-check -Phase Query
./tests/Probe-Configuration.ps1 -EngineDll <配套rime.dll路徑> -SharedData <官方共享資料目錄> -Output out/config-check -Phase Sequences
```

測試只複製本倉庫配置, 在`Output/publicuser`產生編譯資料及合成學習, 在`Output/results`留結果; 不讀既有使用者資料或操作已安裝服務. 每次Compile使用全新Output, 各Phase報告不可覆寫. 原生源碼組裝檢查與此引擎功能檢查分開記錄.

2026-10-26的源碼快照已在隔離空庫完成10個方案部署檢查、158項日語查詢/選取檢查及94項連續輸入/餘碼檢查, 均通過; 另有65項獨立假名規則檢查. 使用的是固定N01 x64引擎與官方Weasel0.17.4共享資料. 這些結果覆蓋本工程目前規則, 不是與原作者方案作相容驗收, 也不等於所有真實桌面應用已驗收.
