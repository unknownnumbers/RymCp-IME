# 本機 OpenCC 資源設定

`opencc/mdx_t2s.json` 保留目前 MDX 小範圍字形規則及官方 TC→SC 轉換鏈, 資料內容沒有改動. 倉庫中的 JSON 僅使用相對檔名, 不含任何人的安裝位置.

Rime 會先在 user/opencc、再在 shared/opencc 尋找 JSON; JSON 裡的字典檔案則由 OpenCC 自己搜尋, 不能據此前一個步驟推定它也會跨到 Rime shared/opencc. 因此在只有 user/opencc/mdx_words.txt、而標準字典留在 shared/opencc 的安裝中, 先生成本機 JSON:

```powershell
python config/pc/tools/make-opencc-config.py --shared-dir <Rime共享資料目錄> --output out/local-mdx_t2s.json
```

工具也接受直接指定共享資料的 opencc 子目錄. 它檢查 TSPhrases.ocd2/TSCharacters.ocd2 及本包 mdx_words.txt, 將三者的本機絕對位置寫入一份新 JSON, 不複製或下載字典, 拒絕覆寫既有檔案. 安裝時將結果命名為 user/opencc/mdx_t2s.json; 生成結果含本機位置, 留在本機, 不要提交到公開倉庫.

若標準字典和 JSON 已放在同一 opencc 目錄, 相對檔名可由 OpenCC 在 JSON 所在目錄找到. 本次檢查確認來源搜尋規則與資源檔存在, 未把所有安裝環境的相對路徑解析宣稱為已驗證.

[MDX 規則來源](../../docs/sources/mdx-orthography-sources.md) 與 [OpenCC 授權](licenses/OpenCC-LICENSE.txt) 分別保留. TC/SC輸出選擇與介面語言分開.
