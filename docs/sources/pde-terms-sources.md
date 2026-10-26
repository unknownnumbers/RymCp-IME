# PDE精選詞與essay初始權重

`project_pde_terms`使用TC規範詞形及國語標準拼音, 字典保留`ing/eng`, SC輸出由既有轉換層處理. 新增18詞的初始值均為400; 後續多解性/弱解/緊性改為1600, 其餘保持400. 這些是本工程選定的初始排序參數, 不是私人使用次數或跨詞庫比較的語料分數.

## 18條詞與來源

白霜來源固定[gaboolic/rime-frost@19c615189c1173a84e7e9970469fb3d38db45766](https://github.com/gaboolic/rime-frost/tree/19c615189c1173a84e7e9970469fb3d38db45766), 參考檔為[cn_dicts_cell/shulihua.dict.yaml](https://github.com/gaboolic/rime-frost/blob/19c615189c1173a84e7e9970469fb3d38db45766/cn_dicts_cell/shulihua.dict.yaml), [GPLv3全文](../../licenses/pde-terms-reference-GPL-3.0.txt) 隨附. 只借下列明列詞/拼音, 不匯入整份表. TC整理及初始權重由本工程完成.

| 詞 | 規範拼音 | 來源 |
| --- | --- | --- |
| 有限維約化 | `you xian wei yue hua` | 本工程編寫 |
| 二階項 | `er jie xiang` | 本工程編寫 |
| 偏導數 | `pian dao shu` | 白霜第19070行 |
| 臨界條件 | `lin jie tiao jian` | 白霜第18186行 |
| 多解性 | `duo jie xing` | 本工程編寫 |
| 漸近性態 | `jian jin xing tai` | 本工程編寫 |
| 橢圓型偏微分方程 | `tuo yuan xing pian wei fen fang cheng` | 白霜第21412行 |
| 弱解 | `ruo jie` | 白霜第19879行 |
| 緊性 | `jin xing` | 白霜第17040行 |
| 先驗估計 | `xian yan gu ji` | 白霜第22215行 |
| 臨界指數 | `lin jie zhi shu` | 本工程編寫 |
| 能量泛函 | `neng liang fan han` | 本工程編寫 |
| 緊嵌入 | `jin qian ru` | 本工程編寫 |
| 非退化 | `fei tui hua` | 白霜第14903行 |
| 山路定理 | `shan lu ding li` | 本工程編寫 |
| 有界域 | `you jie yu` | 白霜第23142行 |
| 弱收斂 | `ruo shou lian` | 白霜第19898行 |
| 強收斂 | `qiang shou lian` | 白霜第19450行 |

## essay的17項初始權重

`essay.txt`源自官方Weasel0.17.4安裝資料的[rime-essay](https://github.com/rime/rime-essay) 成品; 精確上游commit未識別. [LGPLv3](../../licenses/essay-LGPL-3.0.txt) 及[GPLv3](../../LICENSE) 隨附. 原拼音主表不改多音身份; 下表只改essay第二欄.

| 詞 | 原權重 | 修訂權重 |
| --- | ---: | ---: |
| 偏微分方程 | 526 | 2104 |
| 分岔 | 571 | 2284 |
| 參數 | 14111 | 56444 |
| 存在性 | 273 | 1092 |
| 定理 | 3986 | 15944 |
| 局部極小值 | 26 | 104 |
| 接口 | 10415 | 41660 |
| 泛函分析 | 537 | 2148 |
| 測試 | 36183 | 144732 |
| 線程 | 2128 | 8512 |
| 編譯器 | 2100 | 8400 |
| 臨界點 | 1045 | 4180 |
| 變分法 | 423 | 1692 |
| 路徑 | 10692 | 42768 |
| 進程 | 6446 | 25784 |
| 遞歸 | 850 | 3400 |
| 邊值問題 | 12 | 48 |

來源修訂使用絕對前後值, 不對已修改詞頻再乘四. 後續另有[緩存權重與重複列修訂](dictionary-quality-q121-sources.md).
