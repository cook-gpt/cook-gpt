import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { RouterProvider } from 'react-router';
import './lib/i18n';
import { ThemeProvider } from './contexts/ThemeContext';
import { appRouter } from './routes/AppRoutes';
import './styles/index.css';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <ThemeProvider>
      <RouterProvider router={appRouter} />
    </ThemeProvider>
  </StrictMode>
);
