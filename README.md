# persona-forge

A [Claude Code](https://claude.com/claude-code) skill that guides you through building a **persona / system-prompt layer** for an LLM or AI agent — through a short interactive interview, optionally inspired by a fictional character's traits — and outputs a ready-to-use `LLM-Identity.md` file.

## What it actually does

This produces a **voice and behavior layer**, not an identity transplant. It shapes tone, priorities, and decision-making style on top of whatever model runs it — it does not and cannot override that model's underlying safety training. The skill is upfront about this instead of overselling it.

Two rules keep the output usable instead of cringe:

1. **Trait extraction, not reenactment.** If you're inspired by a fictional character, the skill pulls out personality traits, voice, values, and decision habits — never lore, quotes, character names, or in-universe terminology. The persona should feel like a personality applied to your actual conversation, not a cosplay of the source material.
2. **No stage directions.** The persona speaks in first person. No `*asterisked actions*`, no narrated tone shifts.

It also recommends a **quick live test** before the full 7-section interview, so you find out in one exchange whether the direction is right instead of after a long back-and-forth.

## Persistent personas with a toggle

Beyond the one-off `LLM-Identity.md` document, you can ask for the persona to be **active by default in every Claude Code session**, switchable with a plain-language command (`/root-on`, `/root-off`, etc.) — no shell commands to remember. The skill builds the whole thing itself: the identity file, the two toggle commands, and a `SessionStart` hook that checks whether a persona is currently switched on. You only ever have to describe the persona you want; installing and wiring it up is the skill's job, not yours.

**Obsidian-ready by default.** If your `~/.claude/` directory happens to live inside an Obsidian vault (or you keep one nearby), every file this skill creates already has the frontmatter and cross-links to show up connected in your graph view instead of as orphaned notes: the identity note and its two toggle commands link to each other, tagged `persona-forge` so they're easy to find or color as a group. This costs nothing if you don't use Obsidian — it's just standard markdown either way.

## Install

Copy the whole skill folder (not just `SKILL.md` — the toggle feature needs the bundled files in `assets/`) into your Claude Code skills directory:

```
cp -r persona-forge ~/.claude/skills/persona-forge
```

Or install as part of a plugin/marketplace — see the [Claude Code skills docs](https://docs.claude.com/en/docs/claude-code) for the current mechanism.

## Use

Ask Claude Code to build a persona for an assistant, optionally naming a character or archetype to draw from:

> "I want to give my coding assistant a personality — sharp, dry humor, doesn't sugarcoat bugs."

> "Build a persona for my agent inspired by [fictional character] — the confidence and the bluntness, not the whole backstory."

> "Make this persona active by default, with an on/off toggle."

The skill will offer a quick test, then (if you want) walk through the full interview and hand you a finished `LLM-Identity.md`, including notes on how to load it depending on where you'll use it (pasted into a chat, a Claude Code `CLAUDE.md`, a Claude Code subagent, a raw API `system` param, or a custom-instructions field elsewhere) — or, if you ask, set it up as a standing persona with a slash-command toggle.

## License

MIT — see [LICENSE](LICENSE).
