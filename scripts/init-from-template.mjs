#!/usr/bin/env node

import { initFromTemplate } from './lib/template-init/index.js';
import { GITHUB_REPO_MANIFEST } from './lib/template-init/manifests/github-repo.js';
import { printHelp } from './lib/template-init/parse-args.js';
import { brandHeader, error as printError } from './lib/template-init/terminal.js';

const args = process.argv.slice(2);
if (args.includes('--help') || args.includes('-h')) {
  brandHeader('github repository template');
  printHelp('github-repo-template');
  process.exit(0);
}

initFromTemplate({
  manifest: GITHUB_REPO_MANIFEST,
  includePackageName: false,
  includeAuthorStep: true,
  includeBundler: true,
  defaultBundler: 'none',
  templateLabel: 'github repository template',
  authorStep: {
    stepTitle: 'maintainer (Git owner)',
    selectMessage: 'How should we set the repository maintainer?',
    acceptLabel: 'Accept detected Git owner',
  },
  scriptsCleanup: 'all',
  nextSteps: 'review git diff, then commit',
}).catch((err) => {
  printError(`Init failed: ${err.message}`);
  process.exit(1);
});
