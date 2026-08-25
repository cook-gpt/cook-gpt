import { execSync } from 'child_process';

function runGit(args) {
  try {
    return execSync(`git ${args}`, { encoding: 'utf8' }).trim();
  } catch {
    return null;
  }
}

function parseGithubRemote(url) {
  if (!url) return null;
  const ssh = url.match(/git@github\.com:([^/]+)\/([^/.]+?)(?:\.git)?$/);
  if (ssh) return { owner: ssh[1], repo: ssh[2] };
  const https = url.match(/github\.com[/:]([^/]+)\/([^/.]+?)(?:\.git)?$/);
  if (https) return { owner: https[1], repo: https[2] };
  return null;
}

function parseNoreplyEmail(email) {
  if (!email) return null;
  const match = email.match(/^(\d+)\+([^@]+)@users\.noreply\.github\.com$/);
  if (!match) return null;
  return { ownerId: match[1], owner: match[2] };
}

/**
 * Collect defaults from git remote, git config, and optional GitHub CLI.
 * @returns {Promise<import('./types.js').GitContext>}
 */
export async function detectGitContext() {
  const sources = [];
  const remoteUrl = runGit('remote get-url origin');
  const remote = parseGithubRemote(remoteUrl);
  if (remote) sources.push('git remote origin');

  const userName = runGit('config --get user.name');
  const userEmail = runGit('config --get user.email');
  if (userName) sources.push('git user.name');
  if (userEmail) sources.push('git user.email');

  const noreply = parseNoreplyEmail(userEmail);
  let owner = remote?.owner ?? noreply?.owner ?? null;
  let repo = remote?.repo ?? null;
  let ownerId = noreply?.ownerId ?? null;
  let displayName = userName ?? null;

  const gh = await detectGhCli();
  if (gh) {
    sources.push('GitHub CLI (gh)');
    owner = owner ?? gh.login;
    ownerId = ownerId ?? gh.id;
    displayName = displayName ?? gh.name ?? gh.login;
  }

  return {
    owner,
    repo,
    ownerId,
    displayName,
    remoteUrl,
    userEmail,
    sources: [...new Set(sources)],
  };
}

async function detectGhCli() {
  try {
    execSync('gh auth status', { stdio: 'ignore' });
  } catch {
    return null;
  }
  try {
    const login = execSync('gh api user --jq .login', { encoding: 'utf8' }).trim();
    const id = execSync('gh api user --jq .id', { encoding: 'utf8' }).trim();
    const name = execSync('gh api user --jq .name // empty', {
      encoding: 'utf8',
    }).trim();
    return { login, id, name: name || null };
  } catch {
    return null;
  }
}

export function titleCase(value) {
  return value
    .split(/[-_]/)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(' ');
}
