# 英文擴展：來源與變換

來源為[iDvel/rime-ice](https://github.com/iDvel/rime-ice/tree/da1fbe602e38f26db846fa10120ee64c2b0324c0)，固定`da1fbe602e38f26db846fa10120ee64c2b0324c0`：

- [en_ext.dict.yaml](https://github.com/iDvel/rime-ice/blob/da1fbe602e38f26db846fa10120ee64c2b0324c0/en_dicts/en_ext.dict.yaml)提供擴展詞與規範顯示。
- [melt_eng.schema.yaml](https://github.com/iDvel/rime-ice/blob/da1fbe602e38f26db846fa10120ee64c2b0324c0/melt_eng.schema.yaml)的`algebra_common`數字／符號部分用作字母別名生成參考。
- 原授權為[GPLv3](../../licenses/english-extensions-Ice-GPL-3.0.txt)，署名及來源保留。

本工程將查詢鍵轉小寫，保留來源候選拼寫；用字母別名表示原數字／標點碼，使數字仍可作候選選擇鍵。沒有匯入整套Ice配置或中文數字讀法派生。

既有核心詞保留其原生學習身份；擴展加入同一`pc_english` Memory。品牌拼寫、縮寫正文優先、中文模式門檻、跨語排序及學習路由屬本工程整合。核心頻數仍依[英文核心來源](english-core-sources.md)，不能以本擴展GPL通知覆蓋Google／SCOWL署名。後加專名與權重見[英文PDE](english-pde-sources.md)。
