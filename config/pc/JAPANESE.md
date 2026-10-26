# 日語輸入

提供平假名、片假名、漢字及 q/x/v 查詢. 以下說明本工程目前的輸入規則與資料生成方式.

小寫碼輸出平假名, 大寫碼輸出片假名; 小假名前加 x, 例如 xa/XA、xtsu/XTSU. xX 是整段小假名查詢入口, 另有 Unicode 小假名擴展表. q/qQ 使用 JMdict 詞形, v/vV 用國語拼音查日語漢字及讀音. Ctrl+E 選日語方案, Ctrl+R 返回中文/智能英文方案.

## 生成與驗證

需要 Python 3.10 或更新版本. 從倉庫根目錄執行:

```powershell
python config/pc/tools/generate-japanese-base.py --output out/japanese-base
python config/pc/tools/validate-japanese-base.py --directory config/pc
```

產生器不讀外部字典、不連線、不讀學習庫, 且拒絕覆寫已存在的輸出目錄. 它產生新 schema、673 行假名字典和 322 項 `japanese-q-canonical.json`. q 資料重建器應以這個 JSON object 作為假名片段→碼的輸入, 鼻音 n/n'/詞尾 nn 由 q 的 romanize 規則處理.

輸入規則包括 di/dsu、wi/we 輸出ゐ/ゑ、長音 l/L、促音重複首字母, 以及 x 小假名. 詳情見產生器中的規則和驗證案例.

`jp-v-compatibility.json` 是本工程明列的 28 個字種集合, 每字保留 Unihan 日本來源與讀音依據; v 重建時從官方資料取音. 檔名沿用現用工具介面.

## 資料與驗證

現有 q/v Lua、JMdict/KANJIDIC2/Unihan 資料與學習介面保持. 公開重建器已從固定 JMdict XML 與這份獨立 canonical inventory 完整重生 q 詞庫, 共 423,663 行; SHA256 為 `a88dbdca92805084447df214ce135402b58b1842844fcc7ffbfa8f4af1be7e05`, 與本包 `jp_q_lookup.dict.yaml` 逐位元一致. 實際命令見[構建說明](../../docs/BUILD.md).

q 查詢使用本工程現用的 322 項拼寫. 漢字候選由 q/v 資料提供, v 的全量重建仍列於待辦.

規則驗證腳本覆蓋碼字對照、大小寫、鼻音邊界、促音、擴展音與生成檔一致性. 引擎部署及候選檢查見構建說明. 第三方來源與資料授權見 [JP q 來源](../../docs/sources/jp-q-sources.md) 與 [JP v 來源](../../docs/sources/jp-v-sources.md).
