import { useTranslation } from 'react-i18next';
import { GITHUB_OWNER, GITHUB_PROFILE_URL } from '@/utils/releases';

export default function PrivacyPage() {
  const { t } = useTranslation();
  const sections = t('privacy.sections', { returnObjects: true }) as Array<{
    title: string;
    body: string;
  }>;

  return (
    <main className="landing-container max-w-2xl py-12 md:py-16">
      <header className="space-y-3 border-b border-border/60 pb-8">
        <p className="landing-eyebrow">{t('privacy.eyebrow')}</p>
        <h1 className="text-3xl font-semibold tracking-tight md:text-4xl">{t('privacy.title')}</h1>
        <p className="text-sm text-muted-foreground">{t('privacy.updated')}</p>
        <p className="text-base leading-relaxed text-muted-foreground text-pretty">
          {t('privacy.intro')}
        </p>
      </header>

      <div className="space-y-10 py-10">
        {sections.map((section) => (
          <section key={section.title} className="space-y-3">
            <h2 className="text-lg font-semibold tracking-tight">{section.title}</h2>
            <p className="text-sm leading-relaxed text-muted-foreground text-pretty">{section.body}</p>
          </section>
        ))}
      </div>

      <footer className="border-t border-border/60 pt-8 text-[11px] leading-relaxed text-muted-foreground">
        <p>
          {t('privacy.contact')}{' '}
          <a
            href={GITHUB_PROFILE_URL}
            target="_blank"
            rel="noopener noreferrer"
            className="text-foreground underline-offset-4 hover:underline"
          >
            @{GITHUB_OWNER}
          </a>
        </p>
      </footer>
    </main>
  );
}
