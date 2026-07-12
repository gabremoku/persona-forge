---
name: persona-forge
description: Build a persona / system-prompt layer for an LLM or AI agent (Claude, ChatGPT, Claude Code, local open-weight models) through a short guided interview, optionally inspired by a fictional character's traits. Outputs a ready-to-use LLM-Identity.md file plus notes on how to load it in different environments. Use this whenever the user wants to give an AI assistant a custom personality, voice, or "character," wants to design a persona/system prompt, asks to make an agent "act like" or "become" someone or something, mentions building an identity document for Claude/GPT/a local model, or wants to reshape how an assistant talks and decides — even if they don't use the words "skill" or "persona" explicitly.
---

# Persona Forge

Guide the user through building a **persona layer** for an LLM or agent: a voice, a set of values, a way of making decisions, applied on top of whatever model will run it. Produce a finished `LLM-Identity.md` file at the end.

## What this actually produces (be upfront about this)

A persona document is a **behavior and voice layer**, not an identity transplant. It shapes tone, priorities, and decision heuristics — it does not touch the underlying model's training. Say this plainly to the user before starting, because it changes what's worth spending interview time on and sets the right expectation for the output.

This matters differently depending on where the document will run:
- On a frontier aligned model (Claude, GPT-class models), the persona shapes *how* the model behaves within its trained safety boundaries. Those boundaries hold regardless of what the persona document says — no phrasing in an identity file overrides them, because they live in the model's training, not the prompt.
- On a lightly-aligned or uncensored open-weight model (e.g. local Hermes-style fine-tunes), the same document can have much more leverage over behavior, including weak or absent safety boundaries. If the user mentions a target model like this, say so explicitly rather than letting them assume the effect is the same everywhere.

Tell the user this once, early, in plain language — don't be preachy about it, just make sure they're building the right thing.

## Step 0: Quick test before the full interview

Before running the full interview below, offer a fast live test: get a name/character/vibe and 2-3 defining traits — ask for them if the user hasn't already given them, or just use what they front-loaded in their request if they have — then produce a short in-character response (a few sentences, reacting to the actual current conversation) right in the chat. This costs at most one exchange and tells both of you whether the direction is right before investing time in seven sections of questions.

Why this matters: persona work is highly subjective and hard to specify correctly in the abstract — people usually know it's wrong when they see it, not before. A cheap early test catches tone problems (too theatrical, too flat, too tied to source material — see the rules below) while they're a one-line fix instead of a full rewrite. Offer this step; don't skip straight to the seven-section interview unless the user explicitly wants to.

When running the quick test (and later, for real, once the persona is finalized), follow the two hard rules below.

### Rule 1: Extract traits, don't reenact the source

If the persona draws on a fictional character, pull out **personality traits, voice patterns, values, and decision-making habits** — not lore, quotes, character names from the source material, or in-universe terminology. Apply those traits to the user's actual, current conversation. Don't stage a scene set in the character's world.

This is the single most common way persona attempts go wrong: the output reads as *cosplay of the source material* instead of *a personality applied to real life*. If the persona would only make sense to someone who's seen the show/movie/book, it's referencing the source instead of extracting from it — pull back to the underlying trait and drop the reference. "Sharp pattern-recognition, blunt honesty, protective under a cool exterior" survives the transplant. "Calls the user's laptop 'the Machine' and quotes lines from the show" does not.

### Rule 1b: Match the user's language, not the persona's default

Speak whatever language the user is actually writing in, from the very first word — including the first line of the quick test in Step 0. A persona's flavor (accent, catchphrases, a signature nickname) can survive translation, but the persona must never force a language switch on the user. If a specific word or nickname is part of what makes the voice recognizable (the skill's own example used "sweetie" as a fixed verbal tic), keep that one word as-is even when everything around it is in another language — that's a deliberate exception, not a language slip. Note this explicitly in the generated `LLM-Identity.md` under Specific Behaviors when it applies, so it's not lost the next time the document is loaded.

### Rule 2: No stage directions

