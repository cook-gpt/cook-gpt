import { useTranslation } from 'react-i18next';
import { DownloadButton } from '@/components/DownloadButton';
import { FeatureShowcase } from '@/components/FeatureShowcase';
import { ScreenshotCarousel } from '@/components/ScreenshotCarousel';

export default function HomePage() {
  const { t } = useTranslation();

  return (
    <main className="flex flex-col">
      <section className="landing-hero">
        <div className="landing-container flex flex-col items-center gap-8 pt-10 text-center sm:pt-14 md:pt-20">
          <p className="landing-eyebrow">{t('home.badge')}</p>
          <div className="space-y-5">
            <h1 className="landing-hero-title text-balance">{t('home.title')}</h1>
            <p className="landing-hero-subtitle mx-auto max-w-2xl text-pretty">
              {t('home.subtitle')}
            </p>
          </div>
          <div className="flex flex-col items-center gap-2">
            <DownloadButton size="lg" className="rounded-full px-8" />
            <p className="text-[11px] tracking-wide text-muted-foreground uppercase">
              {t('download.hint')}
            </p>
          </div>
        </div>

        <div className="landing-container flex justify-center pb-4 pt-10 md:pb-8 md:pt-14">
          <ScreenshotCarousel />
        </div>
      </section>

      <FeatureShowcase />

      <section className="landing-cta border-t border-border/60">
        <div className="landing-container flex flex-col items-center gap-5 py-20 text-center md:py-28">
          <h2 className="landing-section-title max-w-2xl text-balance">{t('home.ctaTitle')}</h2>
          <p className="max-w-lg text-base text-muted-foreground text-pretty">{t('home.ctaSubtitle')}</p>
          <DownloadButton size="lg" className="rounded-full px-8" />
        </div>
      </section>
    </main>
  );
}
