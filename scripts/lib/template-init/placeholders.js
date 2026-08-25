import { AUTHOR_EMAIL_PLACEHOLDER } from './author.js';
import { titleCase } from './git-context.js';

const PLACEHOLDER_EMAIL = 'owner-id+owner-username@users.noreply.github.com';

/**
 * @param {import('./types.js').InitConfig} config
 * @returns {[string, string][]}
 */
export function buildReplacements(config) {
  const {
    owner,
    repo,
    packageName,
    displayName,
    email,
    authorLogin,
    authorDisplayName,
    authorEmail,
  } = config;
  const slug = `${owner}/${repo}`;
  const repoUrl = `https://github.com/${slug}`;

  const authorLoginVal = authorLogin ?? owner;
  const authorNameVal = authorDisplayName ?? displayName;
  const authorEmailVal =
    authorEmail ?? email ?? `${authorLoginVal}@users.noreply.github.com`;

  return [
    [AUTHOR_EMAIL_PLACEHOLDER, authorEmailVal],
    ['author-github-login', authorLoginVal],
    ['author-display-name', authorNameVal],
    ['https://github.com/owner-username/repo-name', repoUrl],
    ['owner-username/repo-name', slug],
    [PLACEHOLDER_EMAIL, email ?? authorEmailVal],
    ['@owner-username', `@${owner}`],
    [`@owner-username%2Fpackage-name`, `@${owner}%2F${packageName}`],
    [`%40owner-username%2Fpackage-name`, `%40${owner}%2F${packageName}`],
    ['owner-display-name', authorNameVal],
    ['repo-display-name', titleCase(repo)],
    ['package-name', packageName ?? repo],
    ['repo-name', repo],
    ['owner-username', owner],
  ];
}

/**
 * @param {string} content
 * @param {[string, string][]} replacements
 */
export function applyReplacements(content, replacements) {
  let next = content;
  for (const [from, to] of replacements) {
    next = next.split(from).join(to);
  }
  return next;
}
