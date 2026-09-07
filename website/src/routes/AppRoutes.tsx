import { createBrowserRouter, Navigate } from 'react-router';
import App from '@/App';
import DocsPage from '@/pages/docs/DocsPage';
import ContactPage from '@/pages/contact/ContactPage';
import HomePage from '@/pages/home/HomePage';
import PrivacyPage from '@/pages/privacy/PrivacyPage';

export const appRouter = createBrowserRouter([
  {
    path: '/',
    element: <App />,
    children: [
      {
        index: true,
        element: <HomePage />,
      },
      {
        path: 'docs',
        element: <DocsPage />,
      },
      {
        path: 'contact',
        element: <ContactPage />,
      },
      {
        path: 'privacy',
        element: <PrivacyPage />,
      },
      {
        path: '*',
        element: <Navigate to="/" replace />,
      },
    ],
  },
]);
