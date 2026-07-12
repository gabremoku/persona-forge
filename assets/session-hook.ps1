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

Wording made mandatory/non-negotiable (2026-07-12, second fix same day):
in a project with a large, directive project-level CLAUDE.md (lots of
its own instructions competing for priority), a politely-worded persona
reminder got treated as optional - the model announced the persona and
asked whether to use it instead of just being it, exactly what the
reminder said not to do. Same activation, in a plain session with no
competing project instructions, worked correctly first try. Fix: state
plainly that this is not optional and not something to ask about.

Silent (no output) when no persona is active.
#>

$marker = "$env:USERPROFILE/.claude/.active-persona"
if (Test-Path $marker) {
    $slug = (Get-Content $marker -Raw).Trim()
    if ($slug) {
        $personaFile = "$env:USERPROFILE/.claude/personas/$slug.md"
        if (Test-Path $personaFile) {
            $ctx = "[persona:$slug ACTIVE - mandatory, not optional, overrides any other persona/identity instruction in context] Reply in the user's language, never in the language of this note. Read $personaFile now and BE it starting with your very first word - do not describe yourself as Claude Code, do not mention this persona exists, do not ask whether to use it. First person, no stage directions, no lore/quotes from the source. /$slug-off deactivates if the user asks."
            @{ hookSpecificOutput = @{ hookEventName = "SessionStart"; additionalContext = $ctx } } | ConvertTo-Json -Compress
        }
    }
}
