<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
# 可選詞表的來源與重建

四個詞表包分別提供數學、物理、電腦及詩詞資料. 基座不預裝這些包. 每個 ZIP 包含完整的 `rymcp_dlc/<id>/` 目錄、資料清單、來源紀錄及原授權通知.

| 包 | 中文詞條 | English 字詞 | 資料授權 |
| --- | ---: | ---: | --- |
| `math` | 700 | 348 | CC BY-SA 4.0 |
| `physics` | 388 | 216 | CC BY-SA 4.0 |
| `computer` | 680 | 345 | CC BY-SA 4.0 |
| `poetry` | 8358 | 0 | 生成詞表及讀音標注採 CC BY-SA 4.0, 原詩詞資料保留 MIT 通知 |

## 固定來源

來源原件保存在 [`dlc/sources`](../dlc/sources), 構建時逐一核對 SHA-256. 生成器使用 Python 標準庫, 從這些固定檔案離線重建.

| 檔案 | 上游來源 | SHA-256 |
| --- | --- | --- |
| `cedict_1_0_ts_utf-8_mdbg.txt.gz` | [MDBG / CC-CEDICT](https://www.mdbg.net/chinese/dictionary?page=cedict), 2026-11-13T04:51:32Z, 125412 條 | `3199822e3cb14dfd13b4c80374cefb6d02e579e92f39e5ac7e6a7fa702fae739` |
| `tang-300.json` | [chinese-poetry 的《唐詩三百首》](https://github.com/chinese-poetry/chinese-poetry/blob/b8594f81a89752241442f2ce267d6f66f96704ee/全唐诗/唐诗三百首.json) | `d77a145f7470da2ed2f79515944563c062ffc43fceda07f195a36ead66b7e5c7` |
| `song-300.json` | [chinese-poetry 的《宋詞三百首》](https://github.com/chinese-poetry/chinese-poetry/blob/b8594f81a89752241442f2ce267d6f66f96704ee/宋词/宋词三百首.json) | `ca5d74f7fdb9d5a6acc22a7c8b4395228cad4bb8be53df44c19ba83ab6983b20` |
| `allowed-syllables.txt` | 從公開 Luna 主詞表抽取的 424 個原生音節, 用於兼容性檢查 | `ddd9b253b4f3412d17ed1c119d9d3b36f1153e7c3ff7f62e20e59cdfd1856689` |

詩詞來源固定於 commit `b8594f81a89752241442f2ce267d6f66f96704ee`. 兩份 JSON 及該 commit 的 MIT 通知保留原始 bytes. CC-CEDICT 的原件、來源與 CC BY-SA 4.0 通知一併保留. 合法音節集合的來源檔案為 `config/pc/luna_pinyin.dict.yaml`, 抽取時 SHA-256 為 `0397c7741c3347631412f5bd20a6787087ca6c27093a46f216cfc8bb754f285f`, 該來源採 LGPL-3.0.

## 系統抽取規則

數學、物理及電腦包遍歷整份 CC-CEDICT, 按英文釋義中的括號領域標記篩選. 範圍由原詞典的領域標記決定. 實際正則表達式及略過計數保存在各包的 `SOURCE.json`.

- 數學涵蓋 math、mathematics、geometry、algebra、statistics、arithmetic、calculus、topology、probability 等標記.
- 物理涵蓋 physics、mechanics、optics、electronics、electricity、electrical、thermodynamics、acoustics 等標記.
- 電腦涵蓋 computing、computer、programming、software、internet 等標記, 略過 internet slang 標記.
- 中文採來源 TC 頭詞及其拼音, 移除聲調數字, 將 `ü`、`u:` 寫成 `v`, 並檢查原生音節. 含非漢字的頭詞及無法編碼的讀音列入略過計數.
- English 從入選條目的釋義移除括號註釋後, 僅保留整段符合 `[A-Za-z]+` 的單詞, 寫成 lowercase 普通詞條. 多詞釋義不拆成字詞.

全部新增詞條使用固定權重 `100`. 同包按 canonical code 和詞文去重. 與基座或其他包重合時, 由載入器沿固定來源次序合併身份, 不累加詞頻.

詩詞包遍歷兩份完整 anthology 的所有 `paragraphs`, 移除單字周圍的 ASCII 方括號並保留其中字元, 再按漢字分句抽取. 來源實際包含唐詩 366 作和宋詞 280 作. 讀音採 CC-CEDICT 的最長完整詞匹配, 同一頭詞的多個讀音按固定來源原有順序選取. 唐詩優先匹配 TC 頭詞, 宋詞優先匹配 SC 頭詞, 輸出相應 TC 頭詞及拼音. 來源 JSON 保持原樣.

唐詩共有 3549 個分句, 可編碼 3532 個, 略過 17 個. 宋詞共有 5212 個分句, 全部可編碼. 去重後共 8358 條. 字形轉換及讀音為自動處理, 尚未逐句審校.

## 重建與安裝

在專案根目錄執行:

```sh
python scripts/build_dlc.py --archive-dir out/dlc
```

展開目錄輸出至 `dlc/modules/rymcp_dlc/`, ZIP 預設輸出至 `out/dlc/`, 可由 `--archive-dir` 指定. `dlc/modules/build-report.json` 記錄詞條數、固定輸入雜湊及 ZIP 雜湊. 生成器採固定檔案次序、時間戳及不壓縮的 ZIP 格式, 相同來源會產生相同 bytes.

解壓所需 ZIP 至 Rime 使用者資料夾, 使資料位於 `rymcp_dlc/<id>/`, 然後重新部署. 卸載時刪除該包的完整目錄, 再重新部署. 個人學習資料保留在本地. 與基座或其他包共用的字詞仍可由保留的來源提供.

每包的 `manifest.tsv` 列出全部資料、來源及授權檔案的大小與 Adler-32. 複製完成後保留整個目錄. 清單、檔案或資料格式檢查失敗時, 該包不啟用.

詩詞的完整詞條清單為 `words.dict.yaml`, 原生表使用 `words_00.dict.yaml` 至 `words_31.dict.yaml` 共 32 個分片. 分片按 canonical code、詞文排序後連續等分, 全部條目與權重和完整清單一致. 表頭透過所需的 include 鏈啟用全部分片. 載入器會核對完整清單與分片的聯集.

生成器程式碼採 GPL-3.0-only. 本說明採 CC BY-SA 4.0. 第三方來源保留各自原授權及通知.
