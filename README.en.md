# RymCp IME

Recall Your Mother-Tongue Chinese Pronunciations IME

> This project is created through human-AI collaboration. Some AI-proposed content may not yet have been reviewed by a human. Please excuse any errors or omissions.

[English (en)](README.en.md) | [Traditional Chinese (zh-TC)](README.md) | [Simplified Chinese (zh-SC)](README.zh-SC.md)

RymCp provides Chinese and smart English Rime schemes, with a foundation for future work on recalling mother-tongue pronunciations.

## Available features

- Chinese full spelling, abbreviations, existing correction rules, composition and local learning, with TC/SC output switching. Use `"` to lock the spelling and boundary of a complete syllable.
- Smart English words, completion, correction, case handling and existing acronym expansions.
- The Stellae profile also provides hiragana, katakana, kanji, romaji and q/x/v queries, fixed mixed phrases, character lookup and calculation tools.
- The official Weasel profile provides Chinese and smart English with six vertical candidates and non-inline composition.
- The default uses general vocabulary. Separate DLC modules provide broad math and physics vocabulary, computing terms, and the complete Tang poetry, Song poetry and Song ci collections in the pinned source snapshot, together with companion anthologies.

A fresh Stellae profile defaults to SC output, five horizontal Chinese candidates and six vertical smart English candidates. Existing user learning and customization remain part of the normal profile workflow.

## Installation

- [Stellae frontend and scheme installer](https://github.com/unknownnumbers/rime-stellae/releases).
- [Official Weasel scheme ZIP](https://github.com/unknownnumbers/RymCp-IME/releases).
- [Stellae profile guide](docs/PC.md), [official profile installation and merging](docs/official-weasel.md), and [DLC sources](docs/dlc-sources.md).

Scheme sources are in [config/pc](config/pc) and [config/official-weasel](config/official-weasel). Back up matching configuration files before merging into an existing user directory, and retain user dictionaries.

The 2026.11.14.2 poetry DLC requires scheme base 2026.11.14.2 or later. Catalogs are generated from the repository's fixed source inputs and build scripts; module ZIPs are available in Releases. Readings and text variants use automated processing with bounded checks and have not been reviewed line by line. See [DLC sources and limitations](docs/dlc-sources.md).

## Mother-tongue pronunciation work

The project aims to help people recall and organize their mother-tongue pronunciations through everyday input. The current delivery is the input-method foundation. Rehabilitation workflows, audio resources and their interfaces remain planned work.

## Development and planned work

[Build](docs/BUILD.md) | [Sources and reconstruction scope](docs/sources/README.md) | [TODO](TODO.md)

Original code and configuration use GPL-3.0-only. Original explanatory prose uses CC BY-SA 4.0. Third-party data and notices retain their own terms; see the [license index](THIRD_PARTY_NOTICES.md).
