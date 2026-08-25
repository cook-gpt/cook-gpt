import fs from 'fs';
import path from 'path';
import { success, warn } from './terminal.js';

/**
 * @param {string} root
 * @param {{ mode: 'all' | 'keep', keep?: string[] }} options
 * @returns {string[]}
 */
export function cleanupInitScripts(root, options) {
  const scriptsDir = path.join(root, 'scripts');
  if (!fs.existsSync(scriptsDir)) {
    return [];
  }

  const removed = [];

  if (options.mode === 'all') {
    fs.rmSync(scriptsDir, { recursive: true, force: true });
    removed.push('scripts/');
    return removed;
  }

  const keep = new Set(options.keep ?? []);

  for (const entry of fs.readdirSync(scriptsDir, { withFileTypes: true })) {
    if (keep.has(entry.name)) continue;

    const target = path.join(scriptsDir, entry.name);
    fs.rmSync(target, { recursive: true, force: true });
    removed.push(entry.isDirectory() ? `scripts/${entry.name}/` : `scripts/${entry.name}`);
  }

  if (fs.existsSync(scriptsDir) && fs.readdirSync(scriptsDir).length === 0) {
    fs.rmSync(scriptsDir, { recursive: true, force: true });
    removed.push('scripts/');
  }

  return removed;
}

/**
 * @param {string[]} removed
 */
export function reportCleanup(removed) {
  if (removed.length === 0) {
    warn('No init scripts to remove.');
    return;
  }

  for (const item of removed) {
    success(`Removed ${item}`);
  }
}
