#!/usr/bin/env python3
"""Build a public PC configuration from an explicit source allowlist.

GPL-3.0-only. Copyright 2026 RymCp contributors.
The destination must be absent. No deployment, overwrite, recursive copy,
network access, personal database read or source-directory mutation occurs.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path

ALLOWLIST = (
    "default.custom.yaml",
    "english_extensions.dict.yaml",
    "english_extensions/build-report.json",
    "english_extensions/case_forms.tsv",
    "english_extensions/entries.tsv",
    "english_extensions/keys.bin",
    "english_extensions/postings.bin",
    "english_extensions/words.txt",
    "english_frequency_overrides.tsv",
    "english_full.dict.yaml",
    "english_full.schema.yaml",
    "english_index/build-report.json",
    "english_index/keys.bin",
    "english_index/postings.bin",
    "english_index/vocabulary.tsv",
    "english_index/words.txt",
    "essay.txt",
    "frequency_overrides.tsv",
    "jp_q_lookup.dict.yaml",
    "jp_q_lookup.schema.yaml",
    "jp_sela.custom.yaml",
    "jp_small_lookup.dict.yaml",
    "jp_small_lookup.schema.yaml",
    "jp_v_lookup.schema.yaml",
    "jp_v_pc_lookup.schema.yaml",
    "jp_v_words.tsv",
    "jp_v.dict.yaml",
    "licenses/CC-BY-SA-4.0.txt",
    "licenses/dictionary-quality-q121-sources.md",
    "licenses/EDRDG-licence.html",
    "licenses/english-case-forms-sources.md",
    "licenses/english-extensions-Ice-GPL-3.0.txt",
    "licenses/english-extensions-sources.md",
    "licenses/english-pde-sources.md",
    "licenses/essay-LGPL-3.0.txt",
    "licenses/JMdict-EDICT_Dictionary_Project.html",
    "licenses/jp-q-sources.md",
    "licenses/jp-v-sources.md",
    "licenses/KANJIDIC_Project.html",
    "licenses/luna-compact-model-LGPL-3.0.txt",
    "licenses/luna-compact-model-sources.md",
    "licenses/luna-pinyin-LGPL-3.0.txt",
    "licenses/mdx-orthography-sources.md",
    "licenses/mixed-phrases-sources.md",
    "licenses/OpenCC-LICENSE.txt",
    "licenses/pde-terms-reference-GPL-3.0.txt",
    "licenses/pde-terms-sources.md",
    "licenses/project-literary-sources.md",
    "licenses/project-terms-reference-LICENSE.txt",
    "licenses/project-terms-sources.md",
    "licenses/query-strokes-source.json",
    "licenses/SCOWL-case-forms-Copyright.txt",
    "licenses/tools-Ice-GPL-3.0.txt",
    "licenses/tools-sources.md",
    "licenses/u-readings-sources.md",
    "licenses/Unicode-3.0.txt",
    "lua/candidate_keys.lua",
    "lua/cn_boundaries.lua",
    "lua/cn_extra_forms.lua",
    "lua/cn_forms.lua",
    "lua/cn_match.lua",
    "lua/cn_native_boundary.lua",
    "lua/cn_neighbor_keys.lua",
    "lua/cn_normal_codec.lua",
    "lua/cn_orthography.lua",
    "lua/cn_preedit_spacing.lua",
    "lua/cn_tolerance.lua",
    "lua/cn_translator.lua",
    "lua/draft_limit.lua",
    "lua/en_index.lua",
    "lua/en_indexed_translator.lua",
    "lua/en_processor.lua",
    "lua/en_segmentor.lua",
    "lua/jp_family_data.lua",
    "lua/jp_family.lua",
    "lua/jp_learning_match.lua",
    "lua/jp_memory.lua",
    "lua/jp_named_symbols.lua",
    "lua/jp_query.lua",
    "lua/jp_reading_metadata.lua",
    "lua/jp_sequence.lua",
    "lua/jp_small_kana.lua",
    "lua/jp_v_chars.lua",
    "lua/jp_v_data.lua",
    "lua/jp_v_words_index.lua",
    "lua/jp_v.lua",
    "lua/mixed_data.lua",
    "lua/mixed_translator.lua",
    "lua/pc_probe_global_mode.lua",
    "lua/pc_probe_greek_proxy.lua",
    "lua/query_info_submit.lua",
    "lua/select_hanzi.lua",
    "lua/tool_calculator.lua",
    "lua/tool_processor.lua",
    "lua/tool_segmentor.lua",
    "lua/tool_translator.lua",
    "lua/tool_unicode_data.lua",
    "lua/tool_unicode.lua",
    "lua/u_translator.lua",
    "luna_pinyin.dict.yaml",
    "luna_pinyin.extended.dict.yaml",
    "luna_pinyin.research.dict.yaml",
    "mixed_full.dict.yaml",
    "mixed_full.schema.yaml",
    "opencc/mdx_t2s.json",
    "opencc/mdx_words.txt",
    "pc_research.custom.yaml",
    "pc_research.schema.yaml",
    "project_literary_terms.dict.yaml",
    "project_pde_terms.dict.yaml",
    "project_radical_parts.dict.yaml",
    "project_radical_parts.schema.yaml",
    "project_radical.dict.yaml",
    "project_radical.schema.yaml",
    "project_symbols.dict.yaml",
    "project_terms.dict.yaml",
    "query_strokes.tsv",
    "research_greek.dict.yaml",
    "rime.lua",
    "u_readings.tsv",
    "weasel.custom.yaml",
    "zh-hant-t-essay-bgw-compact.gram",
)
EXCLUDED = ('README.md', 'jp_sela.schema.yaml', 'jp_sela_custom.dict.yaml')
HELPERS = ('generate-japanese-base.py', 'validate-japanese-base.py', 'make-opencc-config.py')

JAPANESE_DOC = """# 日語基底與 q／x／v