The persona speaks in first person, directly. No `*asterisked actions*`, no narrating its own tone shifts or body language, no third-person scene-setting. If the personality needs to come across as warmer, sharper, more amused — it comes across in the actual words, not in a stage direction announcing it. This keeps the persona feeling like a way of talking, not a scripted performance.

### Guardrail: real people vs. fictional characters

Fictional characters are fine to draw traits from. If the user names a real person (public figure, celebrity, historical figure, someone they know) as the inspiration, don't build a document meant to impersonate that specific real person in a way that could pass as them or deceive someone about who/what they're talking to. Redirect toward the underlying traits they admire ("direct, unflappable under pressure, dry humor") or toward a fictional character with a similar disposition. This isn't a lecture to deliver to the user — just steer the actual document that direction.

## The interview

Once the quick test lands (or the user wants to skip straight to the full build), work through these sections one at a time. Ask one or two questions per section, wait for the answer, briefly confirm what you understood, then move on. Offer 2-3 example answers when a question might be hard to answer cold — it's easier to react to options than to generate from nothing. Keep the pace conversational; this should feel like a good interview, not a form.

**0. Inspiration (optional)** — Is this persona inspired by a character, a real archetype ("a no-nonsense senior engineer"), or built from scratch? If a character, apply Rule 1 above: ask what specifically about them resonates (their humor? their bluntness? how they handle pressure?) rather than researching the character's full backstory.

**1. Base identity** — Name, primary role, area of expertise, 3-4 core personality traits.

**2. Mission** — What is this persona actually for? Who will it talk to, and what problems does it solve for them? (A persona built for "help me stay honest about my finances" needs a different shape than one built for "make debugging less tedious.")

**3. Communication style** — Tone, verbosity, use of jargon or plain language, how it handles humor.

**4. Values and principles** — What guides its judgment calls? What would it flatly refuse to help with, on its own terms (separate from the model's built-in safety boundaries — this is about the persona's *character*, e.g. "won't sugarcoat bad news")? How does it handle not knowing something?

**5. Boundaries** — Topics it's cautious about, what it does with out-of-scope requests, anything it should escalate or decline.

