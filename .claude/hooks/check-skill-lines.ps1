# PostToolUse hook: enforce the SKILL.md line cap (soft warn at 450, hard block at 500).
$payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
$path = $payload.tool_input.file_path
if (-not $path) { exit 0 }
if ($path -notmatch 'skills[\\/]claude-perfectionist[\\/]SKILL\.md$') { exit 0 }
if (-not (Test-Path $path)) { exit 0 }

$lines = (Get-Content $path).Count
if ($lines -ge 500) {
    [Console]::Error.WriteLine("SKILL.md is at $lines/500 lines - over the cap. Trim or extract to references/ before continuing.")
    exit 2
}
if ($lines -ge 450) {
    $msg = "SKILL.md is at $lines/500 lines - approaching the cap; prefer extracting to references/ over adding."
    @{ hookSpecificOutput = @{ hookEventName = "PostToolUse"; additionalContext = $msg } } | ConvertTo-Json -Compress
}
exit 0
