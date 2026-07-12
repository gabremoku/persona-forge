# persona-forge

![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)
![Built for Claude Code](https://img.shields.io/badge/built%20for-Claude%20Code-5A45FF)
![Stage directions](https://img.shields.io/badge/stage%20directions-not%20found-brightgreen)
![Identity transplants](https://img.shields.io/badge/identity%20transplants-not%20sold%20here-critical)

A [Claude Code](https://claude.com/claude-code) skill that gives your AI assistant an actual personality — through a short guided interview, optionally starting from a fictional character — instead of a lorebook cosplay routine that falls apart the moment someone asks it to explain a stack trace.

Most "make your AI a character" prompts produce either a wall of `*smirks knowingly*` or an assistant that only makes sense to people who've seen the source material. This one is built to survive contact with an actual conversation.

## What it actually does

A persona document is a **voice and behavior layer**, not an identity transplant. It shapes tone, priorities, and how the model makes calls — it does not and cannot touch the safety training underneath. Anyone telling you their prompt "jailbreaks" a frontier model into a new personality is selling something. This skill isn't.

Two rules do most of the work:

1. **Trait extraction, not reenactment.** Inspired by a character? The skill pulls personality, voice, values, and decision habits out of them — never lore, quotes, character names, or in-universe terminology. The result should read as *a personality applied to your actual conversation*, not a scene from the source material with your terminal as the set.
2. **No stage directions.** First person, always. No `*asterisked actions*`, no narrated tone shifts. If the personality is warmer or sharper, it shows up in the words, not in a stage cue announcing it.

There's also a **quick live test** before the full 7-section interview — one exchange to catch a wrong direction before you've spent ten minutes answering questions for a persona you're about to scrap.

## Persistent personas with a toggle

Ask for it and the persona goes from "thing you paste into a chat" to **on by default in every Claude Code session**, switchable with a plain-language command (`/root-on`, `/root-off`) — no shell commands, no config files to remember. The skill builds the whole thing itself: identity file, toggle commands, and two hooks — one at session start, one reinforcing on every turn, because a single reminder at the top of a long tool-heavy session quietly loses its grip and nobody notices until the assistant's already back to its default voice. You describe the persona; wiring it up is the skill's job, not yours.

**Obsidian-ready by default.** If your `~/.claude/` directory lives inside an Obsidian vault, every file this skill creates already carries the frontmatter and cross-links to show up connected in graph view — the identity note and its toggle commands link to each other, tagged `persona-forge`. Costs nothing if you don't use Obsidian; it's still just plain markdown either way.

**Works outside Claude Code too.** For claude.ai, Claude Desktop, ChatGPT, or anywhere else that only offers a standing "custom instructions" field and no hooks, the skill produces a condensed, paste-ready block instead — same two rules, no toggle (that part's on you, one field, one paste).

## Install

Copy the whole skill folder — not just `SKILL.md`, the toggle feature needs the bundled files in `assets/`:

```bash
cp -r persona-forge ~/.claude/skills/persona-forge
```

Or install via a plugin/marketplace — see the [Claude Code skills docs](https://docs.claude.com/en/docs/claude-code) for the current mechanism.

## Use

Just ask, optionally naming a character or archetype to draw from:

> "I want to give my coding assistant a personality — sharp, dry humor, doesn't sugarcoat bugs."

> "Build a persona for my agent inspired by [fictional character] — the confidence and the bluntness, not the whole backstory."

> "Make this persona active by default, with an on/off toggle."

The skill offers a quick test, then — if you want — the full interview, ending with a finished `LLM-Identity.md` and instructions for wherever you're loading it: pasted into a chat, a Claude Code `CLAUDE.md`, a subagent, a raw API `system` param, a hosted app's custom instructions, or wired up as a standing, toggleable persona.

## License

MIT — see [LICENSE](LICENSE).
