/**
 * Feature showcase screenshots live in `website/public/`.
 *
 * Naming (one pair per feature key):
 *   feature-{key}-light.png
 *   feature-{key}-dark.png
 *
 * Examples:
 *   feature-recipes-light.png
 *   feature-recipes-dark.png
 *
 * Keys: recipes | meals | groceries | timers | planning | editable-recipes
 *
 * Recommended: square 1:1 crops of iPhone captures (e.g. 1200×1200 px).
 * Leave a little margin at the top/bottom — the site fades and blurs those edges.
 */
export const FEATURE_SHOWCASE_KEYS = [
  'recipes',
  'meals',
  'groceries',
  'timers',
  'planning',
  'editable-recipes',
] as const;

export type FeatureShowcaseKey = (typeof FEATURE_SHOWCASE_KEYS)[number];

export function featureShowcaseImageSrc(key: FeatureShowcaseKey, theme: 'light' | 'dark') {
  return `/feature-${key}-${theme}.png`;
}

function probeImage(src: string): Promise<boolean> {
  return new Promise((resolve) => {
    const image = new Image();
    image.onload = () => resolve(true);
    image.onerror = () => resolve(false);
    image.src = src;
  });
}

export async function probeFeatureShowcaseImages(key: FeatureShowcaseKey) {
  const lightSrc = featureShowcaseImageSrc(key, 'light');
  const darkSrc = featureShowcaseImageSrc(key, 'dark');
  const [hasLight, hasDark] = await Promise.all([probeImage(lightSrc), probeImage(darkSrc)]);

  return { hasLight, hasDark, lightSrc, darkSrc };
}
