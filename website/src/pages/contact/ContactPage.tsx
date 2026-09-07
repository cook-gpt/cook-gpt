import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { CheckCircle2, Loader2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { GITHUB_OWNER, GITHUB_PROFILE_URL } from '@/utils/releases';

type FormStatus = 'idle' | 'submitting' | 'success';

const SUBMIT_DELAY_MS = 1200;

export default function ContactPage() {
  const { t } = useTranslation();
  const [status, setStatus] = useState<FormStatus>('idle');
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [subject, setSubject] = useState('');
  const [message, setMessage] = useState('');

  const topics = t('contact.topics.items', { returnObjects: true }) as string[];

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setStatus('submitting');
    await new Promise((resolve) => setTimeout(resolve, SUBMIT_DELAY_MS));
    setStatus('success');
  }

  function handleReset() {
    setName('');
    setEmail('');
    setSubject('');
    setMessage('');
    setStatus('idle');
  }

  return (
    <main className="landing-container max-w-2xl py-12 md:py-16">
      <header className="space-y-3 border-b border-border/60 pb-8">
        <p className="landing-eyebrow">{t('contact.eyebrow')}</p>
        <h1 className="text-3xl font-semibold tracking-tight md:text-4xl">{t('contact.title')}</h1>
        <p className="text-base leading-relaxed text-muted-foreground text-pretty">
          {t('contact.intro')}
        </p>
      </header>

      <section className="space-y-3 py-8">
        <h2 className="text-lg font-semibold tracking-tight">{t('contact.topics.title')}</h2>
        <ul className="list-disc space-y-2 pl-5 text-sm leading-relaxed text-muted-foreground">
          {topics.map((item) => (
            <li key={item}>{item}</li>
          ))}
        </ul>
      </section>

      {status === 'success' ? (
        <Card className="border-border/70">
          <CardHeader className="items-center text-center">
            <div className="mb-2 flex size-12 items-center justify-center rounded-full bg-green-500/10 text-green-600 dark:text-green-400">
              <CheckCircle2 className="size-6" aria-hidden />
            </div>
            <CardTitle>{t('contact.success.title')}</CardTitle>
            <CardDescription className="text-pretty">{t('contact.success.body')}</CardDescription>
          </CardHeader>
          <CardContent className="flex justify-center pb-2">
            <Button type="button" variant="outline" onClick={handleReset}>
              {t('contact.success.sendAnother')}
            </Button>
          </CardContent>
        </Card>
      ) : (
        <Card className="border-border/70">
          <CardHeader>
            <CardTitle className="text-lg">{t('contact.form.heading')}</CardTitle>
            <CardDescription>{t('contact.form.required')}</CardDescription>
          </CardHeader>
          <CardContent>
            <form className="space-y-5" onSubmit={handleSubmit} noValidate>
              <div className="space-y-2">
                <Label htmlFor="contact-name">{t('contact.form.name')}</Label>
                <Input
                  id="contact-name"
                  name="name"
                  type="text"
                  autoComplete="name"
                  required
                  value={name}
                  onChange={(event) => setName(event.target.value)}
                  placeholder={t('contact.form.namePlaceholder')}
                  disabled={status === 'submitting'}
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="contact-email">{t('contact.form.email')}</Label>
                <Input
                  id="contact-email"
                  name="email"
                  type="email"
                  autoComplete="email"
                  required
                  value={email}
                  onChange={(event) => setEmail(event.target.value)}
                  placeholder={t('contact.form.emailPlaceholder')}
                  disabled={status === 'submitting'}
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="contact-subject">{t('contact.form.subject')}</Label>
                <Input
                  id="contact-subject"
                  name="subject"
                  type="text"
                  required
                  value={subject}
                  onChange={(event) => setSubject(event.target.value)}
                  placeholder={t('contact.form.subjectPlaceholder')}
                  disabled={status === 'submitting'}
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="contact-message">{t('contact.form.message')}</Label>
                <Textarea
                  id="contact-message"
                  name="message"
                  required
                  rows={6}
                  value={message}
                  onChange={(event) => setMessage(event.target.value)}
                  placeholder={t('contact.form.messagePlaceholder')}
                  disabled={status === 'submitting'}
                />
              </div>

              <Button type="submit" className="w-full sm:w-auto" disabled={status === 'submitting'}>
                {status === 'submitting' ? (
                  <>
                    <Loader2 className="size-4 animate-spin" aria-hidden />
                    {t('contact.form.submitting')}
                  </>
                ) : (
                  t('contact.form.submit')
                )}
              </Button>
            </form>
          </CardContent>
        </Card>
      )}

      <footer className="mt-10 border-t border-border/60 pt-8 text-[11px] leading-relaxed text-muted-foreground">
        <p>
          {t('contact.alternative')}{' '}
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
