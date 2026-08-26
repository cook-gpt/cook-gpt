import { useEffect, useState } from 'react';
import type { LucideIcon } from 'lucide-react';
import { useTheme } from '@/contexts/ThemeContext';
import {
  probeFeatureShowcaseImages,
  type FeatureShowcaseKey,
} from '@/utils/featureShowcaseAssets';

type LoadState =
  | { status: 'loading' }
  | { status: 'missing' }
  | {
      status: 'ready';
      lightSrc: string;
      darkSrc: string;
      hasLight: boolean;
      hasDark: boolean;
    };

type FeatureShowcaseVisualProps = {
  featureKey: FeatureShowcaseKey;
  icon: LucideIcon;
  alt: string;
};

export function FeatureShowcaseVisual({ featureKey, icon: Icon, alt }: FeatureShowcaseVisualProps) {
  const { darkMode } = useTheme();
  const [loadState, setLoadState] = useState<LoadState>({ status: 'loading' });

  useEffect(() => {
    let cancelled = false;

    probeFeatureShowcaseImages(featureKey).then(({ hasLight, hasDark, lightSrc, darkSrc }) => {
      if (cancelled) return;

      if (!hasLight && !hasDark) {
        setLoadState({ status: 'missing' });
        return;
      }

      setLoadState({
        status: 'ready',
        lightSrc,
        darkSrc,
        hasLight,
        hasDark,
      });
    });

    return () => {
      cancelled = true;
    };
  }, [featureKey]);

  if (loadState.status !== 'ready') {
    return (
      <div className="landing-feature-visual" aria-hidden={loadState.status === 'loading'}>
        <Icon className="size-12 text-foreground/70 md:size-14" strokeWidth={1.25} />
      </div>
    );
  }

  const { lightSrc, darkSrc, hasLight, hasDark } = loadState;
  const src = darkMode
    ? hasDark
      ? darkSrc
      : lightSrc
    : hasLight
      ? lightSrc
      : darkSrc;

  return (
    <div className="landing-feature-screenshot">
      <img
        src={src}
        alt={alt}
        className="landing-feature-screenshot__image"
        loading="lazy"
        decoding="async"
        draggable={false}
      />
      <div className="landing-feature-screenshot__fade landing-feature-screenshot__fade--top" />
      <div className="landing-feature-screenshot__fade landing-feature-screenshot__fade--bottom" />
    </div>
  );
}
