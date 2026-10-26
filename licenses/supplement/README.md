# 補充授權與署名通知

2026-10-26. 這個目錄只保存公開整理需要的授權正文、署名文件及完整法律通知摘錄; 沒有複製上游整份碼表或程式實作. 18份通知的來源URL、所見固定commit、原Git blob、保存檔案的SHA256及檔案大小, 均記於 [集中來源manifest](../third-party-source-manifest.json).

## Mirtle 拆字資料的通知鏈

本工程使用的直接來源固定為 `mirtlecn/rime-radical-pinyin@87e73d7182916f3db9dbc0b6a4d18a78a775b298`. 其 `src/README.md` 以GPLv3發布, 並明列kfcd、CHISE、yi-bai來源及henrysting補充; 本目錄保存該檔及根GPLv3正文.

| 來源 | 本輪核對通知的固定版本 | 所見授權/署名 | 保存檔案 |
| --- | --- | --- | --- |
| kfcd/chaizi | `e177ab54ce4edf255315a60593ffecbd8167e96b` | CC BY 3.0; README ©2015 開放詞典 | `kfcd-chaizi-LICENSE.txt`、`kfcd-chaizi-README.md`、`CC-BY-3.0-legalcode.txt` |
| henrysting/chaizi | `c751e804f35e2039e6bbb2456055ab3fa8737f7d` | fork的LICENSE與kfcd完全同一Git blob; README ©2022 開放詞典 | `henrysting-chaizi-LICENSE.txt`、`henrysting-chaizi-README.md` |
| yi-bai/ids | `da1e9f8a09e2ec8faaf176bac99203f978282041` | MIT; Copyright (c) 2021 Yi Bai | `yi-bai-ids-LICENSE.txt`、`yi-bai-ids-README.md` |
| CHISE ids | 維護者GitHub mirror `chise/ids@ac35413635608512f5e10187812cfab3b6ea47c1` | README為GPLv2 or later, 保留IPA支援及C.C. Hsieh/中央研究院CDP來源致謝 | `CHISE-ids-README.md`、`GPL-2.0.txt` |
| CHISE程式署名補充 | 同一mirror commit的`ids.el` | 檔頭Copyright (C) 2001, 2002, 2003, 2005, 2020, 2021 MORIOKA Tomohiko; 此為該程式檔的署名, 不用它推定所有資料的版權範圍 | `CHISE-ids.el-NOTICE.txt`保存完整法律通知檔頭 |

官方原站為[CHISE GitLab](https://gitlab.chise.org/CHISE/ids); 本輪直接存取原站逾時後, 以維護者的[GitHub mirror](https://github.com/chise/ids) 取得固定原文, 並以原站搜尋所得README核對GPLv2-or-later及致謝. GPLv2正文取自同一維護者的`xemacs-chise`固定`COPYING`, 其來源明列在manifest.

以上已補齊本輪發現缺少的**通知正文與署名**. 本目錄所見的上游commit不等於Mirtle實際整併資料時採用的commit; Mirtle未給出的精確資料版本與逐行來源仍明列未知, 不用目前版本倒填歷史.

GitHub的LICENSE路徑歷史顯示: kfcd通知自2015初始提交、yi-bai通知自2021初始提交沒有改動; henrysting所見LICENSE與kfcd相同. 這支持本輪保存的授權通知具有延續性, 仍不證明某一資料列的具體整併日期.

本工程拆字變換說明另保留: 只收單Unicode碼點輸出、排除12項多字符單位, 保留原碼與權重; 方案層的逐部件`ing/eng`相容另列為本工程輸入規則. 完整衍生字典與這些通知一起發行時, 保留Mirtle及上述來源, 不把它們改標成RymCp原創資料.

## 原生引擎與插件通知

已與native來源盤點對齊正式workflow所固定的commit:

| 元件 | 固定版本 | 通知 |
| --- | --- | --- |
| librime | `1c23358157934bd6e6d6981f0c0164f05393b497` | `librime-LICENSE.txt`, BSD-3-Clause, ©2014 RIME Developers |
| librime-lua | `e3912a4b3ac2c202d89face3fef3d41eb1d7fcd6` | `librime-lua-LICENSE.txt`, BSD-3-Clause, ©2021 librime-lua Developers |
| librime-octagram | `dfcc15115788c828d9dd7b4bff68067d3ce2ffb8` | `librime-octagram-LICENSE.txt`, GNU GPL version 3 |
| librime-predict | `920bd41ebf6f9bf6855d14fbe80212e54e749791` | `librime-predict-LICENSE.txt`, BSD-3-Clause, ©2023 RIME Developers |
| 內附Lua | librime-lua的thirdparty固定`115e000c878d1170337f7ca934d7a84f68986e39` | `Lua-5.4-MIT-NOTICE.txt`, ©1994-2024 Lua.org/PUC-Rio; 完整摘錄自`lua5.4/lua.h` |
| 同thirdparty樹的Lua5.3 | 同上 | `Lua-5.3-MIT-NOTICE.txt`, ©1994-2018 Lua.org/PUC-Rio; 保存來源樹通知, 沒有宣稱它是實際連結版本 |

固定librime-lua的CMake入口在`thirdparty/lua5.4/lua.h`存在時選擇內附Lua5.4. 這裡已補其MIT通知, 不將插件的BSD授權誤當Lua本體授權.

此表覆蓋直接引擎/插件及內附Lua通知. Boost、librime的glog/leveldb/yaml-cpp/marisa/OpenCC等構建依賴, 仍應隨實際公開構建及日後二進位發行保留其固定來源與通知; 本目錄不宣稱已獨立完成所有間接元件審計.

## 保存完整性

14份完整上游檔案的本地Git blob (`git hash-object --no-filters`) 已與固定來源API的blob相同. 3份法律通知是完整摘錄, manifest分別記錄來源整檔的blob及摘錄檔SHA256; 另1份CC BY3.0完整正文從先前保存的官方正文原樣複製. 原授權與署名文字均未改寫或改授權.
