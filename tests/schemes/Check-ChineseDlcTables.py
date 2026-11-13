#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-only
"""Check compiled optional tables against their complete source catalogs."""
import argparse
import hashlib
import json
from pathlib import Path
import struct


def entries(path):
    data = path.read_text(encoding="utf-8-sig")
    body = data.split("\n...\n", 1)[1]
    result = {}
    for line in body.splitlines():
        if not line or line.startswith("#"):
            continue
        text, code, weight = line.split("\t")
        identity = (text, code)
        if identity in result:
            raise ValueError("Duplicate source identity")
        result[identity] = weight
    return result


def check(build_dir, modules_dir):
    reports = []
    for module_id in ("math", "physics", "computer", "poetry"):
        module = modules_dir / module_id
        if not module.exists():
            continue
        catalog_path = module / "words.dict.yaml"
        catalog = entries(catalog_path)
        pieces = sorted(module.glob("words_[0-9][0-9].dict.yaml"))
        if pieces:
            if module_id != "poetry" or len(pieces) != 32:
                raise ValueError("Unexpected table partition")
            union = {}
            for piece in pieces:
                for identity, weight in entries(piece).items():
                    if identity in union:
                        raise ValueError("Repeated identity across partitions")
                    union[identity] = weight
            if union != catalog:
                raise ValueError("Partitions differ from the complete catalog")
        else:
            pieces = [catalog_path]
        for piece in pieces:
            suffix = "" if piece == catalog_path else "_" + piece.stem.split("_")[-1].split(".")[0]
            name = "rymcp_dlc_" + module_id + suffix
            source_entries = len(entries(piece))
            data = (build_dir / (name + ".table.bin")).read_bytes()
            if len(data) < 68 or not data[:32].startswith(b"Rime::Table/"):
                raise ValueError("Unknown compiled table layout")
            syllables, count = struct.unpack_from("<II", data, 36)
            image_relative, image_size = struct.unpack_from("<iI", data, 60)
            image_start = 60 + image_relative
            initial_capacity = 4096 + 32 * syllables + 64 * count
            if count != source_entries or syllables < 1 or count < 1:
                raise ValueError("Compiled entry count differs from source")
            if image_start < 68 or image_size < 1 or image_start + image_size != len(data):
                raise ValueError("Compiled string table is incomplete")
            # Allocation is monotonic until Save(). A final image fitting the
            # initial capacity requires no mapping growth during this build.
            if len(data) > initial_capacity:
                raise ValueError("Compiled table exceeds its initial allocation")
            reports.append({
                "pack": name, "entries": count, "syllables": syllables,
                "initial_capacity": initial_capacity, "bytes": len(data),
                "string_image_bytes": image_size,
                "sha256": hashlib.sha256(data).hexdigest(),
                "source_sha256": hashlib.sha256(piece.read_bytes()).hexdigest(),
            })
    if not reports:
        raise ValueError("No optional source catalogs were found")
    return {"format": "chinese-dlc-table-check-v1", "passed": True, "tables": reports}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--build-dir", type=Path, required=True)
    parser.add_argument("--modules-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = check(args.build_dir.resolve(), args.modules_dir.resolve())
    encoded = json.dumps(result, indent=2) + "\n"
    if args.output:
        args.output.write_text(encoded, encoding="utf-8")
    print(json.dumps({"passed": True, "tables": len(result["tables"]),
                      "entries": sum(row["entries"] for row in result["tables"])}))


if __name__ == "__main__":
    main()
