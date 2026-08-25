import fs from 'fs';
import path from 'path';
import { applyReplacements } from './placeholders.js';
import { copyLine, warn } from './terminal.js';

/**
 * @param {object} params
 * @param {string} params.root
 * @param {string} params.templatesDir
 * @param {[string, string][]} params.manifest
 * @param {[string, string][]} params.replacements
 * @param {(content: string, fromRel: string, toRel: string) => string} [params.transform]
 */
export function copyFromManifest({
  root,
  templatesDir,
  manifest,
  replacements,
  transform,
}) {
  const copied = [];

  for (const [fromRel, toRel] of manifest) {
    const src = path.join(root, templatesDir, fromRel);
    const dest = path.join(root, toRel);

    if (!fs.existsSync(src)) {
      warn(`Skipped missing template: ${templatesDir}/${fromRel}`);
      continue;
    }

    let content = fs.readFileSync(src, 'utf8');
    content = applyReplacements(content, replacements);
    if (transform) {
      content = transform(content, fromRel, toRel);
    }

    fs.mkdirSync(path.dirname(dest), { recursive: true });
    fs.writeFileSync(dest, content, 'utf8');
    copied.push({ from: `${templatesDir}/${fromRel}`, to: toRel });
    copyLine(`${templatesDir}/${fromRel}`, toRel);
  }

  return copied;
}
