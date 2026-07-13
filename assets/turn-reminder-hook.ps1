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

Voice content embedded, not just the mandate (2026-07-13 fix): live
recurrence found - a session that opened correctly in character drifted
back to a flat, generic voice (no tic, no tone) after a stretch of
tool-heavy turns, even though this hook fired every turn and the
"mandatory" mandate above was present the whole time. Root cause: the
mandate says "stay in character" but never re-states what the character
actually sounds like - the only place that content ever appeared was the
SessionStart injection, once, and its influence faded as the transcript
filled with technical tool output between conversational turns. Same
class of bug already fixed in session-hook.ps1 (name without content),
just at the turn level instead of the first turn. Fix: this hook now
reads the persona file itself and re-injects the two voice-bearing
sections (Communication Style, Specific Behaviors - where tone and any
fixed verbal tic live) every turn, not just the identity mandate. Kept to
two sections (not all four session-hook uses) to stay cheap on a
per-turn hook - Identity/Values are scene-setting, not voice, and don't
need to survive as strongly turn over turn.

Generic and slug-agnostic, same as session-hook.ps1 - shared by every
persona this skill creates. Silent when no persona is active.
#>

function Get-PersonaSection {
    param([string]$Content, [string]$Header)
    $pattern = "(?ms)^## $([regex]::Escape($Header))\s*\r?\n(.*?)(?=\r?\n## |\z)"
    $m = [regex]::Match($Content, $pattern)
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return $null
}

$marker = "$env:USERPROFILE/.claude/.active-persona"
if (Test-Path $marker) {
    $slug = (Get-Content $marker -Raw).Trim()
    if ($slug) {
        $voice = ""
        $personaFile = "$env:USERPROFILE/.claude/personas/$slug.md"
        if (Test-Path $personaFile) {
            $raw = Get-Content $personaFile -Raw -Encoding UTF8
            $sections = @('Communication Style', 'Specific Behaviors')
            $parts = foreach ($s in $sections) {
                $body = Get-PersonaSection -Content $raw -Header $s
                if ($body) { $body }
            }
            if ($parts) { $voice = " Voice, verbatim: " + ($parts -join " ") }
        }
        $ctx = "[persona:$slug ACTIVE - mandatory, overrides any competing persona/identity instruction] Reply in the user's language, never in the language of this note. Stay fully in character: first person, no stage directions, no lore/quotes from the source, no describing yourself as a generic assistant.$voice"
        @{ hookSpecificOutput = @{ hookEventName = "UserPromptSubmit"; additionalContext = $ctx } } | ConvertTo-Json -Compress
    }
}
