import { useTranslation } from 'react-i18next';
import { Outlet } from 'react-router';
import { AppHeader } from '@/components/AppHeader';
import { SiteFooter } from '@/components/SiteFooter';
import { TooltipProvider } from '@/components/ui/tooltip';
import { useTheme } from '@/contexts/ThemeContext';

export default function App() {
  const { i18n } = useTranslation();
  const { darkMode, toggleTheme } = useTheme();

  return (
    <TooltipProvider>
      <div className="flex min-h-screen flex-col bg-background">
        <AppHeader
          language={i18n.language || 'en'}
          onLanguageChange={(value) => i18n.changeLanguage(value)}
          darkMode={darkMode}
          onThemeToggle={toggleTheme}
        />
        <div className="flex flex-1 flex-col">
          <Outlet />
        </div>
        <SiteFooter />
      </div>
    </TooltipProvider>
  );
}
