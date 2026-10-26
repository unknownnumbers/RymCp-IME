# Windows 原生來源與構建

本目錄提供實際採用的完整來源差異、固定上游及可執行的來源組裝／構建腳本。**發布這份來源時，新公開 workflow 尚未完成一次構建驗證。** 腳本可重跑不等於已成功編譯；請以當次 Actions 的分階段結果為準。

## 四種來源，三個產品部分

| 來源 variant | 產物／用途 |
| --- | --- |
| `weasel-61033` | x86／x64 TSF與x64服務，來源版本 `0.17.4.61033` |
| `weasel-61020` | 保留的x86／x64 IME，來源版本 `0.17.4.61020` |
| `engine-n01` | 現用引擎來源：N01詞碼接點與step-only GC；本入口只宣告x64 |
| `engine-r5` | 前端構建SDK及受控fixture的R5引擎，x64／x86；與N01執行時引擎分開 |

每個Weasel variant都從相同固定官方提交開始套自己的完整delta。兩份Weasel patch不能依序疊套。N01與R5的core／Lua patch也分別套在各自原始上游，不互相疊加。

[source-manifest.json](source-manifest.json) 記錄所有公開來源URL、提交、patch SHA256、架構和下載資產。來源組裝固定取Weasel、librime、librime-lua、octagram、predict與Lua thirdparty；Weasel的submodules隨其固定提交初始化。原生程式含既有日語備註排版的schema識別碼，這不要求取得外部Sela詞典；配置來源及日語資料另由專案來源清單說明。

## 執行Actions

在GitHub的Actions開啟 **Native source assembly and optional compilation**，選擇Run workflow。

- `compile=false`（預設）：先核對六份patch的SHA256和PowerShell語法，再以四個隔離checkout檢查固定來源、submodules及完整patch套用。每個variant只產生來源組裝報告，沒有執行編譯器。
- `compile=true`：來源組裝通過後，同次workflow構建R5 x64、R5 x86和N01 x64；R5成功產物供後續兩個Weasel variant使用。沒有跨倉庫、歷史run ID、私有artifact或額外token依賴。

整個workflow只有`contents: read`。它使用新的hosted runner，沒有讀取個人設定或學習庫，不執行安裝、註冊、現場輸入捕捉或部署。下載官方Weasel installer只用7-Zip抽取固定共用資料，從不執行該installer；構建命令也沒有`installer`目標。

成功開發產物會附帶本repo的第三方通知、完整patch與構建腳本，只作當次開發構建輸出。它們不是獨立安裝包，也沒有完成完整真應用輸入驗收。

## 腳本入口

需要PowerShell7及Git。以下在repo根目錄執行；目的資料夾必須是新位置，腳本不會重置既有checkout：

```powershell
./scripts/native/Test-Inventory.ps1
./scripts/native/Prepare-Sources.ps1 -Variant engine-n01 -Destination ./work/engine-n01
./scripts/native/Prepare-Sources.ps1 -Variant weasel-61033 -Destination ./work/weasel-61033
```

`Prepare-Sources.ps1`會取得指定上游，再由`Apply-Patches.ps1`核對commit和patch雜湊、先check後apply。組裝結果在目的資料夾的`native-source-assembly.json`；來源組裝成功不代表編譯成功。

若已有精確上游原始碼壓縮包，可只做唯讀套用檢查：

```powershell
./scripts/native/Apply-Patches.ps1 -Variant weasel-61033 -SourcePath ./upstream-weasel -CheckOnly -AllowSourceArchive
```

這個檢查只證明檔案內容符合patch上下文，沒有檢查壓縮包的Git提交身份；`AllowSourceArchive`只准與`CheckOnly`一起使用。正式來源組裝及構建要求固定Git checkout。

Windows編譯還需要預先具備VS2022 v143、ATL/MFC x86／x64、MSBuild、CMake、Ninja與7-Zip。腳本不安裝這些工具。Actions中的`ilammy/msvc-dev-cmd`和`microsoft/setup-msbuild`設定已有工具的環境。

引擎的實際構建入口是：

```powershell
# 在已設定適當x64或x64_x86 MSVC環境的Windows runner上：
./scripts/native/Build-Engine.ps1 -Variant engine-r5 -Architecture x64 -SourcePath ./work/engine-r5-x64 -CacheDirectory ./work/cache -OutputDirectory ./work/out/engine-r5-x64
```

每個架構使用獨立的來源組裝目錄。R5另做x86；N01使用`-Variant engine-n01 -Architecture x64`。腳本套用相同的Ninja／MSVC設定，編譯34項production preedit helper測例，執行上游`build.bat test`並要求CTest成功證據，再核對DLL架構及輸出。官方deps壓縮包提供第三方庫的預編譯輸入；這不是整條依賴鏈完全從原始碼重建。

Weasel的入口是`Build-Weasel.ps1`，參數見workflow。它要求同次workflow的R5 x64／x86 SDK及相同manifest hash，從Boost1.84.0源碼編譯所需靜態庫，執行`build.bat weasel rebuild`。61033額外最後重建兩架TSF，以避開IME與TSF共用PDB路徑。公開產物只收manifest宣告的TSF／服務或IME，不把61033順帶編出的IME冒稱現用61020。

Weasel另跑兩架各36項Shift capture／codec及抽取產品handler的合成fixture。這個runner只允許在hosted CI執行；它不啟動安裝的服務，不注入產品DLL，也不改個人registry。它不等於真named-pipe、OS按鍵排序或完整宿主文字儲存的測試。本次沒有搬入整套歷史現場診斷和交接紀錄，也未宣稱已重跑全部舊產品回歸。

## 固定範圍與限制

六份patch保留原始內容；Weasel沿GPLv3，第三方元件和資料各保留原授權。原創構建腳本採GPLv3；本文採CC BY-SA4.0，這不改變所引用第三方原始碼與通知的授權。

Boost1.84.0的SHA256採官方發布metadata；固定Weasel0.17.4資產的SHA256採官方GitHub release digest並與既存官方檔核對。兩份librime1.13.1 deps的GitHub API沒有digest，本專案於2026-10-26從官方資產URL下載後計算並固定SHA256。下載後的位元不符時腳本停止。

- [Boost官方hash](https://archives.boost.io/release/1.84.0/source/boost_1_84_0.7z.json)
- [Weasel固定release資產metadata](https://api.github.com/repos/rime/weasel/releases/assets/260794274)
- [librime固定release](https://github.com/rime/librime/releases/tag/1.13.1)

GitHub hosted image、MSVC／Windows SDK的修訂版，以及Actions major tags仍會變動；腳本記錄當次compiler、toolset、manifest和產物hash。這份流程固定主要來源與下載位元，**不宣稱二進位逐bit可重現**。組裝通過、編譯通過、受控fixture通過和真應用驗收應分別報告。
