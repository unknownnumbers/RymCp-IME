# 授權範圍與第三方通知

RymCp IME由本工程程式、Rime前端/引擎、插件及多種資料組成. 本工程原創程式碼、配置、資料生成器、測試及原生修改採[GPL-3.0-only](LICENSE). 第三方材料及其原有部分保留原授權、版權與署名, 逐檔範圍見[授權索引](licenses/file-licenses.json).

各說明文件中的本工程原創文字採[CC BY-SA 4.0](licenses/CC-BY-SA-4.0.txt), 包括README、使用與構建說明、來源整理及設計文件. 第三方文件、授權通知、來源引文與程式片段保留各自條款. 構建與資料生成腳本依程式碼授權提供, 生成資料保留所用來源的授權與署名; 本工程新增部分的範圍見逐檔索引.

| 元件/材料 | 原授權及署名 | 隨附通知與來源 |
| --- | --- | --- |
| Weasel前端及衍生修改 | GNU GPLv3; Rime及原貢獻者 | [GPLv3](LICENSE)、[固定來源與修改入口](docs/sources/native-components.md); 原檔署名保留 |
| librime | BSD-3-Clause; ©2014 RIME Developers | [固定正文](licenses/supplement/librime-LICENSE.txt) |
| librime-lua | BSD-3-Clause; ©2021 librime-lua Developers | [固定正文](licenses/supplement/librime-lua-LICENSE.txt) |
| librime-octagram | GNU GPLv3 | [固定正文](licenses/supplement/librime-octagram-LICENSE.txt) |
| librime-predict | BSD-3-Clause; ©2023 RIME Developers | [固定正文](licenses/supplement/librime-predict-LICENSE.txt) |
| 內附Lua5.4 | MIT; ©1994-2024 Lua.org、PUC-Rio | [完整通知](licenses/supplement/Lua-5.4-MIT-NOTICE.txt); 同源樹另附[Lua5.3通知](licenses/supplement/Lua-5.3-MIT-NOTICE.txt), 不表示兩版均連結 |
| Luna方案與字典、essay、TC compact模型 | GNU LGPLv3及原作者/來源 | [Luna](licenses/luna-pinyin-LGPL-3.0.txt)、[essay](licenses/essay-LGPL-3.0.txt)、[模型](licenses/luna-compact-model-LGPL-3.0.txt), 均連同[GPLv3](LICENSE); [Luna來源與修改](docs/sources/dictionary-quality-q121-sources.md)、[來源索引](docs/sources/README.md) |
| 英文核心 | SymSpell MIT; 底層Google Books Ngram CC BY3.0及SCOWL複合來源通知 | [英文核心來源](docs/sources/english-core-sources.md)、[完整通知目錄](licenses/english-core/); 不能只以SymSpell MIT概括資料 |
| 英文大小寫佐證 | SCOWL 2020.12.07及其上游複合來源 | [完整Copyright](licenses/SCOWL-case-forms-Copyright.txt)、[實際用途](docs/sources/english-case-forms-sources.md) |
| Ice英文擴展、混合詞及工具參考 | GPLv3; iDvel/rime-ice貢獻者; 計算器ChaosAlphard/DeepChirp, 取字BlindingDark | [Ice GPL](licenses/english-extensions-Ice-GPL-3.0.txt)、[工具GPL](licenses/tools-Ice-GPL-3.0.txt)、[來源索引](docs/sources/README.md) |
| Mirtle拆字及其上游 | Mirtle GPLv3; kfcd/henrysting CC BY3.0、CHISE GPLv2-or-later、Yi Bai MIT | [來源與變換](docs/sources/radical-stroke-sources.md)、[完整原credits](licenses/radical-stroke/radical-source-credits.md)、[補充通知](licenses/supplement/README.md) |
| 筆畫查詢 | rime-stroke LGPLv3及CNS11643等原來源 | [LGPL](licenses/radical-stroke/stroke-LGPL-3.0.txt)、[AUTHORS](licenses/radical-stroke/stroke-AUTHORS)、[實際1.1來源](docs/sources/query-strokes-source.json) |
| Unicode/Unihan17.0.0 | Unicode License V3; Unicode, Inc. | [正文](licenses/Unicode-3.0.txt)、[讀音變換](docs/sources/u-readings-sources.md) |
| OpenCC字形/轉換資料 | Apache-2.0; OpenCC原作者 | [正文](licenses/OpenCC-LICENSE.txt)、[日語資料用途](docs/sources/jp-v-sources.md) |
| JMdict/KANJIDIC2衍生字典 | CC BY-SA4.0; Electronic Dictionary Research and Development Group與James William Breen | [EDRDG聲明](licenses/EDRDG-licence.html)、[CC正文](licenses/CC-BY-SA-4.0.txt)、[JMdict文件](licenses/JMdict-EDICT_Dictionary_Project.html)、[KANJIDIC文件](licenses/KANJIDIC_Project.html)、[q](docs/sources/jp-q-sources.md)/[v](docs/sources/jp-v-sources.md) 來源 |
| 數學/PDE精選資料 | 白霜借入部分GPLv3; 本工程自編詞/權重另列 | [三詞表](docs/sources/project-terms-sources.md)、[PDE表](docs/sources/pde-terms-sources.md)、[英文PDE](docs/sources/english-pde-sources.md) |

This package uses the JMdict and KANJIDIC2 dictionary files. These files are the property of the Electronic Dictionary Research and Development Group (EDRDG) and James William Breen, and are used in conformance with the Group's licence. Derived EDRDG dictionary data is distributed under CC BY-SA 4.0. Unicode and OpenCC portions retain their respective licences.

公開版日語假名基底由本工程按自身需求獨立生成, 程式/配置依GPLv3提供. 早期設計借鑑Selaube方案並保留感謝, 現行假名/漢字/q/x/v不以兼容原方案為目標; 沒有把原兩份schema/碼表正文整檔打包. 目前使用的模組識別碼`jp_sela`不表示原表被重新授權. [具體邊界](docs/sources/jp-q-sources.md).

字形修正只包含明列的小型程式規則與四條詞形映射; 來源說明保留其本地MDX參考背景, 不包含MDX整庫、釋義全文或研究抽取材料, 也不對外部詞典本體作GPL再授權. [範圍](docs/sources/mdx-orthography-sources.md).

版本未知之處在[公開來源索引](docs/sources/README.md) 逐項列明. 固定上游成品與本工程格式/索引的再建, 不代表已從全部原始語料重現其上游製法. 未隨倉庫提供的依賴仍按其原授權取得與使用.
