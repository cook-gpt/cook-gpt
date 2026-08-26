import { useTranslation } from 'react-i18next';
import {
  BookOpen,
  CalendarDays,
  Lock,
  ShoppingCart,
  Timer,
  UtensilsCrossed,
  type LucideIcon,
} from 'lucide-react';
import { cn } from '@/utils/cn';

const features = [
  { key: 'recipes', icon: BookOpen },
  { key: 'meals', icon: CalendarDays },
  { key: 'groceries', icon: ShoppingCart },
  { key: 'timers', icon: Timer },
  { key: 'planning', icon: UtensilsCrossed },
  { key: 'privacy', icon: Lock },
] as const satisfies ReadonlyArray<{ key: string; icon: LucideIcon }>;

export function FeatureShowcase() {
  const { t } = useTranslation();

  return (
    <section className="landing-section" aria-labelledby="features-heading">
      <div className="landing-container space-y-4 pb-6 text-center md:pb-10">
        <p className="landing-eyebrow">{t('home.featuresEyebrow')}</p>
        <h2 id="features-heading" className="landing-section-title">
          {t('home.featuresTitle')}
        </h2>
      </div>

      <ul className="flex flex-col">
        {features.map(({ key, icon: Icon }, index) => {
          const alignEnd = index % 2 === 1;

          return (
            <li
              key={key}
              className="landing-feature-row border-t border-border/60 first:border-t-0"
            >
              <div
                className={cn(
                  'landing-container grid items-center gap-10 py-16 md:grid-cols-2 md:gap-16 md:py-24 lg:py-28',
                  alignEnd && 'md:[&>*:first-child]:order-2 md:[&>*:last-child]:order-1',
                )}
              >
                <div
                  className={cn(
                    'flex flex-col gap-4',
                    alignEnd ? 'md:items-end md:text-right' : 'md:items-start md:text-left',
                  )}
                >
                  <h3 className="landing-feature-title">{t(`home.features.${key}.title`)}</h3>
                  <p
                    className={cn(
                      'landing-feature-copy max-w-md text-pretty',
                      alignEnd && 'md:ml-auto',
                    )}
                  >
                    {t(`home.features.${key}.description`)}
                  </p>
                </div>

                <div
                  className={cn(
                    'flex justify-center',
                    alignEnd ? 'md:justify-start' : 'md:justify-end',
                  )}
                >
                  <div className="landing-feature-visual" aria-hidden>
                    <Icon className="size-12 text-foreground/70 md:size-14" strokeWidth={1.25} />
                  </div>
                </div>
              </div>
            </li>
          );
        })}
      </ul>
    </section>
  );
}
