# 英文核心：來源、格式與索引

核心詞頻成品來自Wolf Garbe的SymSpell v6.7.3，固定commit `2ac2df1d01c99711162c4c38a191e522ed4b29c7`的[frequency_dictionary_en_82_765.txt](https://github.com/wolfgarbe/SymSpell/blob/2ac2df1d01c99711162c4c38a191e522ed4b29c7/SymSpell/frequency_dictionary_en_82_765.txt)。檔名中的數字不是實際行數：該成品有82,834條，1,332,881 bytes，UTF-8 BOM。

原始讀取接受`[a-z]+(?:['-][a-z]+)*`，保存正整數原詞頻，不截成32位、不以來源次序代替詞頻排序。基礎格式變換沒有改動原詞或頻數；獨立加`well-known`一條、初始權重1，是本工程選值，並非語料出現次數。後續PDE明列修訂另見[英文PDE](english-pde-sources.md)。字典、vocabulary及其前綴／糾錯索引同源，索引不是第二份私人語料。

SymSpell[固定README](https://github.com/wolfgarbe/SymSpell/blob/2ac2df1d01c99711162c4c38a191e522ed4b29c7/README.md#frequency-dictionary)聲明由Google Books Ngram詞頻與SCOWL取交集，再過濾與截取。程式及資料通知不能合併成單一MIT：

| 來源 | 保存的完整通知 |
| --- | --- |
| SymSpell，©2018 Wolf Garbe，MIT | [MIT](../../licenses/english-core/SymSpell-MIT.txt)、[上游README](../../licenses/english-core/SymSpell-upstream-README.md) |
| Google Books Ngram，CC BY3.0 Unported | [官方資料頁留檔](../../licenses/english-core/Google-Books-Ngram-official.html)、[原用法通知](../../licenses/english-core/Google-Books-CC-BY-3.0-NOTICE.txt)、[完整CC正文](../../licenses/english-core/CC-BY-3.0-legalcode.txt) |
| SCOWL及其WordNet／UKACD／VarCon／Ispell等複合來源 | [官方README留檔](../../licenses/english-core/SCOWL-official-readme.html)、[完整README文字](../../licenses/english-core/SCOWL-full-README.txt)、[完整Copyright／Sources／Credits](../../licenses/english-core/SCOWL-COPYRIGHT-SOURCES-CREDITS.txt) |

UKACD原通知為Copyright (c) J Ross Beresford 1993-1999，完整原文已保留在SCOWL credits，並非以摘要代替。Google Books來源經SymSpell處理、本工程再格式化及作明列修訂，不表示Google或上述來源背書。

所見SCOWL通知版本為2024-07-22，不能據此聲稱SymSpell成品採用了該版本。Google Books精確版本／切片、SCOWL精確版本／選項及完整過濾程序仍未知。固定成品及本工程格式／索引的再建，不等於從全部原始上游語料重現。
