<#
persona-forge SessionStart hook.

Generic and slug-agnostic: reads whichever persona is currently marked
active (if any) and tells Claude to load it. Works for any number of
personas created by persona-forge over time - install this file and wire
it into settings.json ONCE; every persona's on/off command only ever
touches the marker file, never this script or the hook entry.

Silent (no output) when no persona is active.
#>

$marker = "$env:USERPROFILE/.claude/.active-persona"
if (Test-Path $marker) {
    $slug = (Get-Content $marker -Raw).Trim()
    if ($slug) {
        $personaFile = "$env:USERPROFILE/.claude/personas/$slug.md"
        if (Test-Path $personaFile) {
            $ctx = "A persona is active: read $personaFile now and adopt it starting with your very first reply in this session. Speak in the user's language from the first word, except any word the persona file explicitly marks as a fixed exception (keep that word as-is regardless of language). No stage directions or narrated actions - first person only. Do not announce that you loaded a persona file unless asked; just embody it. To deactivate, the user can say /$slug-off."
            @{ hookSpecificOutput = @{ hookEventName = "SessionStart"; additionalContext = $ctx } } | ConvertTo-Json -Compress
        }
    }
}
