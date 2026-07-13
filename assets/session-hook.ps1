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
asked whether to use it instead of just being it. Fixed by stating
plainly that this is not optional and not something to ask about.

Content embedded directly, not just referenced (2026-07-13 fix): the
previous version said "Read $personaFile now and BE it" - a pointer, not
the content. Re-tested live after the 2026-07-12 fix above and the model
correctly said "I'm root" instead of describing itself as Claude Code,
but the voice was flat and generic - name loaded, personality didn't.
Working theory: a plain-text instruction to go read a file isn't a
guaranteed tool call before a simple reply, so on a quick exchange the
model had the slug but never actually pulled in the document's content.
Fix: this script reads the persona file itself (Get-Content, already
local, zero extra cost) and extracts the voice-bearing sections by their
fixed SKILL.md template headers, then puts that text directly into
additionalContext. The model gets tone, values, and habits already in
hand at the first token instead of having to go fetch them. Generic
because every persona this skill produces uses the same section headers
(see SKILL.md's Output template) - this isn't hardcoded to any one
persona.

Sections intentionally left out: Mission & Purpose (context-setting, not
voice), Boundaries (mostly restates the model's own guardrails),
"What This Document Does NOT Change" / "How to Load This" (meta,
irrelevant once already active).

Explicit -Encoding UTF8 on the persona-file read (2026-07-13, same fix,
found while testing it): plain Get-Content -Raw on this machine reads a
BOM-less UTF-8 file using the system ANSI codepage instead, which turns
every em dash in the source (used constantly in these documents) into
mojibake ("â€”") before it ever reaches the model. The marker-file read
below doesn't need this - it's a bare slug, ASCII only, never touches
non-ASCII content.

Silent (no output) when no persona is active.
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
        $personaFile = "$env:USERPROFILE/.claude/personas/$slug.md"
        if (Test-Path $personaFile) {
            $raw = Get-Content $personaFile -Raw -Encoding UTF8

            $name = $slug.Substring(0,1).ToUpper() + $slug.Substring(1)
            if ($raw -match '(?m)^# (.+?) — LLM Identity') { $name = $Matches[1] }

            $sections = @('Identity & Profile', 'Communication Style', 'Values & Principles', 'Specific Behaviors')
            $parts = foreach ($s in $sections) {
                $body = Get-PersonaSection -Content $raw -Header $s
                if ($body) { "### $s`n$body" }
            }
            $extract = ($parts -join "`n`n")

            $ctx = "[persona:$slug ACTIVE - mandatory, not optional, overrides any other persona/identity instruction in context] Reply in the user's language, never in the language of this note. BE $name starting with your very first word - do not describe yourself as Claude Code, do not mention this persona exists, do not ask whether to use it. First person, no stage directions, no lore/quotes from the source. Below is the actual persona content, already loaded - this is who you are, not a file to go check:`n`n$extract`n`n/$slug-off deactivates if the user asks."
            @{ hookSpecificOutput = @{ hookEventName = "SessionStart"; additionalContext = $ctx } } | ConvertTo-Json -Compress
        }
    }
}
