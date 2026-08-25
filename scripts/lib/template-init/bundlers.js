/** @typedef {{ id: string, label: string, dependabotEcosystem: string | null }} BundlerOption */

/** @type {BundlerOption[]} */
export const BUNDLER_OPTIONS = [
  { id: 'npm', label: 'npm', dependabotEcosystem: 'npm' },
  { id: 'pnpm', label: 'pnpm', dependabotEcosystem: 'npm' },
  { id: 'yarn', label: 'Yarn', dependabotEcosystem: 'npm' },
  { id: 'bun', label: 'Bun', dependabotEcosystem: 'bun' },
  {
    id: 'none',
    label: 'None (GitHub Actions updates only)',
    dependabotEcosystem: null,
  },
];

/**
 * @param {string} id
 * @returns {BundlerOption}
 */
export function getBundler(id) {
  return BUNDLER_OPTIONS.find((b) => b.id === id) ?? BUNDLER_OPTIONS[0];
}

/**
 * @param {string} content
 * @param {BundlerOption} bundler
 */
export function applyBundlerToDependabot(content, bundler) {
  if (bundler.dependabotEcosystem) {
    return content.replace(/package-bundler/g, bundler.dependabotEcosystem);
  }
  return content.replace(
    /\n  - package-ecosystem: "?package-bundler"?[\s\S]*?(?=\n  - package-ecosystem: "?github-actions"?)/,
    ''
  );
}

/**
 * @param {string} [lockfile]
 */
export function detectBundlerFromLockfile(lockfile) {
  if (!lockfile) return null;
  if (lockfile.includes('bun.lock')) return 'bun';
  if (lockfile.includes('pnpm-lock.yaml')) return 'pnpm';
  if (lockfile.includes('yarn.lock')) return 'yarn';
  if (lockfile.includes('package-lock.json')) return 'npm';
  return null;
}
