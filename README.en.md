# RymCp IME

[English (en)](README.en.md) | [Traditional Chinese (zh-TC)](README.md) | [Simplified Chinese (zh-SC)](README.zh-SC.md)

**Recall Your Mother-Tongue Chinese Pronunciation IME**  
**鄉音復健輸入法 | 乡音复健输入法**

> This project is created through human-AI collaboration. Some AI-proposed content may not yet have been reviewed by a human. Please excuse any errors or omissions.

RymCp aims to make everyday typing a way to become familiar with one's home speech again. We are first publishing the Rime PC base: configuration, Lua, required data, source for native modifications and build entry points. Relearning features will be added gradually.

## Existing features

The initial release provides Windows PC source and configuration. A standalone installer will follow later.

| Area | Content |
| --- | --- |
| Chinese input | Pinyin, abbreviated Pinyin, error-tolerant candidates, remaining input after candidate selection and native learning integration |
| English (en) input | Smart English, completion and correction, case handling, fixed mixed-language phrases and learning integration |
| Output forms and candidate UI | Traditional Chinese (zh-TC) / Simplified Chinese (zh-SC) output switching, word-form corrections and Chinese/English candidate layouts |
| Japanese input | Hiragana, katakana, kanji and q/x/v lookup |
| Character lookup and tools | Component/stroke lookup, Mandarin pronunciation display, Unicode, Greek/mathematical symbols and a calculator |
| Native modifications | Fixed upstream versions and complete patches for the Weasel frontend, librime and librime-lua |

The configuration uses the accompanying frontend and engine interfaces. See the [PC guide](docs/PC.md), [Japanese guide](config/pc/JAPANESE.md) and [build guide](docs/BUILD.md).

## The idea behind relearning home speech

Some people are comfortable with Mandarin, Hanyu Pinyin, Zhuyin or Wubi, but no longer remember how words are pronounced in their home speech. This project aims to organize spelling rules, IPA and character/word readings for local speech varieties, so that users can:

1. Type in a familiar way while seeing the spelling and IPA of their chosen home speech.
2. Become familiar with it through repeated exposure to words and reading correspondences during everyday typing.
3. Switch modes once familiar and try typing directly with its spelling system.
4. Later use pronunciation and correction references for individual characters and words, followed by research into sound changes in connected speech.

The first goal is to rebuild reading and writing familiarity. Cantonese, Wu, Southwestern Mandarin, Hui and Jianghuai Mandarin are among the directions being considered. They will be organized individually by location, variety and available data.

Home-speech hints, direct spelling input and pronunciation references are still planned features. The first variety, hint location, committed text format and switching controls will be decided gradually.

## To do and release order

- [ ] Improve public builds, isolated validation, usage documentation and third-party notices for the PC base.
- [ ] Prepare a standalone installer.
- [ ] Choose the first local variety and organize its spelling, IPA and character/word readings.
- [ ] Add home-speech hints and direct spelling input.
- [ ] Add pronunciation and correction references, with audio quality and licensing records.
- [ ] Study connected tone changes, weakening of initial consonants and connected-speech habits.
- [ ] Gradually organize Android support and other local speech varieties.

See [TODO](TODO.md) for detailed progress.

## Directories and sources

| Location | Content |
| --- | --- |
| [config/pc](config/pc) | Shared configuration, Lua, dictionaries and required resources |
| [native](native) | Fixed native upstream versions, complete patches and build methods |
| [scripts](scripts) | Source assembly, data generation and verification tools |
| [docs/sources](docs/sources) | Data provenance, modifications and version information |
| [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) | Third-party attribution and licensing |

The early Japanese input design drew inspiration from [Selaube's Japanese scheme](https://github.com/Selaube/rime-jp_sela).

The public content consists of shared code and data. Personal learning databases, backups and field records remain local.

Code is licensed under [GPLv3](LICENSE). Original text in the newly written README, TODO, PC usage and build documentation is licensed under [CC BY-SA 4.0](licenses/CC-BY-SA-4.0.txt). Third-party code, dictionaries, models and quoted source text retain their own licenses. See the third-party notices for details.
