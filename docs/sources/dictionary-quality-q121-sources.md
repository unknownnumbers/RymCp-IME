# Luna方案、主表與中文品質修訂

`config/pc/luna_pinyin.dict.yaml`來自官方Weasel0.17.4資料的Luna字典, 原版本`2024.02.10`, 本工程版本`2024.02.10.q121.20261019.1`. 精確上游commit未識別; 版本字串中的歷史修訂識別碼原樣保留, 並非另作來源版本推定.

字典原頭保留Rime Developers及CC-CEDICT、AOSP PinyinIME、Chewing、三拼簡繁詞庫、OpenCC、萌典來源. 上游為[rime/rime-luna-pinyin](https://github.com/rime/rime-luna-pinyin), [LGPLv3正文](../../licenses/luna-pinyin-LGPL-3.0.txt) 及其引用的[GPLv3](../../LICENSE) 隨包提供.

`config/pc/pc_research.schema.yaml`沿用Luna方案基底, 保留佛振署名及原來源說明, 並加入本工程的配置整合. Luna原有部分保留上游LGPLv3條款, 本工程新增配置採GPL-3.0-only. 方案的精確上游commit未識別, 逐檔範圍見[授權索引](../../licenses/file-licenses.json).

## 明列的詞碼修訂

| 詞 | 原碼 | 修訂碼 |
| --- | --- | --- |
| 邏輯閘 | `luo ji jia` | `luo ji zha` |
| 行車距離 | `xing che che li` | `xing che ju li` |
| 國有財產 | `guo you cai can` | `guo you cai chan` |
| 家蠶 | `jia chan` | `jia can` |
| 腸肥腦滿 | `chang fei man nao` | `chang fei nao man` |
| 跨媒體合作 | `ka mei ti he zuo` | `kua mei ti he zuo` |
| 中山高速公路 | `zhong shan gao shu gong lu` | `zhong shan gao su gong lu` |
| 禁制令 | `jin zhi lin` | `jin zhi ling` |

行車距離原已有完全相同正碼行, 因此只移除錯碼, 不再增加重複正碼. 其餘七項原位修正. 字典仍保留標準`ing/eng`拼寫; 輸入層相容規則不改字典的標準音節.

讀音核對使用教育部《重編國語辭典修訂本》的對應詞條, 例如[邏輯閘](https://dict.revised.moe.edu.tw/dictView.jsp?ID=66521&la=0&powerMode=0)、[行車距離](https://dict.revised.moe.edu.tw/dictView.jsp?ID=110930&la=0&powerMode=0)、[國有財產](https://dict.revised.moe.edu.tw/dictView.jsp?ID=72390&la=0&powerMode=0)、[家蠶](https://dict.revised.moe.edu.tw/dictView.jsp?ID=89458&la=0&powerMode=0)、[腸肥腦滿](https://dict.revised.moe.edu.tw/dictView.jsp?ID=123933&la=0&powerMode=0)、[跨媒體合作](https://dict.revised.moe.edu.tw/dictView.jsp?ID=78006&la=0&powerMode=0)、[中山高速公路](https://dict.revised.moe.edu.tw/dictView.jsp?ID=120037&la=0&powerMode=0)、[禁制令](https://dict.revised.moe.edu.tw/dictView.jsp?ID=94903&la=0&powerMode=0). 只用作詞碼核對, 沒有抽取辭典釋義.

## essay與專業小表

`essay.txt`另有17項初始權重修訂, 見[PDE來源](pde-terms-sources.md). 之後只移除軟麪筋權重0的重複列、保留權重66, 並將緩存4183改為16732. `project_pde_terms.dict.yaml`的多解性/弱解/緊性由400改為1600, 其餘15詞保持400. 這些是初始排序參數, 不是私人學習次數; 重建不能重複倍乘已修訂值.
