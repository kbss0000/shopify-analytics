// React App Entry Point
import React from 'react';
import { createRoot } from 'react-dom/client';
import { Dashboard } from './components/Dashboard';
import { MonacoEditor } from './components/MonacoEditor';
import { ShopifyConnectionForm } from './components/FormWithValidation';

// Initialize React components when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  // Dashboard React Component
  const dashboardContainer = document.getElementById('react-dashboard');
  if (dashboardContainer) {
    const root = createRoot(dashboardContainer);
    const stats = JSON.parse(dashboardContainer.dataset.stats || '{}');
    root.render(React.createElement(Dashboard, { stats }));
  }

  // Monaco Editor for AI Studio
  const editorContainer = document.getElementById('react-monaco-editor');
  if (editorContainer) {
    const root = createRoot(editorContainer);
    root.render(React.createElement(MonacoEditor, {
      value: editorContainer.dataset.value || '',
      onChange: (value) => {
        const hiddenInput = document.getElementById('sql-query');
        if (hiddenInput) hiddenInput.value = value;
      },
      language: editorContainer.dataset.language || 'sql',
    }));
  }

  // Shopify Connection Form
  const formContainer = document.getElementById('react-shopify-form');
  if (formContainer) {
    const root = createRoot(formContainer);
    root.render(React.createElement(ShopifyConnectionForm, {
      onSubmit: async (data) => {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = formContainer.dataset.action || '/shopify/onboarding';
        
        Object.entries(data).forEach(([key, value]) => {
          const input = document.createElement('input');
          input.type = 'hidden';
          input.name = `tenant[${key}]`;
          input.value = value;
          form.appendChild(input);
        });
        
        const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
        if (csrfToken) {
          const csrfInput = document.createElement('input');
          csrfInput.type = 'hidden';
          csrfInput.name = 'authenticity_token';
          csrfInput.value = csrfToken;
          form.appendChild(csrfInput);
        }
        
        document.body.appendChild(form);
        form.submit();
      },
    }));
  }
});


