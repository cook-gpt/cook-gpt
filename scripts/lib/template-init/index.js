import fs from 'fs';
import path from 'path';
import { detectGitContext } from './git-context.js';
import { fetchOwnerId, buildAuthorEmail } from './github.js';
import {
  applyBundlerToDependabot,
  detectBundlerFromLockfile,
  getBundler,
} from './bundlers.js';
import { buildReplacements } from './placeholders.js';
import { copyFromManifest } from './copy.js';
import { resolveConfigInteractive } from './prompts.js';
import { parseArgs, printHelp } from './parse-args.js';
import { brand, section, success, muted } from './terminal.js';
import { cleanupInitScripts, reportCleanup } from './cleanup.js';

export { detectGitContext, buildReplacements, copyFromManifest };
export { BUNDLER_OPTIONS } from './bundlers.js';

/**
 * Exportable entry for a future @open-templates/template-init package.
 * @param {import('./types.js').TemplateInitOptions} options
 */
export async function initFromTemplate(options) {
  const {
    root = process.cwd(),
    templatesDir = 'templates',
    manifest,
    args: rawArgs = {},
    includePackageName = false,
    includeAuthorStep = false,
    includeBundler = false,
    defaultBundler = 'npm',
    nextSteps = 'review git diff, then commit',
    templateLabel = 'template init',
    authorStep = {},
    scriptsCleanup = false,
    scriptsKeep = [],
  } = options;

  const args = { ...parseArgs(process.argv), ...rawArgs };
  if (args.help) {
    printHelp(path.basename(root));
    process.exit(0);
  }

  const git = await detectGitContext();

  let detectedBundler = defaultBundler;
  if (includeBundler) {
    detectedBundler =
      detectBundlerFromLockfile(
        ['bun.lock', 'pnpm-lock.yaml', 'yarn.lock', 'package-lock.json']
          .filter((f) => fs.existsSync(path.join(root, f)))
          .join(' ')
      ) ?? defaultBundler;
  }

  const partial = await resolveConfigInteractive(git, args, {
    includePackageName,
    includeAuthorStep,
    includeBundler,
    defaultBundler: detectedBundler,
    templateLabel,
    authorStep,
  });

  let authorOwnerId =
    partial.authorOwnerId ?? args.ownerId ?? git.ownerId ?? null;
  if (includeAuthorStep && partial.authorLogin && !authorOwnerId) {
    authorOwnerId = await fetchOwnerId(partial.authorLogin);
  }

  const authorEmail =
    partial.authorEmail ??
    buildAuthorEmail({
      owner: partial.authorLogin ?? partial.owner,
      ownerId: authorOwnerId,
    });

  let ownerId = args.ownerId ?? git.ownerId ?? null;
  if (!ownerId) {
    ownerId = await fetchOwnerId(partial.owner);
  }

  const config = {
    ...partial,
    authorOwnerId,
    authorEmail,
    authorLogin: partial.authorLogin ?? partial.owner,
    authorDisplayName: partial.authorDisplayName ?? partial.displayName,
    ownerId,
    email: buildAuthorEmail({ owner: partial.owner, ownerId }),
  };

  const replacements = buildReplacements(config);
  const bundler = getBundler(config.bundler ?? defaultBundler);

  const transform = (content, fromRel) => {
    if (fromRel === 'dependabot.yml' && includeBundler) {
      return applyBundlerToDependabot(content, bundler);
    }
    return content;
  };

  section(`Copying templates · ${brand()}`);

  const copied = copyFromManifest({
    root,
    templatesDir,
    manifest,
    replacements,
    transform,
  });

  console.log('');
  success(`Copied ${copied.length} file(s) from ${templatesDir}/.`);

  if (scriptsCleanup && !args.noCleanup) {
    section(`Cleaning up init scripts · ${brand()}`);
    const removed = cleanupInitScripts(root, {
      mode: scriptsCleanup,
      keep: scriptsKeep,
    });
    reportCleanup(removed);
    console.log('');
  }

  muted(`Next: ${nextSteps}`);

  return { config, copied };
}
