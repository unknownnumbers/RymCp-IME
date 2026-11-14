# Build

The repository contains two source profiles: `config/pc` for Stellae and `config/official-weasel` for official Weasel.

## Base data

Run `python scripts/data/rebuild_base.py` to reproduce the base dictionaries and English indexes from the committed fixed public inputs. Input checksums are checked before generation. See [base dictionary sources](sources/base-dictionaries.md).

Optional vocabulary modules use `python scripts/build_dlc.py`. Fixed source snapshots, source locks and build scripts are tracked. Expanded catalogs are generated under `out/dlc/modules/rymcp_dlc/`, and compressed module ZIPs under `out/dlc/`. These generated outputs are independent of the default profiles and are not tracked in Git. The build is offline and extracts its pinned reading dependency from the included wheel. See [DLC sources](dlc-sources.md).

## Validation and packages

Run `python scripts/verify_release.py --require-yaml` with PyYAML available. Native engine source preparation and compilation are documented in [native/BUILD.md](../native/BUILD.md).

Use `scripts/schemes/Test-FullProfile.ps1` and `scripts/schemes/Test-OfficialProfile.ps1` with fresh synthetic directories and the matching engines. `Test-SharedProfile.ps1` verifies the shared-profile arrangement.

Run `python -m unittest discover -s tests/data -p "test_*.py"` for the poetry cleaner and reading tests, including `test_dlc_readings.py`. The tests cover explicit variants, unresolved annotations, contextual readings, word boundaries and original-character fallback readings.

Build the DLC catalogs before running `scripts/schemes/Test-DlcRuntime.ps1 -EngineDir ENGINE_DIR -SharedDir STANDARD_DATA_DIR -WorkRoot FRESH_OUTPUT_DIR -Profile pc`, or use `-Profile official-weasel` with the official engine. `-ModulesDirectory` can select a separately generated `rymcp_dlc` directory. Run Win32 engines from a Win32 PowerShell host; the Python interpreter can remain x64.

The runner tests Chinese and English synthetic modules and the format 2 sharded layout in separate processes. It compiles the complete distributed catalogs once, checks every native code/text pair, entry counts and allocation capacity, and tests removal and restoration with compiled caches retained. A separate bounded fixture tests updates, uninstall, reinstall and synthetic learning preservation. Results distinguish `ActualFull` from `FixtureLifecycle` checks. Native table readback uses the test-only `marisa-trie==1.3.1` binding. CI pins the CPython 3.12 Windows x64 wheel by SHA-256 in [.github/workflows/schemes.yml](../.github/workflows/schemes.yml).

CI runs N01 x64, official x64 and R5 Win32 checks in parallel. Package generation follows successful source and runtime checks. The large poetry catalog requires scheme base 2026.11.14.2 or later for its format 2 loader.

Build deterministic scheme ZIPs with `python scripts/build_scheme_packages.py --version VERSION --source-ref FULL_COMMIT_SHA --output-dir out/schemes`. The supplied source ref must identify the reviewed source tree.

Source assembly, native compilation, runtime regression, installer validation and physical Windows-host acceptance are separate results. See [source and reconstruction scope](sources/README.md).
