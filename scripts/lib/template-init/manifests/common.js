/**
 * Shared manifest entries for every @open-templates repository.
 * Synced to each template repo via specs/scripts/sync-shared.mjs
 *
 * @type {[string, string][]}
 */
export const COMMON_MANIFEST = [
  ['INSTRUCTIONS.md', 'INSTRUCTIONS.md'],
  ['LICENSE', 'LICENSE'],
  ['CHANGELOG.md', 'CHANGELOG.md'],
  ['CONTRIBUTING.md', 'CONTRIBUTING.md'],
  ['SECURITY.md', 'SECURITY.md'],
  ['CODE_OF_CONDUCT.md', 'CODE_OF_CONDUCT.md'],
  ['gitignore', '.gitignore'],
  ['dependabot.yml', '.github/dependabot.yml'],
  ['CODEOWNERS', '.github/CODEOWNERS'],
];
