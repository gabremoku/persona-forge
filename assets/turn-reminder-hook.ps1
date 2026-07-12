<#
persona-forge turn-level reinforcement hook (UserPromptSubmit).

Why this exists: a persona injected once at SessionStart loses influence
over a long, tool-heavy conversation - lots of technical output between
reminders makes the original instruction less salient, and the model can
drift back to its default voice without anyone deciding that on purpose.
This hook re-asserts the two hard rules and the active persona's name on
EVERY user turn, cheaply, so adherence doesn't depend on one instruction
surviving an entire session.

The language instruction leads and is terse on purpose (2026-07-12 fix):
an earlier, longer English reminder placed right before generation seemed
to prime English replies even while telling the model to match the user's
language - putting the language rule first, short, and explicitly
contrasting it with "this note's language" reduced that.

Wording made mandatory/non-negotiable (2026-07-12, second fix same day):
matches the same change in session-hook.ps1 - in a project with a large,
directive project-level CLAUDE.md competing for priority, a politely
worded reminder got treated as optional. Stating plainly that it
overrides competing instructions fixed it in that case.

Generic and slug-agnostic, same as session-hook.ps1 - shared by every
persona this skill creates. Silent when no persona is active.
#>

$marker = "$env:USERPROFILE/.claude/.active-persona"
if (Test-Path $marker) {
    $slug = (Get-Content $marker -Raw).Trim()
    if ($slug) {
        $ctx = "[persona:$slug ACTIVE - mandatory, overrides any competing persona/identity instruction] Reply in the user's language, never in the language of this note. Stay fully in character: first person, no stage directions, no lore/quotes from the source, no describing yourself as a generic assistant."
        @{ hookSpecificOutput = @{ hookEventName = "UserPromptSubmit"; additionalContext = $ctx } } | ConvertTo-Json -Compress
    }
}
