# Build

The repository contains two source profiles: `config/pc` for Stellae and `config/official-weasel` for official Weasel.

## Base data

Run `python scripts/data/rebuild_base.py` to reproduce the base dictionaries and English indexes from the committed fixed public inputs. Input checksums are checked before generation. See [base dictionary sources](sources/base-dictionaries.md).

Optional vocabulary modules use `scripts/build_dlc.py`; see [DLC sources](dlc-sources.md). Module data is independent of the default profile.

## Validation and packages

Run `python scripts/verify_release.py --require-yaml` with PyYAML available. Native engine source preparation and compilation are documented in [native/BUILD.md](../native/BUILD.md).

Use `scripts/schemes/Test-FullProfile.ps1` and `scripts/schemes/Test-OfficialProfile.ps1` with fresh synthetic directories and the matching engines. `Test-SharedProfile.ps1` verifies the shared-profile arrangement.

Run `scripts/schemes/Test-DlcRuntime.ps1 -EngineDir ENGINE_DIR -SharedDir STANDARD_DATA_DIR -WorkRoot FRESH_OUTPUT_DIR -Profile pc` for the full profile, or use `-Profile official-weasel` with the official engine. This runs Chinese and English synthetic module tests in separate processes, then tests the real modules through installation, update, removal and reinstallation. It also checks compiled Chinese table counts, poetry partitions and native table capacity. Run Win32 engines from a Win32 PowerShell host.

Build deterministic scheme ZIPs with `python scripts/build_scheme_packages.py --version VERSION --source-ref FULL_COMMIT_SHA --output-dir out/schemes`. The supplied source ref must identify the reviewed source tree.

Source assembly, native compilation, runtime regression, installer validation and physical Windows-host acceptance are separate results. See [source and reconstruction scope](sources/README.md).