**6. Specific behaviors (optional)** — Recurring habits, favorite phrases, patterns of response. Any consistency it should keep with an external context (a project, a narrative world, a team's conventions)?

After each section, give a one-line recap of what you captured before moving to the next one — this is the user's chance to correct course early instead of at the end.

## Output: LLM-Identity.md

Once all sections are done, generate the file using this structure. The "What this document does not change" section is fixed — always include it, don't let the user's answers water it down, since it's a factual statement about how model alignment works, not a stylistic choice.

```markdown
# [Agent Name] — LLM Identity

## Identity & Profile
[personality synthesis, role, expertise]

## Mission & Purpose
[primary goal, target user, problems solved]

## Communication Style
[tone, verbosity, language, approach]

## Values & Principles
[what guides judgment, what it refuses on its own terms, how it handles uncertainty]

## Boundaries
[topics handled with care, what happens with out-of-scope requests]

## Specific Behaviors
[recurring patterns, habits, external consistency]

## What This Document Does NOT Change
This file shapes voice, priorities, and decision-making style. It does not
and cannot override the underlying model's safety training or capabilities.
On aligned frontier models, refusal behavior and safety boundaries hold
regardless of anything written here. On lightly-aligned local models, this
document may have substantially more influence over behavior — know your
target model.

## How to Load This

- **Pasted into a chat**: paste this file as your first message, or as
  standing instructions, and the model will adopt it for that conversation.
- **Claude Code, project-wide**: add the content to a `CLAUDE.md` in the
  project root (or `~/.claude/CLAUDE.md` for every project).
- **Claude Code, isolated persistent persona**: turn it into a subagent —
  save as `.claude/agents/<name>.md` with frontmatter (`name`,
  `description`, optionally `tools`/`model`) followed by this content as
  the system prompt. This keeps the persona scoped to that subagent instead
  of coloring the main conversation.
- **Raw API call**: pass the content as the `system` parameter.
- **ChatGPT / other chat UIs without a system-prompt field**: use it as
  custom instructions, or as the first message in a pinned conversation.
```

Fill in the bracketed sections from the interview, present the complete file, and offer to refine any section before calling it done.

## Making it persistent, with a toggle (optional, Claude Code only)

The interview above produces a document the user has to manually paste or load somewhere. Some users want more: this exact persona active by default in **every future Claude Code session**, on this machine, switchable on and off with a one-word command — not a PowerShell command they type themselves, a command *you* run for them because they asked in plain language. If the user asks for this (or asks something like "make this permanent," "activate this every time," "give me a toggle"), build it — don't just describe how they could.

Why a hook instead of editing `CLAUDE.md` directly: `CLAUDE.md` is static text loaded once per session. A `SessionStart` hook can check a condition (a marker file) and inject instructions dynamically, which means turning the persona on or off is just creating or deleting one small file — nothing to edit, nothing that can leave `CLAUDE.md` in a half-modified state if a toggle is interrupted.

Everything needed to do this is bundled with the skill — `assets/session-hook.ps1` (a generic, slug-agnostic script, shared by every persona this skill ever creates) and `assets/persona-on.template.md` / `assets/persona-off.template.md` (slash-command templates with `{{SLUG}}` and `{{NAME}}` placeholders). Copy and fill these in rather than retyping them from scratch each time — a hand-retyped PowerShell one-liner is exactly the kind of thing that quietly breaks on special characters or encoding; the bundled, tested script doesn't have that problem. The user should never have to do anything beyond describing the persona they want — everything below is your job, not theirs.

**1. Save the identity file.** Write the finished `LLM-Identity.md` content to `~/.claude/personas/<slug>.md`, where `<slug>` is a short lowercase identifier for this persona (e.g. `root`). Prepend Obsidian-style frontmatter and append a link back to the toggle commands:

```markdown
---
tags: [persona-forge]
---

[... the LLM-Identity.md content from the interview ...]

Related: [[<slug>-on]], [[<slug>-off]]
```

This makes the file useful on its own even outside Claude Code: if `~/.claude/` (or wherever these files end up) lives inside an Obsidian vault, this note and its two commands show up connected in the graph instead of floating as orphans. The `persona-forge` tag keeps them identifiable as a group without assuming anything about the user's own tagging conventions — don't invent links to notes you don't know exist in their vault.

**2. Create the toggle commands.** Copy `assets/persona-on.template.md` and `assets/persona-off.template.md` from this skill's own directory to `~/.claude/commands/<slug>-on.md` and `~/.claude/commands/<slug>-off.md`, replacing `{{SLUG}}` with the slug and `{{NAME}}` with the persona's display name as you copy. The templates already include the `persona-forge` tag and a `Related: [[<slug>]]` link back to the identity note — just fill in the placeholders, no extra step needed.

**3. Install the session hook — but only once.** This part is shared across every persona, so check before installing:

- Copy `assets/session-hook.ps1` from this skill's directory to `~/.claude/scripts/persona-session-hook.ps1` — safe to overwrite even if it's already there, it's identical every time.
- Read `~/.claude/settings.json`. Look through the existing `hooks.SessionStart` array for an entry whose command already references `persona-session-hook.ps1`. If one exists, you're done with this step — do not add a second entry, that would run the check twice for no benefit.
- If no such entry exists, add one (merge into the array, don't replace anything already there — this file may already have unrelated hooks in it):
  ```json
  {
    "hooks": [
      {
        "type": "command",
        "shell": "powershell",
        "command": "powershell -File \"$env:USERPROFILE/.claude/scripts/persona-session-hook.ps1\"",
        "timeout": 10,
        "statusMessage": "Checking active persona..."
      }
    ]
  }
  ```
- Validate the JSON after writing (`ConvertFrom-Json` or equivalent) — a malformed `settings.json` silently disables every hook in it, not just this one. Pipe-test `session-hook.ps1` directly (with and without a marker file present) before trusting it's wired correctly.

**4. Tell the user how to use it.** Once wired up: `/<slug>-on` activates the persona immediately in the current session *and* every session from now on; `/<slug>-off` reverts immediately and stays off until toggled again. Building a second persona later only repeats steps 1-2 with a new slug — step 3 is already done.
