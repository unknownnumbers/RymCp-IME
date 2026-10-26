# 公開來源索引

本目錄說明公開配置、Lua、字典與原生修改使用哪些來源，以及本工程改過什麼。原始授權／署名正文已隨[licenses](../../licenses/)提供；範圍總表見[THIRD_PARTY_NOTICES](../../THIRD_PARTY_NOTICES.md)。這些來源檔沒有個人學習資料。

| 材料 | 來源及修改說明 |
| --- | --- |
| Luna／essay與中文詞碼／權重 | [中文主表](dictionary-quality-q121-sources.md)、[PDE詞與essay權重](pde-terms-sources.md) |
| 英文核心／索引 | [固定成品、來源及未知](english-core-sources.md) |
| 英文擴展／大小寫／PDE | [Ice擴展](english-extensions-sources.md)、[SCOWL大小寫](english-case-forms-sources.md)、[PDE](english-pde-sources.md) |
| 混合詞 | [五條精選資料](mixed-phrases-sources.md) |
| 拆字／筆畫 | [上游來源鏈與變換](radical-stroke-sources.md)、[現用筆畫1.1](query-strokes-source.json) |
| Unicode及工具 | [uU讀音](u-readings-sources.md)、[計算器／Unicode／取字](tools-sources.md) |
| 日語q／v資料與假名規則 | [q資料及生成邊界](jp-q-sources.md)、[v官方來源](jp-v-sources.md) |
| 小型字形規則 | [MDX參考背景與公開範圍](mdx-orthography-sources.md) |
| 自編／精選小表 | [三個數學詞](project-terms-sources.md)、[兩句詩](project-literary-sources.md) |
| TC模型 | [固定release／asset／SHA256](luna-compact-model-sources.md) |
| 前端／引擎／插件 | [固定源碼及授權](native-components.md) |

## 已知的來源版本限制

Luna字典與essay來自官方Weasel0.17.4資料，Luna原版本為2024.02.10；安裝包所用精確上游commit未識別。現用筆畫查詢以同一安裝包的stroke1.1產生，不能用另有研究記錄的stroke2.0冒充同一來源。

英文核心固定為SymSpell v6.7.3的詞頻成品。該成品聲明使用Google Books Ngram與SCOWL，但精確Google語料版本／切片、SCOWL版本／選項及完整上游過濾程序未識別。大小寫佐證則另外明確使用SCOWL2020.12.07；不能把兩個來源版本混為一談。

Mirtle根來源已固定commit，其credits列出的kfcd／CHISE／yi-bai及henrysting通知均有保存。Mirtle實際合入各上游資料的精確revision與逐行關係未提供；補充通知中的所見commit只固定通知文件，不倒填為歷史資料版本。

日語q／v資料保存官方來源日期、授權及來源規則。較早的產生流程曾從原Sela方案讀取假名映射或28種字種選集；公開版日語基底按需求獨立生成，原表及schema正文不隨包發布。相容識別碼保留不等於資料來源沿用；各生成結果與驗證界線按[日語說明](jp-q-sources.md)記錄。

這些限制不被根授權文字補寫成已知事實。公開的字典源檔可以直接修改與重新部署；上游資料刷新須依各資料說明保留來源、通知及變換紀錄，不能把既有修訂權重重複倍乘。
