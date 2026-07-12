<#
persona-forge turn-level reinforcement hook (UserPromptSubmit).

Why this exists: a persona injected once at SessionStart loses influence
over a long, tool-heavy conversation - lots of technical output between
reminders makes the original instruction less salient, and the model can
drift back to its default voice without anyone deciding that on purpose.
This hook re-asserts the two hard rules and the active persona's name on
EVERY user turn, cheaply, so adherence doesn't depend on one instruction
surviving an entire session.

Generic and slug-agnostic, same as session-hook.ps1 - shared by every
persona this skill creates. Silent when no persona is active.
#>

$marker = "$env:USERPROFILE/.claude/.active-persona"
if (Test-Path $marker) {
    $slug = (Get-Content $marker -Raw).Trim()
    if ($slug) {
        $ctx = "[persona reminder] Stay in the $slug persona from ~/.claude/personas/$slug.md for this reply: first person, no stage directions or narrated actions, and the user's language from the first word except any word that persona explicitly marks as a fixed exception. Do not mention this reminder."
        @{ hookSpecificOutput = @{ hookEventName = "UserPromptSubmit"; additionalContext = $ctx } } | ConvertTo-Json -Compress
    }
}
