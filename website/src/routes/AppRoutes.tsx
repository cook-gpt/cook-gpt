import { createBrowserRouter, Navigate } from 'react-router';
import App from '@/App';
import DocsPage from '@/pages/docs/DocsPage';
import HomePage from '@/pages/home/HomePage';

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
        path: '*',
        element: <Navigate to="/" replace />,
      },
    ],
  },
]);
