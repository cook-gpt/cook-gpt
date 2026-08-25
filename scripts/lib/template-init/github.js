/**
 * @param {string} owner
 * @returns {Promise<string | null>}
 */
export async function fetchOwnerId(owner) {
  try {
    const response = await fetch(`https://api.github.com/users/${owner}`);
    if (!response.ok) return null;
    const data = await response.json();
    return data.id ? String(data.id) : null;
  } catch {
    return null;
  }
}

/**
 * @param {{ owner: string, ownerId?: string | null }} params
 */
export function buildAuthorEmail({ owner, ownerId }) {
  if (ownerId) {
    return `${ownerId}+${owner}@users.noreply.github.com`;
  }
  return `${owner}@users.noreply.github.com`;
}
