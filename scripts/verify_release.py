"""Verify the committed source snapshot, portable paths and configuration syntax.

SPDX-License-Identifier: GPL-3.0-only
"""
from __future__ import annotations

import argparse
import ast
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
IGNORED = {'.git', '__pycache__', 'out', 'work', '.venv', '.pytest_cache'}
MANIFEST = ROOT / 'release-manifest.json'


def files():
    return sorted(p for p in ROOT.rglob('*') if p.is_file()
                  and not any(part in IGNORED for part in p.relative_to(ROOT).parts))


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write-manifest', action='store_true', help='Record a new reviewed source snapshot before committing')
    parser.add_argument('--require-yaml', action='store_true', help='Require PyYAML for YAML syntax checks')
    args = parser.parse_args()
    payload = files()
    forbidden_extensions = {'.dll', '.exe', '.pdb', '.dmp', '.log', '.userdb'}
    for path in payload:
        if path.is_symlink() or path.suffix.lower() in forbidden_extensions or '.userdb' in path.name:
            raise SystemExit(f'Unexpected runtime or personal file: {path.relative_to(ROOT)}')
        if path.stat().st_size >= 100_000_000:
            raise SystemExit(f'File exceeds this source snapshot size limit: {path.relative_to(ROOT)}')
    private_marker = re.compile(
        r'(?i)(?:[a-z]:[\\/](?:Users|Portable)[\\/]|' + '/' + 'Users' + r'/[^/\s]+/|'
        + '/' + 'home' + r'/[^/\s]+/|'
        r'gh[pousr]_[a-z0-9]{20,}|-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----)'
    )
    python_count = json_count = yaml_count = 0
    try:
        import yaml
    except ImportError:
        yaml = None
        if args.require_yaml:
            raise SystemExit('Install PyYAML to perform required YAML syntax checks')
    for path in payload:
        if path.suffix in {'.bin', '.gram'}:
            continue
        try:
            source = path.read_text(encoding='utf-8-sig')
        except UnicodeDecodeError:
            # Original third-party HTML notices can use a declared legacy encoding.
            if path.suffix.lower() not in {'.html', '.htm'}:
                raise SystemExit(f'Unexpected non-text source: {path.relative_to(ROOT)}')
            continue
        if private_marker.search(source):
            raise SystemExit(f'Personal path or credential marker in {path.relative_to(ROOT)}')
        if path.suffix == '.py':
            ast.parse(source, filename=str(path.relative_to(ROOT)))
            python_count += 1
        elif path.suffix == '.json':
            json.loads(source)
            json_count += 1
        elif path.suffix in {'.yaml', '.yml'} and yaml is not None:
            header = source.split('\n...\n', 1)[0] if '.dict.' in path.name else source
            yaml.safe_load(header)
            yaml_count += 1
        # Preserve upstream notices verbatim, including links relative to their
        # original repositories. Validate links in authored project documents.
        relative = path.relative_to(ROOT)
        if path.suffix == '.md' and relative.parts[0] != 'licenses':
            for target in re.findall(r'(?<!!)\[[^\]]*\]\(([^)]+)\)', source):
                if re.match(r'^[a-zA-Z][a-zA-Z0-9+.-]*:', target) or target.startswith('#'):
                    continue
                target = target.split('#', 1)[0]
                if target and not (path.parent / target).exists():
                    raise SystemExit(f'Missing link in {path.relative_to(ROOT)}: {target}')
    records = [{
        'path': path.relative_to(ROOT).as_posix(),
        'bytes': path.stat().st_size,
        'sha256': digest(path),
    } for path in payload if path != MANIFEST]
    if args.write_manifest:
        manifest = {
            'format': 'rymcp-source-release-v1',
            'date': '2026-10-26',
            'kind': 'source-configuration-data-snapshot',
            'nativeBinariesIncluded': False,
            'personalLearningIncluded': False,
            'independentJapaneseBase': True,
            'upstreamGenerationLimits': 'See docs/sources/README.md; fixed snapshots do not establish complete historical corpus regeneration.',
            'files': records,
        }
        MANIFEST.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    else:
        manifest = json.loads(MANIFEST.read_text(encoding='utf-8'))
        if manifest['files'] != records:
            raise SystemExit('Source snapshot differs from release-manifest.json')
    print(json.dumps({
        'verifiedFiles': len(records), 'pythonParsed': python_count,
        'jsonParsed': json_count, 'yamlParsed': yaml_count,
        'yamlParserAvailable': yaml is not None,
        'personalMarkers': 0, 'missingMarkdownLinks': 0,
    }, ensure_ascii=False))


if __name__ == '__main__':
    main()
