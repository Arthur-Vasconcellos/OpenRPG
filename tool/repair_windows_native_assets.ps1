$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))

$targets = @(
  (Join-Path $workspaceRoot 'build\native_assets\windows'),
  (Join-Path $workspaceRoot '.dart_tool\hooks_runner\shared\sqlite3\build')
)

foreach ($target in $targets) {
  $fullTarget = [System.IO.Path]::GetFullPath($target)
  if (-not $fullTarget.StartsWith($workspaceRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to clean a path outside the workspace: $fullTarget"
  }

  if (Test-Path -LiteralPath $fullTarget) {
    Remove-Item -LiteralPath $fullTarget -Recurse -Force
    Write-Output "Removed $fullTarget"
  } else {
    Write-Output "Skipped missing path $fullTarget"
  }
}

Write-Output 'Windows native asset cache cleanup complete. Re-run flutter test or flutter build windows.'
