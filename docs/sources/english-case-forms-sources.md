# 英文大小寫佐證

小表只處理既有核心詞與擴展詞的大小寫碰撞, 不替換英文詞頻庫或任意增加詞彙.

普通小寫形式的正面佐證來自[SCOWL2020.12.07](https://sourceforge.net/projects/wordlist/files/SCOWL/2020.12.07/scowl-2020.12.07.tar.gz/download) 的`final/english-words.*`、`american-words.*`及`british-words.*`, 累計sizes至80, 保留原大小寫. 只有確切小寫會員關係才為既有規範擴展另外登記普通形式; 缺少佐證代表未知, 不表示該拼寫在語言上無效.

完整release的[SCOWL Copyright](../../licenses/SCOWL-case-forms-Copyright.txt) 隨附. 這個明確的2020.12.07版本與[英文核心](english-core-sources.md) 成品所用、但版本未知的SCOWL分開記錄.

規範擴展來自Ice固定`da1fbe602e38f26db846fa10120ee64c2b0324c0`, 見[擴展通知](english-extensions-sources.md). 本工程規則為確切普通形式優先、普通lower/title/upper變換、mixed case須匹配實際規範前綴; 規範品牌保留拼寫, 完整全大寫輸入另依既定顯示政策. 這是顯示/候選身份選擇, 不是新增語言學斷言.
