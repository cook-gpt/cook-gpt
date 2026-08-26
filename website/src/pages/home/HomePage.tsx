import { useTranslation } from 'react-i18next';
import {
  BookOpen,
  CalendarDays,
  Lock,
  ShoppingCart,
  Timer,
  UtensilsCrossed,
} from 'lucide-react';
import { DownloadButton } from '@/components/DownloadButton';
import { LibraryCard } from '@/components/ui/LibraryCard';
import { Card, CardContent } from '@/components/ui/card';
import { REPO_URL } from '@/utils/releases';

const featureIcons = {
  recipes: BookOpen,
  meals: CalendarDays,
  groceries: ShoppingCart,
  timers: Timer,
  planning: UtensilsCrossed,
  privacy: Lock,
} as const;

const featureKeys = Object.keys(featureIcons) as (keyof typeof featureIcons)[];

export default function HomePage() {
  const { t } = useTranslation();

  return (
    <main className="mx-auto flex w-full max-w-5xl flex-col gap-12 pb-8">
      <section className="flex flex-col items-center gap-6 pt-4 text-center sm:pt-8">
        <span className="rounded-full border border-border bg-muted px-3 py-1 text-xs font-medium text-muted-foreground">
          {t('home.badge')}
        </span>
        <div className="space-y-4">
          <h1 className="text-3xl font-semibold tracking-tight text-balance sm:text-4xl md:text-5xl">
            {t('home.title')}
          </h1>
          <p className="mx-auto max-w-2xl text-base text-muted-foreground text-pretty sm:text-lg">
            {t('home.subtitle')}
          </p>
        </div>
        <div className="flex flex-col items-center gap-2">
          <DownloadButton size="lg" />
          <p className="text-xs text-muted-foreground">{t('download.hint')}</p>
        </div>
        <img
          src="/hero.png"
          alt={t('home.heroAlt')}
          className="w-full max-w-md rounded-2xl shadow-lg ring-1 ring-border"
        />
      </section>

      <section className="space-y-6">
        <h2 className="text-center text-xl font-semibold tracking-tight">
          {t('home.featuresTitle')}
        </h2>
        <ul className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {featureKeys.map((key) => {
            const Icon = featureIcons[key];
            return (
              <LibraryCard
                key={key}
                title={t(`home.features.${key}.title`)}
                subtitle={t(`home.features.${key}.description`)}
                content={
                  <div className="flex h-28 items-center justify-center border-b border-border bg-muted/40">
                    <Icon className="size-10 text-primary/80" aria-hidden />
                  </div>
                }
              />
            );
          })}
        </ul>
      </section>

      <section className="flex justify-center">
        <Card className="w-full max-w-md border-dashed">
          <CardContent className="flex flex-col items-center gap-3 py-6 text-center">
            <p className="text-sm text-muted-foreground">{t('home.openSource')}</p>
            <a
              href={REPO_URL}
              target="_blank"
              rel="noopener noreferrer"
              className="text-sm font-medium text-primary underline-offset-4 hover:underline"
            >
              github.com/cook-gpt/cook-gpt
            </a>
          </CardContent>
        </Card>
      </section>
    </main>
  );
}
