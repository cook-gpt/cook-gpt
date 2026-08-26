import type { ReactNode } from 'react';
import { useTranslation } from 'react-i18next';
import {
  BookOpen,
  CalendarDays,
  ChevronRight,
  ExternalLink,
  Settings,
  ShoppingCart,
  type LucideIcon,
} from 'lucide-react';
import { DownloadButton } from '@/components/DownloadButton';
import { REPO_URL } from '@/utils/releases';
import { cn } from '@/utils/cn';

const repoDocLinks = [
  { key: 'readme', href: `${REPO_URL}#readme` },
  { key: 'contributing', href: `${REPO_URL}/blob/main/CONTRIBUTING.md` },
  { key: 'changelog', href: `${REPO_URL}/blob/main/CHANGELOG.md` },
  { key: 'security', href: `${REPO_URL}/blob/main/SECURITY.md` },
] as const;

const featureItems = [
  { key: 'recipes', icon: BookOpen },
  { key: 'meals', icon: CalendarDays },
  { key: 'groceries', icon: ShoppingCart },
  { key: 'settings', icon: Settings },
] as const satisfies ReadonlyArray<{ key: string; icon: LucideIcon }>;

function splitFeatureLabel(text: string): { title: string; description: string } {
  const separators = [' — ', ' – ', ': '];
  for (const separator of separators) {
    const index = text.indexOf(separator);
    if (index !== -1) {
      return {
        title: text.slice(0, index),
        description: text.slice(index + separator.length),
      };
    }
  }

  return { title: text, description: '' };
}

function DocsSection({
  title,
  children,
  className,
}: {
  title: string;
  children: ReactNode;
  className?: string;
}) {
  return (
    <section className={cn('docs-section', className)}>
      <h2 className="docs-section-title">{title}</h2>
      {children}
    </section>
  );
}

function NumberedSteps({ steps }: { steps: string[] }) {
  return (
    <ol className="docs-steps">
      {steps.map((step, index) => (
        <li key={step} className="docs-step">
          <span className="docs-step-number" aria-hidden>
            {index + 1}
          </span>
          <p className="docs-step-text">{step}</p>
        </li>
      ))}
    </ol>
  );
}

export default function DocsPage() {
  const { t } = useTranslation();

  const installSteps = t('docs.installSteps', { returnObjects: true }) as string[];
  const quickStartSteps = t('docs.quickStartSteps', { returnObjects: true }) as string[];

  return (
    <main className="flex flex-col">
      <section className="landing-hero">
        <div className="landing-container max-w-3xl py-12 md:py-16">
          <header className="space-y-4 border-b border-border/60 pb-8">
            <p className="landing-eyebrow">{t('docs.eyebrow')}</p>
            <h1 className="text-3xl font-semibold tracking-tight md:text-4xl">{t('docs.title')}</h1>
            <p className="max-w-2xl text-base leading-relaxed text-muted-foreground text-pretty">
              {t('docs.subtitle')}
            </p>
            <div className="flex flex-wrap items-center gap-3 pt-1">
              <DownloadButton className="rounded-full" />
              <p className="text-[11px] tracking-wide text-muted-foreground uppercase">
                {t('download.hint')}
              </p>
            </div>
          </header>

          <div className="flex flex-col">
            <DocsSection title={t('docs.installTitle')}>
              <NumberedSteps steps={installSteps} />
            </DocsSection>

            <DocsSection title={t('docs.quickStartTitle')}>
              <NumberedSteps steps={quickStartSteps} />
            </DocsSection>

            <DocsSection title={t('docs.featuresTitle')}>
              <ul className="docs-feature-grid">
                {featureItems.map(({ key, icon: Icon }) => {
                  const { title, description } = splitFeatureLabel(t(`docs.features.${key}`));

                  return (
                    <li key={key} className="docs-feature-item">
                      <div className="docs-feature-icon" aria-hidden>
                        <Icon className="size-5" strokeWidth={1.5} />
                      </div>
                      <div className="min-w-0 space-y-1">
                        <p className="text-sm font-medium tracking-tight">{title}</p>
                        {description ? (
                          <p className="text-sm leading-relaxed text-muted-foreground text-pretty">
                            {description}
                          </p>
                        ) : null}
                      </div>
                    </li>
                  );
                })}
              </ul>
            </DocsSection>

            <DocsSection title={t('docs.repoDocsTitle')} className="border-b-0">
              <p className="docs-section-lead">{t('docs.repoDocsDescription')}</p>
              <ul className="docs-link-list">
                {repoDocLinks.map(({ key, href }) => (
                  <li key={key}>
                    <a
                      href={href}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="docs-link-row"
                    >
                      <span>{t(`docs.links.${key}`)}</span>
                      <ExternalLink className="size-4 shrink-0 opacity-50" aria-hidden />
                    </a>
                  </li>
                ))}
                <li>
                  <a
                    href={REPO_URL}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="docs-link-row docs-link-row-primary"
                  >
                    <span>{t('docs.viewOnGitHub')}</span>
                    <ChevronRight className="size-4 shrink-0 opacity-60" aria-hidden />
                  </a>
                </li>
              </ul>
            </DocsSection>
          </div>
        </div>
      </section>

      <section className="landing-cta border-t border-border/60">
        <div className="landing-container flex max-w-3xl flex-col items-start gap-5 py-16 md:py-20">
          <h2 className="landing-section-title max-w-xl text-balance">{t('home.ctaTitle')}</h2>
          <p className="max-w-lg text-base text-muted-foreground text-pretty">{t('home.ctaSubtitle')}</p>
          <DownloadButton size="lg" className="rounded-full px-8" />
        </div>
      </section>
    </main>
  );
}