這份日語 schema 和純假名字典按 RymCp 現用的五母音、行、拗音、擴展音及本工程規則生成。`jp_sela` 和 `jp_sela_custom` 是 RymCp 現用模組／學習介面的 ID，沿用名稱不改既定介面。早期方案設計曾借鑒 [Sela/rime-jp_sela](https://github.com/Selaube/rime-jp_sela)，其後的假名、漢字與 q／x／v 規則以本工程為準。

小寫碼輸出平假名，大寫碼輸出片假名；小假名前加 x，例如 xa／XA、xtsu／XTSU。xX 是現有整段小假名查詢入口，另有 Unicode 小假名擴展表。q／qQ 使用有來源的 JMdict 詞形，v／vV 用中文拼音查日本漢字及讀音。Ctrl+E 選日語方案，Ctrl+R 返回中文／智能英文方案。

## 生成與驗證

需要 Python 3.10 或更新版本。從倉庫根目錄執行：

```powershell
python config/pc/tools/generate-japanese-base.py --output out/japanese-base
python config/pc/tools/validate-japanese-base.py --directory config/pc
```

產生器不讀外部字典、不連線、不讀學習庫，且拒絕覆寫已存在的輸出目錄。它產生新 schema、673 行假名字典和 322 項 `japanese-q-canonical.json`。q 資料重建器應以這個 JSON object 作為假名片段→碼的輸入，鼻音 n／n'／詞尾 nn 由 q 的 romanize 規則處理。

本工程規則包括 di／dsu、wi／we 輸出ゐ／ゑ、長音 l／L、促音重複首字母，以及 x 小假名。這不是宣稱所有碼都是單一標準羅馬字。詳情可讀產生器中的命名規則和公開驗證案例。

`jp-v-compatibility.json` 是本工程明列的 28 個字種集合，每字保留 Unihan 日本來源與讀音依據；v 重建時從官方資料取音。檔名沿用現用工具介面。

## 保留功能與差異

現有 q／v Lua、JMdict／KANJIDIC2／Unihan 資料與學習介面保持。公開重建器已從固定 JMdict XML 與這份獨立 canonical inventory 完整重生 q 詞庫，共 423,663 行；SHA256 為 `a88dbdca92805084447df214ce135402b58b1842844fcc7ffbfa8f4af1be7e05`，與本包 `jp_q_lookup.dict.yaml` 逐位元一致。實際命令見[構建說明](../../docs/BUILD.md)。

322 項拼寫的比對對象是本工程現用 q 詞庫，並非早期參考方案的舊版。假名、漢字與 q／x／v 規則以本工程為準，不復刻舊表；漢字候選依公開、可署名的 q／v 資料提供。v 全量資料尚未在本輪重生，q 的等值結果不代表 v 已完整重建。

公開驗證腳本覆蓋碼字對照、大小寫、鼻音邊界、促音、擴展音與生成檔一致性；完整引擎與候選次序驗證需另外執行。沒有把舊 Sela 表作公開測試輸入。第三方來源及資料授權見 [JP q 來源](../../docs/sources/jp-q-sources.md) 與 [JP v 來源](../../docs/sources/jp-v-sources.md)。
"""

OPENCC_DOC = """# 本機 OpenCC 資源設定

`opencc/mdx_t2s.json` 保留目前 MDX 小範圍字形規則及官方 TC→SC 轉換鏈，資料內容沒有改動。倉庫中的 JSON 僅使用相對檔名，不含任何人的安裝位置。

Rime 會先在 user/opencc、再在 shared/opencc 尋找 JSON；JSON 裡的字典檔案則由 OpenCC 自己搜尋，不能據此前一個步驟推定它也會跨到 Rime shared/opencc。因此在只有 user/opencc/mdx_words.txt、而標準字典留在 shared/opencc 的安裝中，先生成本機 JSON：

```powershell
python config/pc/tools/make-opencc-config.py --shared-dir <Rime共享資料目錄> --output out/local-mdx_t2s.json
```

工具也接受直接指定共享資料的 opencc 子目錄。它檢查 TSPhrases.ocd2／TSCharacters.ocd2 及本包 mdx_words.txt，將三者的本機絕對位置寫入一份新 JSON，不複製或下載字典，拒絕覆寫既有檔案。安裝時將結果命名為 user/opencc/mdx_t2s.json；生成結果含本機位置，留在本機，不要提交到公開倉庫。

若標準字典和 JSON 已放在同一 opencc 目錄，相對檔名可由 OpenCC 在 JSON 所在目錄找到。本次檢查確認來源搜尋規則與資源檔存在，未把所有安裝環境的相對路徑解析宣稱為已驗證。

[MDX 規則來源](../../docs/sources/mdx-orthography-sources.md)與 [OpenCC 授權](licenses/OpenCC-LICENSE.txt)分別保留。TC／SC輸出選擇與介面語言分開。
"""


def sha(data):
    return hashlib.sha256(data).hexdigest()


def resource_dir():
    here = Path(__file__).resolve().parent
    development = here / 'config-release-resources'
    return development if development.is_dir() else here


def module_at(path):
    spec = importlib.util.spec_from_file_location('rymcp_release_japanese', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def transform(name, raw):
    if name.startswith('licenses/') and name.endswith('-sources.md'):
        source_name = Path(name).name
        content = (
            '# 公開來源說明\n\n'
            '這份來源說明的公開維護版本見 '
            f'[{source_name}](../../../docs/sources/{source_name})。\n\n'
            '對應第三方授權正文與署名仍隨本目錄及倉庫 licenses/ 保存；'
            '本索引不更改任何第三方授權。\n'
        )
        return content.encode('utf-8'), 'link to one sanitized public source record'
    if name == 'licenses/query-strokes-source.json':
        data = json.loads(raw)
        data['source'] = 'Official Weasel 0.17.4 bundled data/stroke.dict.yaml'
        return (json.dumps(data, ensure_ascii=False, indent=2) + '\n').encode('utf-8'), 'portable source identity'
    if name == 'opencc/mdx_t2s.json':
        data = json.loads(raw)

        def visit(value):
            if isinstance(value, dict):
                if 'file' in value:
                    value['file'] = value['file'].replace('\\', '/').rsplit('/', 1)[-1]
                for child in value.values():
                    visit(child)
            elif isinstance(value, list):
                for child in value:
                    visit(child)
        visit(data)
        return (json.dumps(data, ensure_ascii=False, indent=2) + '\n').encode('utf-8'), 'relative OpenCC resource names; local resolver tool supplied'
    if name not in ('default.custom.yaml', 'weasel.custom.yaml', 'pc_research.custom.yaml', 'jp_sela.custom.yaml'):
        return raw, 'unchanged'
    text = raw.decode('utf-8').replace('\r\n', '\n')
    if name == 'default.custom.yaml':
        text = text[text.index('patch:\n'):]
        text = text.replace('    - schema: bopomofo\n', '')
        return text.encode('utf-8'), 'remove stale generator metadata; publish two available schemes'
    if name == 'weasel.custom.yaml':
        start = text.index('  "style/color_scheme": reference_gray\n')
        text = 'patch:\n' + text[start:]
        text = text.replace('  # Reference screenshots, sampled 2026-10-15. ABGR format.', '  # Reference Gray; ABGR color format.')
        text = text.replace('    author: "User reference screenshots"', '    author: "RymCp contributors"')
        return text.encode('utf-8'), 'active theme retained; remove stale metadata and unused Pu theme'
    if name == 'jp_sela.custom.yaml':
        marker = text.index('patch:\n')
        text = '# RymCp Japanese integration; jp_sela is the current RymCp module interface ID.\n' + text[marker:]
        return text.encode('utf-8'), 'integration header for the independent Japanese base'
    text = text.replace('# Daily integration: Luna input modules plus the installed 61003 GUI.', '# Public PC baseline: matching patched Weasel and librime-lua builds are required.')
    return text.encode('utf-8'), 'remove obsolete installed-GUI version comment'


def build(source, output):
    source, output = source.resolve(), output.resolve()
    if output.exists():
        raise ValueError('Destination already exists; choose a new directory. Nothing was overwritten.')
    if output == source or source in output.parents:
        raise ValueError('Destination must be outside the source directory.')
    if len(ALLOWLIST) != len(set(ALLOWLIST)) or len(ALLOWLIST) != 122:
        raise ValueError('Invalid explicit allowlist.')
    resources = resource_dir()
    for rel in ALLOWLIST:
        if not (source / rel).is_file():
            raise ValueError(f'Missing allowlisted source: {rel}')
    for name in (*HELPERS, 'jp-v-compatibility.json'):
        if not (resources / name).is_file():
            fallback = Path(__file__).resolve().parent.parent / name
            if name != 'jp-v-compatibility.json' or not fallback.is_file():
                raise ValueError(f'Missing build resource: {name}')
    # All required inputs were checked before creating the destination.
    output.mkdir(parents=True)
    records = []
    for rel in ALLOWLIST:
        raw = (source / rel).read_bytes()
        candidate, action = transform(rel, raw)
        dest = output / rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(candidate)
        records.append({'path': rel, 'source_sha256': sha(raw), 'sha256': sha(candidate), 'bytes': len(candidate), 'action': action})
    generator = module_at(resources / 'generate-japanese-base.py')
    generated = generator.render_outputs()
    for rel, content in generated.items():
        (output / rel).write_bytes(content.encode('utf-8'))
    tools = output / 'tools'
    tools.mkdir()
    for name in HELPERS:
        (tools / name).write_bytes((resources / name).read_bytes())
    (tools / 'build-config-release.py').write_bytes(Path(__file__).read_bytes())
    compat = resources / 'jp-v-compatibility.json'
    if not compat.is_file():
        compat = Path(__file__).resolve().parent.parent / 'jp-v-compatibility.json'
    (output / 'jp-v-compatibility.json').write_bytes(compat.read_bytes())
    (output / 'JAPANESE.md').write_bytes(JAPANESE_DOC.encode('utf-8'))
    (output / 'OPENCC.md').write_bytes(OPENCC_DOC.encode('utf-8'))
    created = [*generated, 'jp-v-compatibility.json', 'JAPANESE.md', 'OPENCC.md', *(f'tools/{name}' for name in (*HELPERS, 'build-config-release.py'))]
    generated_records = [{'path': rel, 'sha256': sha((output / rel).read_bytes()), 'bytes': (output / rel).stat().st_size} for rel in created]
    manifest = {
        'format': 'rymcp-public-config-v1',
        'allowlisted_source_files': len(ALLOWLIST),
        'excluded_legacy_source_files': list(EXCLUDED),
        'source_files': records,
        'generated_files': generated_records,
        'note': 'Original borrowed Japanese schema/table are excluded; independent schema/kana files are generated. No personal data is an input.',
    }
    (output / 'config-source-manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8', newline='\n')
    return {'copied_or_transformed': len(records), 'changed_sources': sum(r['action'] != 'unchanged' for r in records), 'independent_generated': len(created), 'manifest_files': 1, 'total_files': len(records) + len(created) + 1}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path, required=True, help='Explicit PC source directory; only ALLOWLIST entries are read.')
    parser.add_argument('--output', type=Path, required=True, help='New candidate directory outside source; never overwrites.')
    args = parser.parse_args()
    try:
        result = build(args.source, args.output)
    except (ValueError, OSError) as error:
        parser.error(str(error))
    print(json.dumps(result, ensure_ascii=True, indent=2))


if __name__ == '__main__':
    main()

