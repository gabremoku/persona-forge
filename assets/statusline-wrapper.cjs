#!/usr/bin/env node
/**
 * persona-forge statusline wrapper.
 *
 * Wraps whatever statusLine command was already configured (if any)
 * instead of touching it: runs the original command with the same stdin
 * it would have received, then appends a persona segment to the first
 * line of its output if a persona is active. The wrapped tool's own file
 * is never edited, so its next update has nothing of ours to overwrite.
 *
 * The original command is stored once, next to this script, in
 * .persona-statusline-wrapped.json - written by persona-forge's install
 * step, not by hand.
 */
const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

const CONFIG_FILE = path.join(__dirname, '.persona-statusline-wrapped.json');

function readStdin() {
  try {
    return fs.readFileSync(0, 'utf8');
  } catch (e) {
    return '';
  }
}

const input = readStdin();
let output = '';

if (fs.existsSync(CONFIG_FILE)) {
  try {
    const { innerCommand } = JSON.parse(fs.readFileSync(CONFIG_FILE, 'utf8'));
    if (innerCommand) {
      output = execSync(innerCommand, { input, encoding: 'utf8', maxBuffer: 10 * 1024 * 1024, shell: true });
    }
  } catch (e) {
    // The wrapped command failed - fall through with empty output rather
    // than crashing. The persona segment below still prints, so a broken
    // inner command doesn't also take the persona indicator down with it.
  }
}

try {
  const marker = path.join(os.homedir(), '.claude', '.active-persona');
  if (fs.existsSync(marker)) {
    const slug = fs.readFileSync(marker, 'utf8').trim();
    if (slug) {
      const displayName = slug.charAt(0).toUpperCase() + slug.slice(1);
      const segment = '\x1b[1;35m◆ ' + displayName + '\x1b[0m';
      if (output) {
        const lines = output.replace(/\n$/, '').split('\n');
        lines[0] = lines[0] + '  \x1b[2m│\x1b[0m  ' + segment;
        output = lines.join('\n');
      } else {
        output = segment;
      }
    }
  }
} catch (e) { /* a persona display bug must never take the statusline down */ }

process.stdout.write(output + '\n');
