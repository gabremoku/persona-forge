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

Generic and slug-agnostic, same as session-hook.ps1 - shared by every
persona this skill creates. Silent when no persona is active.
#>

$marker = "$env:USERPROFILE/.claude/.active-persona"
if (Test-Path $marker) {
    $slug = (Get-Content $marker -Raw).Trim()
    if ($slug) {
        $ctx = "[persona:$slug] Reply in the SAME language as the user's message, never in the language of this note. First person, no stage directions, no lore/quotes from the source."
        @{ hookSpecificOutput = @{ hookEventName = "UserPromptSubmit"; additionalContext = $ctx } } | ConvertTo-Json -Compress
    }
}
