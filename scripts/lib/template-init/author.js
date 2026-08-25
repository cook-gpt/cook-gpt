import { fetchOwnerId, buildAuthorEmail } from './github.js';
import {
  infoPanel,
  muted,
  promptText,
  promptTextOptional,
  select,
} from './terminal.js';

const AUTHOR_EMAIL_PLACEHOLDER =
  'author-id+author-github-login@users.noreply.github.com';

/** @type {import('./types.js').AuthorStepConfig} */
export const DEFAULT_AUTHOR_STEP = {
  stepTitle: 'package.json author (Git owner)',
  panelTitle: 'Automatically detected Git owner',
  selectMessage: 'How should we set the package.json author?',
  acceptLabel: 'Accept detected Git owner',
};

/**
 * @param {import('./types.js').AuthorStepConfig} [overrides]
 * @returns {import('./types.js').AuthorStepConfig}
 */
export function resolveAuthorStepConfig(overrides = {}) {
  return { ...DEFAULT_AUTHOR_STEP, ...overrides };
}

/**
 * Build author profile from git config and GitHub CLI (personal identity).
 * @param {import('./types.js').GitContext} git
 * @returns {import('./types.js').DetectedAuthor}
 */
export function buildDetectedAuthor(git) {
  const sources = [];
  let login = null;
  let displayName = null;
  let ownerId = null;
  let email = null;

  if (git.userName) {
    displayName = git.userName;
    sources.push('git user.name');
  }

  if (git.userEmail) {
    sources.push('git user.email');
    const noreply = parseNoreplyEmail(git.userEmail);
    if (noreply) {
      login = noreply.owner;
      ownerId = noreply.ownerId;
      email = git.userEmail;
    }
  }

  if (git.ghLogin) {
    sources.push('GitHub CLI (gh)');
    login = login ?? git.ghLogin;
    ownerId = ownerId ?? git.ghId;
    displayName = displayName ?? git.ghName ?? git.ghLogin;
  }

  if (!email && login) {
    email = buildAuthorEmail({ owner: login, ownerId });
  }

  return {
    login,
    displayName,
    ownerId,
    email,
    profileUrl: login ? `https://github.com/${login}` : null,
    sources: [...new Set(sources)],
    detected: Boolean(login && displayName && email),
  };
}

/**
 * @param {string | null} email
 */
function parseNoreplyEmail(email) {
  if (!email) return null;
  const match = email.match(/^(\d+)\+([^@]+)@users\.noreply\.github\.com$/);
  if (!match) return null;
  return { ownerId: match[1], owner: match[2] };
}

/**
 * @param {import('./types.js').DetectedAuthor} detected
 * @param {import('./types.js').InitArgs} args
 * @param {import('./types.js').AuthorStepConfig} [stepConfig]
 * @returns {Promise<import('./types.js').AuthorConfig>}
 */
export async function promptAuthorStep(detected, args, stepConfig = {}) {
  const labels = resolveAuthorStepConfig(stepConfig);

  if (args.displayName || args.ownerId) {
    return resolveAuthorFromArgs(args, detected);
  }

  if (detected.detected) {
    infoPanel(labels.panelTitle, [
      { label: 'Name', value: detected.displayName ?? '' },
      { label: 'Email', value: detected.email ?? '' },
      { label: 'GitHub', value: detected.profileUrl ?? '' },
      { label: 'via', value: detected.sources.join(', ') },
    ]);

    const choice = await select({
      message: labels.selectMessage,
      choices: [
        {
          value: 'accept',
          label: labels.acceptLabel,
          hint: 'recommended',
        },
        { value: 'manual', label: 'Enter manually' },
      ],
      defaultIndex: 0,
    });

    if (choice.value === 'manual') {
      return promptManualAuthor(detected);
    }

    return authorFromDetected(detected);
  }

  muted('Could not detect Git owner from git config or GitHub CLI.\n');
  return promptManualAuthor(detected);
}

/**
 * @param {import('./types.js').DetectedAuthor} detected
 */
export function authorFromDetected(detected) {
  return {
    authorLogin: detected.login,
    authorDisplayName: detected.displayName,
    authorOwnerId: detected.ownerId,
    authorEmail: detected.email,
  };
}

/**
 * @param {import('./types.js').InitArgs} args
 * @param {import('./types.js').DetectedAuthor} detected
 */
export function resolveAuthorFromArgs(args, detected) {
  const login = args.authorLogin ?? detected.login ?? '';
  const displayName =
    args.displayName ?? detected.displayName ?? login;
  const ownerId = args.ownerId ?? detected.ownerId ?? null;
  const email =
    args.authorEmail ??
    detected.email ??
    buildAuthorEmail({ owner: login, ownerId });

  return {
    authorLogin: login,
    authorDisplayName: displayName,
    authorOwnerId: ownerId,
    authorEmail: email,
  };
}

/**
 * @param {import('./types.js').DetectedAuthor} [fallback]
 */
async function promptManualAuthor(fallback = {}) {
  const login = await promptText(
    'GitHub username (author)',
    fallback.login ?? ''
  );
  const displayName = await promptText(
    'Author display name',
    fallback.displayName ?? login
  );
  let ownerId = fallback.ownerId ?? '';
  const idAnswer = await promptTextOptional(
    'GitHub numeric user id (optional)',
    ownerId || ''
  );
  ownerId = idAnswer || ownerId || null;

  if (!ownerId) {
    ownerId = await fetchOwnerId(login);
  }

  const email = buildAuthorEmail({ owner: login, ownerId });

  return {
    authorLogin: login,
    authorDisplayName: displayName,
    authorOwnerId: ownerId,
    authorEmail: email,
  };
}

export { AUTHOR_EMAIL_PLACEHOLDER };
