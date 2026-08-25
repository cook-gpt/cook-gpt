import { brandHeader } from './terminal.js';

/**
 * @param {string[]} argv
 * @returns {import('./types.js').InitArgs}
 */
export function parseArgs(argv) {
  const args = {
    owner: null,
    repo: null,
    packageName: null,
    displayName: null,
    authorLogin: null,
    authorEmail: null,
    ownerId: null,
    bundler: null,
    yes: false,
    noCleanup: false,
  };

  for (let i = 2; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === '--yes' || arg === '-y') args.yes = true;
    else if (arg === '--owner') args.owner = argv[++i];
    else if (arg === '--repo') args.repo = argv[++i];
    else if (arg === '--package-name') args.packageName = argv[++i];
    else if (arg === '--display-name') args.displayName = argv[++i];
    else if (arg === '--author-login') args.authorLogin = argv[++i];
    else if (arg === '--author-email') args.authorEmail = argv[++i];
    else if (arg === '--owner-id') args.ownerId = String(argv[++i]);
    else if (arg === '--bundler') args.bundler = argv[++i];
    else if (arg === '--no-cleanup') args.noCleanup = true;
    else if (arg === '--help' || arg === '-h') return { ...args, help: true };
  }

  return args;
}

/**
 * @param {string} templateName
 */
export function printHelp(templateName) {
  brandHeader(templateName);
  console.log(`Usage: init ${templateName} [options]

Defaults are read from git remote, git config, and GitHub CLI (gh).
Use arrow keys to navigate menus; Enter to confirm.

Options:
  --owner <login>         GitHub username or org
  --repo <name>           Repository name
  --package-name <name>   npm package name (npm template)
  --display-name <name>   Author display name
  --author-login <login>  GitHub username for package.json author
  --author-email <email>  Author email (auto-built from GitHub id if omitted)
  --bundler <id>          npm | pnpm | yarn | bun | none
  --no-cleanup            Keep init scripts after run (debugging)
  --owner-id <id>         GitHub numeric user id (auto-fetched if omitted)
  --yes, -y               Non-interactive; use detected values only
  --help, -h              Show help
`);
}
