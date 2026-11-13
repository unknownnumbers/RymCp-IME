# RymCp IME

Recall Your Mother-Tongue Chinese Pronunciations IME

> 本專案由人類與 AI 協作產生. 部分 AI 提出的內容可能尚未經人工審核. 若有錯誤或疏漏, 敬請見諒.

[English (en)](README.en.md) | [Traditional Chinese (zh-TC)](README.md) | [Simplified Chinese (zh-SC)](README.zh-SC.md)

RymCp 提供 Rime 中文及智能英文方案, 並為鄉音復健的後續工作建立輸入底座.

## 現有功能

- 中文全拼、縮寫、既有容錯、組句及本地學習, 支援 TC/SC 輸出切換. 使用 `"` 固定完整音節的拼寫及邊界.
- 智能英文的完整詞、補全、容錯、大小寫與既有縮寫展開.
- 墨芯完整方案另提供平假名、片假名、漢字、romaji 及 q/x/v 查詢模式, 固定混合詞、查字與計算工具.
- 官方 Weasel 方案提供中文及智能英文, 固定直排 6 項、非內嵌.
- 預設使用通用詞庫. 數學、物理、電腦及詩詞詞彙可透過獨立 DLC 安裝.

墨芯完整方案新裝預設 SC 輸出, 中文橫排 5 項、智能英文直排 6 項. 兩套方案保留既有學習及自訂配置的使用方式.

## 安裝

- [墨芯前端與方案安裝器](https://github.com/unknownnumbers/rime-stellae/releases).
- [官方 Weasel 方案 ZIP](https://github.com/unknownnumbers/RymCp-IME/releases).
- [完整方案使用說明](docs/PC.md)、[官方方案安裝及合併](docs/official-weasel.md)、[DLC 來源](docs/dlc-sources.md).

方案源碼分別位於 [config/pc](config/pc) 與 [config/official-weasel](config/official-weasel). 安裝到已有資料夾時, 先備份同名配置並依說明合併, 保留用戶詞庫.

## 鄉音復健

本專案希望讓使用者透過日常輸入, 逐步找回與整理自己的母語發音及鄉音. 目前交付輸入法底座, 復健流程、音訊資料及相關介面仍在待辦中.

## 開發與待辦

[構建說明](docs/BUILD.md) | [來源及再建範圍](docs/sources/README.md) | [待辦](TODO.md)

原創程式與配置採 GPL-3.0-only, 原創說明文字採 CC BY-SA 4.0. 第三方資料及原通知保留各自授權, 見 [授權索引](THIRD_PARTY_NOTICES.md).
