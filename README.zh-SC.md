# RymCp IME

Recall Your Mother-Tongue Chinese Pronunciations IME

> 本项目由人类与 AI 协作产生. 部分 AI 提出的内容可能尚未经人工审核. 若有错误或疏漏, 敬请见谅.

[English (en)](README.en.md) | [Traditional Chinese (zh-TC)](README.md) | [Simplified Chinese (zh-SC)](README.zh-SC.md)

RymCp 提供 Rime 中文及智能英文方案, 并为乡音复健的后续工作建立输入底座.

## 现有功能

- 中文全拼、缩写、既有容错、组句及本地学习, 支持 TC/SC 输出切换. 使用 `"` 固定完整音节的拼写及边界.
- 智能英文的完整词、补全、容错、大小写与既有缩写展开.
- 墨芯完整方案另提供平假名、片假名、汉字、romaji 及 q/x/v 查询模式, 固定混合词、查字与计算工具.
- 官方 Weasel 方案提供中文及智能英文, 固定直排 6 项、非内嵌.
- 默认使用通用词库. 数学、物理、电脑及诗词词汇可通过独立 DLC 安装. 数学及物理包涵盖广泛学科词汇, 诗词包收录固定来源的全量唐诗、宋诗、宋词及配套选集.

墨芯完整方案新装默认 SC 输出, 中文横排 5 项、智能英文直排 6 项. 两套方案保留既有学习及自定义配置的使用方式.

## 安装

- [墨芯前端与方案安装器](https://github.com/unknownnumbers/rime-stellae/releases).
- [官方 Weasel 方案 ZIP](https://github.com/unknownnumbers/RymCp-IME/releases).
- [完整方案使用说明](docs/PC.md)、[官方方案安装及合并](docs/official-weasel.md)、[DLC 来源](docs/dlc-sources.md).

方案源码分别位于 [config/pc](config/pc) 与 [config/official-weasel](config/official-weasel). 安装到已有资料夹时, 先备份同名配置并依说明合并, 保留用户词库.

2026.11.14.2 诗词 DLC 需要 2026.11.14.2 或更新的方案基座. 词表由仓库中的固定来源及构建程序生成, 可直接下载 Release 的模块 ZIP. 读音与异文采用自动处理及有限校核, 尚未逐句审校, 详见 [DLC 来源与限制](docs/dlc-sources.md).

## 乡音复健

本项目希望让使用者通过日常输入, 逐步找回与整理自己的母语发音及乡音. 目前交付输入法底座, 复健流程、音讯资料及相关界面仍在待办中.

## 开发与待办

[构建说明](docs/BUILD.md) | [来源及重建范围](docs/sources/README.md) | [待办](TODO.md)

原创程序与配置采用 GPL-3.0-only, 原创说明文字采用 CC BY-SA 4.0. 第三方数据及原通知保留各自授权, 见 [授权索引](THIRD_PARTY_NOTICES.md).
