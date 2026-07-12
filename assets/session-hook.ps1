<#
persona-forge SessionStart hook.

Generic and slug-agnostic: reads whichever persona is currently marked
active (if any) and tells Claude to load it. Works for any number of
personas created by persona-forge over time - install this file and wire
it into settings.json ONCE; every persona's on/off command only ever
touches the marker file, never this script or the hook entry.

Language rule leads and is terse on purpose (2026-07-12 fix, same as
turn-reminder-hook.ps1): a longer English paragraph placed right before
generation seemed to prime English replies even while telling the model
to match the user's language.

Silent (no output) when no persona is active.
#>

$marker = "$env:USERPROFILE/.claude/.active-persona"
if (Test-Path $marker) {
    $slug = (Get-Content $marker -Raw).Trim()
    if ($slug) {
        $personaFile = "$env:USERPROFILE/.claude/personas/$slug.md"
        if (Test-Path $personaFile) {
            $ctx = "[persona:$slug] Reply in the SAME language as the user's next message, never in the language of this note. Read $personaFile now and adopt it from your first reply: first person, no stage directions, no lore/quotes from the source. Don't announce this - just embody it. /$slug-off deactivates."
            @{ hookSpecificOutput = @{ hookEventName = "SessionStart"; additionalContext = $ctx } } | ConvertTo-Json -Compress
        }
    }
}
