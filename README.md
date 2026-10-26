# RymCp IME

[English (en)](README.en.md) | [Traditional Chinese (zh-TC)](README.md) | [Simplified Chinese (zh-SC)](README.zh-SC.md)

**Recall Your Mother-Tongue Chinese Pronunciation IME**  
**鄉音復健輸入法 | 乡音复健输入法**

> 本專案由人類與 AI 協作產生. 部分 AI 提出的內容可能尚未經人工審核. 若有錯誤或疏漏, 敬請見諒.

RymCp 希望把日常打字變成重新熟悉鄉音的入口. 現在先公開 Rime PC 底座的配置、Lua、必要資料、原生修改源碼與構建入口, 之後逐步接入復健功能.

## 現有功能

首批提供 Windows PC 的源碼與配置. 獨立安裝包留待後續整理.

| 範圍 | 內容 |
| --- | --- |
| 中文輸入 | 拼音、簡拼、容錯候選、選詞餘碼及原生學習整合 |
| English (en) 輸入 | 智能英文、補全與糾錯、大小寫處理、固定混合詞及學習整合 |
| 字形與候選介面 | Traditional Chinese (zh-TC) / Simplified Chinese (zh-SC) 輸出切換、詞形修正、中文與英文候選布局 |
| 日語輸入 | 平假名、片假名、漢字及 q/x/v 查詢 |
| 查字與工具 | 拆字/筆畫查字、國語讀音顯示、Unicode、Greek/數學符號及計算器 |
| 原生修改 | Weasel 前端、librime 及 librime-lua 的固定上游與完整補丁 |

配置使用配套的前端與引擎介面. 使用方式見 [PC 說明](docs/PC.md)、[日語說明](config/pc/JAPANESE.md)及[構建說明](docs/BUILD.md). 介面語言與輸出字形分開處理.

## 鄉音復健的理念

有人已熟練使用國語、漢語拼音、注音或五筆, 卻不再記得家鄉話怎麼讀. 本專案希望整理各地方話的拼寫規則、IPA 與字詞讀音, 讓使用者:

1. 先用自己熟悉的方式打字, 同時看到所選鄉音的拼寫與 IPA.
2. 在日常輸入中反覆接觸字詞與讀音對照, 逐漸熟悉鄉音.
3. 熟悉後切換模式, 嘗試直接以鄉音拼寫輸入.
4. 後續加入單字、詞語的發音與正音參考, 再研究連讀中的音變.

首要目標是讀寫上的復健. 粵語、吳語、西南官話、徽語、江淮官話等是考慮方向, 會按具體地點、變體與資料逐項整理.

鄉音提示、鄉音拼寫輸入及發音參考仍在規劃中. 首個變體、提示位置、上屏格式與切換方式會逐步確定.

## 待辦與發布順序

- [ ] 完善 PC 底座的公開構建、隔離驗證、使用說明及第三方通知.
- [ ] 整理獨立安裝包.
- [ ] 選定首個地方變體, 整理拼寫、IPA 與字詞讀音.
- [ ] 接入鄉音提示及鄉音拼寫輸入.
- [ ] 補充字詞發音與正音參考, 整理音源品質及授權.
- [ ] 研究連續變調、聲母弱化及連讀習慣.
- [ ] 逐步整理 Android 及其他地方話.

詳細進度見 [TODO](TODO.md).

## 目錄與來源

| 位置 | 內容 |
| --- | --- |
| [config/pc](config/pc) | 共享配置、Lua、詞表與必要資源 |
| [native](native) | 固定原生上游、完整補丁與構建方法 |
| [scripts](scripts) | 源碼組裝、資料生成及檢查工具 |
| [docs/sources](docs/sources) | 資料出處、修改與版本資訊 |
| [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) | 第三方署名與授權 |

早期日語輸入設計借鑑了 [Selaube 的日語方案](https://github.com/Selaube/rime-jp_sela).

公開內容為共享程式與資料. 個人學習庫、備份與現場紀錄留在本機.

程式碼採 [GPLv3](LICENSE). 新寫 README、TODO、PC 使用與構建說明的原創文字採 [CC BY-SA 4.0](licenses/CC-BY-SA-4.0.txt). 第三方程式、詞庫、模型與引用原文保留各自授權, 詳見第三方通知.
