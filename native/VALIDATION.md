# 首次公開來源的驗證範圍

2026-10-26. 以下是發布準備時實際完成的本地唯讀檢查; 不是新公開Actions的成功紀錄.

- 六份完整patch的SHA256與`source-manifest.json`一致, Git可解析各份diff.
- 七份PowerShell檔 (六個腳本及Shift測例runner) 全部通過PowerShell語法解析.
- `weasel-61033`與`weasel-61020`在固定官方原始樹的唯讀`git apply --check`通過; Windows來源壓縮包只有一項檔案mode提示, 沒有內容衝突.
- `engine-r5`與`engine-n01`的core/Lua patch, 對從固定官方提交URL取得的原始碼壓縮包唯讀套用檢查通過.
- workflow與腳本未引用維護者私人倉庫、歷史Actions artifact或個人絕對路徑.

壓縮包檢查只證明patch上下文匹配, 沒有驗證Git checkout身份或submodule組裝. 新公開workflow的網路來源組裝仍須實跑確認; 編譯、helper34、Shift36、上游CTest和完整產品/真應用輸入測試也沒有在本輪本地執行. Actions的`compile=false`只核對來源組裝; `compile=true`才啟動編譯及本倉庫明列的受控測例.

所有結果應以檢查範圍單獨表達. 過去日用構建成功不等於這份新公開workflow已成功; 來源公開也不等於提供了可直接安裝的二進位發行包.

本文採CC BY-SA4.0; 第三方原始碼和通知的授權不因此改變.
