# Judo Mind Device Validation Runbook

Date: 2026-08-15

Canonical runner:

`D:\projects\judo_mind_checkpoints\run_judo_mind_device_validation_canonical_v3.ps1`

The v1/v2 runners are historical evidence and must not be edited or used for a
new validation.

## One Command for the Next User-Triggered Validation

Open a normal Windows PowerShell window and run this one line:

```powershell
$checkpoint=(Get-ChildItem -LiteralPath 'D:\projects\judo_mind_checkpoints' -Directory -Filter '*_post_nonvisual_release_readiness_v1' | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName; powershell.exe -NoProfile -NoExit -ExecutionPolicy Bypass -File "D:\projects\judo_mind_checkpoints\run_judo_mind_device_validation_canonical_v3.ps1" -CheckpointRoot $checkpoint
```

During the countdown, the user may close Codex/ChatGPT and Chrome to release
memory. The runner never closes those programs, VPN/DNS or any other user
application. Keep the Xiaomi device, VPN/DNS connection and the new PowerShell
window open.

Success is:

`VALIDATION FINISHED - SUCCESS`

Artifacts are written beneath:

`D:\projects\judo_mind\build\device_validation\canonical_v3_device_validation_<timestamp>`

## Safe Offline Modes

These modes never run Flutter, Gradle, install, launch or screenshots:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "D:\projects\judo_mind_checkpoints\run_judo_mind_device_validation_canonical_v3.ps1" -SyntaxCheck
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "D:\projects\judo_mind_checkpoints\run_judo_mind_device_validation_canonical_v3.ps1" -SelfTest
```

This mode also performs no ADB/device command. It checks the approved
checkpoint, branch, HEAD, empty staging and exact current Git status, then
repeats the preservation audit:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "D:\projects\judo_mind_checkpoints\run_judo_mind_device_validation_canonical_v3.ps1" -PreflightOnly -CheckpointRoot "<validated checkpoint path>"
```

The expected messages are `SYNTAX CHECK FINISHED - SUCCESS`,
`SELFTEST FINISHED - SUCCESS` and `PRECHECK FINISHED - SUCCESS`.

## Deterministic Safety Boundary

- Native exit code is authoritative; stderr warnings with exit code 0 are
  recorded but do not create a false failure.
- The target ADB state is classified as `authorized`, `unauthorized`,
  `offline`, `missing`, `wrong_model` or `invalid`.
- Both physical-memory readings must be at least 950 MB.
- The build-attempt counter cannot exceed one.
- An existing APK is never accepted unless the one permitted build returns 0
  and produces a newer APK timestamp.
- APK path, timestamp, byte size and SHA-256 are recorded before install.
- Install, cold launch, application process ID, foreground activity, bounded
  logcat and every guided screenshot/hierarchy result are recorded.
- App data is not cleared. History deletion is never confirmed. Video/V2A
  analysis and model inference are not run.
- Final branch, HEAD, staging, porcelain status and tracked/untracked content
  fingerprints must match their initial values.

## Historical Runner Defects

| Historical file | Defect | v3 disposition |
|---|---|---|
| `run_settings_progress_device_validation_detached.ps1:397-399` | A possibly scalar checkpoint-status/Compare-Object result used `.Count` directly and failed before build. | Every nullable/scalar result is normalized to a typed array and counted through `@(...).Count`. |
| `run_settings_progress_device_validation_detached_v2.ps1:639` | `$pid = ...` attempted to overwrite PowerShell's read-only automatic `$PID` variable because variable names are case-insensitive. | The canonical runner uses `$appProcessId`; its AST self-test requires zero assignments to `$PID`. |

The self-test also proves scalar status handling, warning-on-stderr exit-code
semantics, authorized/unauthorized/offline/missing device classification,
zero/one/multiple preservation comparisons and the one-build-attempt limit.

## Static Analysis Audit

The previous bounded Dart inventory contained exactly 11 diagnostics. Eight
deterministic behavior-preserving issues were corrected:

- unused imports in `judo_icon.dart` and `media_header.dart`;
- a duplicate import in `technique_provider.dart`;
- a dangling file-header doc comment in `judo_illustration_type.dart`;
- null-aware collection elements in `judo_app_bar.dart` and
  `judo_section.dart`;
- an unnecessary `const` in `uchi_mata_media_catalog.dart`;
- unnecessary multiple underscores in `media_filter_bar.dart`.

Three diagnostics remain intentionally:

| File and line | Category | Reason |
|---|---|---|
| `lib/screens/technique_detail/widgets/media/media_section.dart:486` | `UNUSED_ELEMENT` — `_MediaLibraryIntro` | Existing private Media prototype. Removing it discards user work; wiring it changes Media UX outside this block. |
| `lib/screens/technique_detail/widgets/media/media_section.dart:625` | `UNUSED_ELEMENT` — `_MediaThumbnail` | Existing private Media prototype. Removing or activating it requires a separate approved Media decision. |
| `lib/screens/technique_detail/widgets/media/media_section.dart:722` | `UNUSED_ELEMENT` — `_MediaItemInformation` | Existing private Media prototype. It remains preserved until Media scope is authorized. |

The eight changed warning files have a clean bounded Dart analysis. A bounded
`dart analyze lib --format machine` repeat reports only the three rows above.
This is not a claim that repository-wide `flutter analyze` completed cleanly.
