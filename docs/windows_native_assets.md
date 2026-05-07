# Windows Native Asset Notes

Older Windows build logs in this repository showed repeated failures while Flutter
was copying the generated `sqlite3.dll` asset into
`build/native_assets/windows/sqlite3.dll`.

Observed symptom:

- `PathExistsException: Cannot copy file to ...\build\native_assets\windows\sqlite3.dll`

Observed root cause:

- The failing path is generated output, not source-controlled code.
- Flutter's Windows native-asset copy step was attempting to copy `sqlite3.dll`
  into a location where a stale generated copy already existed.
- The collision happened in the generated native-asset workspace under
  `build/native_assets/windows` and the shared hook-runner cache under
  `.dart_tool/hooks_runner/shared/sqlite3/build`.

Project remediation:

1. Clear the generated Windows native-asset outputs:

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\repair_windows_native_assets.ps1
```

2. Re-run the command that failed:

```powershell
flutter test
```

or

```powershell
flutter build windows
```

This cleanup only removes generated native-asset outputs inside the workspace.
It does not touch application source files.
