import { useTranslation } from 'react-i18next';
import { Moon, Sun } from 'lucide-react';
import { Link, useLocation } from 'react-router';
import { Button } from '@/components/ui/button';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from '@/components/ui/tooltip';
import { cn } from '@/utils/cn';
import { APP_NAME_SHORT } from '@/utils/releases';

const LANGUAGES = [
  { value: 'en', label: 'EN' },
  { value: 'es', label: 'ES' },
  { value: 'fr', label: 'FR' },
  { value: 'de', label: 'DE' },
  { value: 'it', label: 'IT' },
  { value: 'nl', label: 'NL' },
  { value: 'ca', label: 'CA' },
  { value: 'ru', label: 'RU' },
  { value: 'zh', label: 'ZH' },
] as const;

type SupportedLang = (typeof LANGUAGES)[number]['value'];
const SUPPORTED_VALUES = new Set<SupportedLang>(LANGUAGES.map((l) => l.value));

function normalizeLanguage(lang: string): SupportedLang {
  if (SUPPORTED_VALUES.has(lang as SupportedLang)) return lang as SupportedLang;
  const base = lang.split('-')[0] as SupportedLang;
  return SUPPORTED_VALUES.has(base) ? base : 'en';
}

interface AppHeaderProps {
  language: string;
  onLanguageChange: (lang: string) => void;
  darkMode: boolean;
  onThemeToggle: () => void;
}

export function AppHeader({
  language,
  onLanguageChange,
  darkMode,
  onThemeToggle,
}: AppHeaderProps) {
  const { t } = useTranslation();
  const location = useLocation();

  const navRoutes = [
    { path: '/', label: t('nav.home') },
    { path: '/docs', label: t('nav.docs') },
    { path: '/privacy', label: t('nav.privacy') },
  ];

  return (
    <header className="sticky top-0 z-50 border-b border-border/50 bg-background/75 backdrop-blur-xl backdrop-saturate-150">
      <div className="landing-container flex h-12 items-center justify-between md:h-14">
        <Link
          to="/"
          className="text-sm font-semibold tracking-tight text-foreground transition-opacity hover:opacity-70"
        >
          {APP_NAME_SHORT}
        </Link>

        <nav className="absolute left-1/2 hidden -translate-x-1/2 items-center gap-6 md:flex">
          {navRoutes.map(({ path, label }) => {
            const isActive = location.pathname === path;
            return (
              <Link
                key={path}
                to={path}
                className={cn(
                  'text-[11px] tracking-wide text-muted-foreground uppercase transition-colors hover:text-foreground',
                  isActive && 'text-foreground',
                )}
              >
                {label}
              </Link>
            );
          })}
        </nav>

        <div className="flex items-center gap-1">
          <nav className="flex items-center gap-1 md:hidden">
            {navRoutes.map(({ path, label }) => {
              const isActive = location.pathname === path;
              return (
                <Button
                  key={path}
                  asChild
                  variant={isActive ? 'secondary' : 'ghost'}
                  size="sm"
                  className="h-8 px-2.5 text-[11px] uppercase"
                >
                  <Link to={path}>{label}</Link>
                </Button>
              );
            })}
          </nav>

          <Select value={normalizeLanguage(language)} onValueChange={onLanguageChange}>
            <SelectTrigger
              className="h-8 w-[68px] border-0 bg-transparent text-[11px] text-foreground shadow-none hover:bg-secondary/60"
              aria-label={t('language')}
            >
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {LANGUAGES.map(({ value, label }) => (
                <SelectItem key={value} value={value}>
                  {label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>

          <Tooltip>
            <TooltipTrigger asChild>
              <Button
                variant="ghost"
                size="icon"
                onClick={onThemeToggle}
                aria-label={darkMode ? t('actions.lightMode') : t('actions.darkMode')}
                className="size-8"
              >
                {darkMode ? <Sun className="size-4" /> : <Moon className="size-4" />}
              </Button>
            </TooltipTrigger>
            <TooltipContent side="bottom">
              {darkMode ? t('actions.lightMode') : t('actions.darkMode')}
            </TooltipContent>
          </Tooltip>
        </div>
      </div>
    </header>
  );
}
