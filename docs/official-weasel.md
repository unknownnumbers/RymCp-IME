# 官方 Weasel 方案

此方案使用官方 Weasel 及其附帶引擎, 提供中文、智能英文、組句與本地學習. 新裝預設 SC 輸出, 保留 TC/SC 切換, 固定直排 6 項及非內嵌組字.

## 新裝

下載官方方案 ZIP. 將 `FreshUserProfile/` 中的檔案放入專用的用戶資料夾, 使用官方前端重新部署並選擇 `pc_research`.

## 已有配置

`payload/` 為方案檔案, `samples/` 為新裝範例. 先備份同名配置. 合併範例中的方案清單、Lua 入口及外觀設定, 保留既有其他方案與用戶詞庫. 不直接以範例覆蓋整個用戶資料夾.

若已有 `default.custom.yaml`、`weasel.custom.yaml` 或 `rime.lua`, 對照範例合併其內容, 再重新部署. 編譯結果及既有學習資料由本機 Rime 管理.

## 可選詞彙

將需要的 `math`、`physics`、`computer` 或 `poetry` 模組資料夾複製到用戶資料夾的 `rymcp_dlc/` 下, 再重新部署. 詳見 [DLC 來源](dlc-sources.md).

日語、查字工具、固定混合詞與動態布局由墨芯完整方案提供. [完整方案](PC.md) | [構建](BUILD.md) | [授權](../THIRD_PARTY_NOTICES.md)
