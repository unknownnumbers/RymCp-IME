# 日語基底與 q／x／v

這份日語 schema 和純假名字典按 RymCp 現用的五母音、行、拗音、擴展音及本工程規則生成。`jp_sela` 和 `jp_sela_custom` 是 RymCp 現用模組／學習介面的 ID，沿用名稱不改既定介面。早期方案設計曾借鑒 [Sela/rime-jp_sela](https://github.com/Selaube/rime-jp_sela)，其後的假名、漢字與 q／x／v 規則以本工程為準。

小寫碼輸出平假名，大寫碼輸出片假名；小假名前加 x，例如 xa／XA、xtsu／XTSU。xX 是現有整段小假名查詢入口，另有 Unicode 小假名擴展表。q／qQ 使用有來源的 JMdict 詞形，v／vV 用中文拼音查日本漢字及讀音。Ctrl+E 選日語方案，Ctrl+R 返回中文／智能英文方案。

## 生成與驗證

需要 Python 3.10 或更新版本。從倉庫根目錄執行：

```powershell
python config/pc/tools/generate-japanese-base.py --output out/japanese-base
python config/pc/tools/validate-japanese-base.py --directory config/pc
```

產生器不讀外部字典、不連線、不讀學習庫，且拒絕覆寫已存在的輸出目錄。它產生新 schema、673 行假名字典和 322 項 `japanese-q-canonical.json`。q 資料重建器應以這個 JSON object 作為假名片段→碼的輸入，鼻音 n／n'／詞尾 nn 由 q 的 romanize 規則處理。

本工程規則包括 di／dsu、wi／we 輸出ゐ／ゑ、長音 l／L、促音重複首字母，以及 x 小假名。這不是宣稱所有碼都是單一標準羅馬字。詳情可讀產生器中的命名規則和公開驗證案例。

`jp-v-compatibility.json` 是本工程明列的 28 個字種集合，每字保留 Unihan 日本來源與讀音依據；v 重建時從官方資料取音。檔名沿用現用工具介面。

## 保留功能與差異

現有 q／v Lua、JMdict／KANJIDIC2／Unihan 資料與學習介面保持。公開重建器已從固定 JMdict XML 與這份獨立 canonical inventory 完整重生 q 詞庫，共 423,663 行；SHA256 為 `a88dbdca92805084447df214ce135402b58b1842844fcc7ffbfa8f4af1be7e05`，與本包 `jp_q_lookup.dict.yaml` 逐位元一致。實際命令見[構建說明](../../docs/BUILD.md)。

322 項拼寫的比對對象是本工程現用 q 詞庫，並非早期參考方案的舊版。假名、漢字與 q／x／v 規則以本工程為準，不復刻舊表；漢字候選依公開、可署名的 q／v 資料提供。v 全量資料尚未在本輪重生，q 的等值結果不代表 v 已完整重建。

公開驗證腳本覆蓋碼字對照、大小寫、鼻音邊界、促音、擴展音與生成檔一致性；完整引擎與候選次序驗證需另外執行。沒有把舊 Sela 表作公開測試輸入。第三方來源及資料授權見 [JP q 來源](../../docs/sources/jp-q-sources.md) 與 [JP v 來源](../../docs/sources/jp-v-sources.md)。
