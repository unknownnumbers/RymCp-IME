# RymCp IME

[English (en)](README.en.md) | [Traditional Chinese (zh-TC)](README.md) | [Simplified Chinese (zh-SC)](README.zh-SC.md)

**Recall Your Mother-Tongue Chinese Pronunciation IME**  
**鄉音復健輸入法 | 乡音复健输入法**

> 本项目由人类与 AI 协作产生. 部分 AI 提出的内容可能尚未经人工审核. 若有错误或疏漏, 敬请见谅.

RymCp 希望把日常打字变成重新熟悉乡音的入口. 现在先公开 Rime PC 底座的配置、Lua、必要资料、原生修改源码与构建入口, 之后逐步接入复健功能.

## 现有功能

首批提供 Windows PC 的源码与配置. 独立安装包留待后续整理.

| 范围 | 内容 |
| --- | --- |
| 中文输入 | 拼音、简拼、容错候选、选词余码及原生学习整合 |
| English (en) 输入 | 智能英文、补全与纠错、大小写处理、固定混合词及学习整合 |
| 字形与候选界面 | Traditional Chinese (zh-TC) / Simplified Chinese (zh-SC) 输出切换、词形修正、中文与英文候选布局 |
| 日语输入 | 平假名、片假名、汉字及 q/x/v 查询 |
| 查字与工具 | 拆字/笔画查字、国语读音显示、Unicode、Greek/数学符号及计算器 |
| 原生修改 | Weasel 前端、librime 及 librime-lua 的固定上游与完整补丁 |

配置使用配套的前端与引擎接口. 使用方式见 [PC 说明](docs/PC.md)、[日语说明](config/pc/JAPANESE.md) 及[构建说明](docs/BUILD.md).

目前原生组合为 61047 TSF、61042 x64 Server、61020 IME 及 N01 x64 运行时引擎; R5 x64/x86 用作前端构建 SDK. 61047 修正按键接管判断: Test 回调取得引擎的实际处理结果, 配对的 Actual 回调确认已完成的处理, 避免重发按键或重复写入. 本次仍只提供源码与配置, 公开验证进度见[构建说明](native/BUILD.md).

## 乡音复健的理念

有人已熟练使用国语、汉语拼音、注音或五笔, 却不再记得家乡话怎么读. 本项目希望整理各地方话的拼写规则、IPA 与字词读音, 让使用者:

1. 先用自己熟悉的方式打字, 同时看到所选乡音的拼写与 IPA.
2. 在日常输入中反复接触字词与读音对照, 逐渐熟悉乡音.
3. 熟悉后切换模式, 尝试直接以乡音拼写输入.
4. 后续加入单字、词语的发音与正音参考, 再研究连读中的音变.

首要目标是读写上的复健. 粤语、吴语、西南官话、徽语、江淮官话等是考虑方向, 会按具体地点、变体与资料逐项整理.

乡音提示、乡音拼写输入及发音参考仍在规划中. 首个变体、提示位置、上屏格式与切换方式会逐步确定.

## 待办与发布顺序

- [ ] 完善 PC 底座的公开构建、隔离验证、使用说明及第三方通知.
- [ ] 整理独立安装包.
- [ ] 选定首个地方变体, 整理拼写、IPA 与字词读音.
- [ ] 接入乡音提示及乡音拼写输入.
- [ ] 补充字词发音与正音参考, 整理音源品质及授权.
- [ ] 研究连续变调、声母弱化及连读习惯.
- [ ] 逐步整理 Android 及其他地方话.

详细进度见 [TODO](TODO.md).

## 目录与来源

| 位置 | 内容 |
| --- | --- |
| [config/pc](config/pc) | 共享配置、Lua、词表与必要资源 |
| [native](native) | 固定原生上游、完整补丁与构建方法 |
| [scripts](scripts) | 源码组装、资料生成及检查工具 |
| [docs/sources](docs/sources) | 资料出处、修改与版本信息 |
| [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) | 第三方署名与授权 |

早期日语输入设计借鉴了 [Selaube 的日语方案](https://github.com/Selaube/rime-jp_sela).

公开内容为共享程序与资料. 个人学习库、备份与现场记录留在本机.

本工程原创代码与配置采用 [GPL-3.0-only](LICENSE), 各说明文件中的原创文字采用 [CC BY-SA 4.0](licenses/CC-BY-SA-4.0.txt). 第三方材料与引用原文保留各自授权, 详见[第三方通知](THIRD_PARTY_NOTICES.md)及[逐文件授权索引](licenses/file-licenses.json).
