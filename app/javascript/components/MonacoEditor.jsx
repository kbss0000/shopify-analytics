// Monaco Editor Component for AI Studio
import React, { useEffect, useRef } from 'react';

export function MonacoEditor({ value, onChange, language = 'sql' }) {
  const containerRef = useRef(null);
  const editorRef = useRef(null);

  useEffect(() => {
    if (containerRef.current && !editorRef.current) {
      // Load Monaco Editor dynamically
      import('monaco-editor').then((monaco) => {
        editorRef.current = monaco.editor.create(containerRef.current, {
          value: value || '',
          language: language,
          theme: 'vs-dark',
          automaticLayout: true,
          minimap: { enabled: false },
          fontSize: 14,
          fontFamily: 'JetBrains Mono, monospace',
          // Akane Theme Colors
          'editor.background': '#0E1E36',
          'editor.foreground': '#F4B999',
          'editor.lineHighlightBackground': '#4A2036',
          'editor.selectionBackground': '#9279AA40',
          'editorCursor.foreground': '#9279AA',
          'editorWhitespace.foreground': '#574F72',
        });

        editorRef.current.onDidChangeModelContent(() => {
          const newValue = editorRef.current.getValue();
          onChange?.(newValue);
        });
      });
    }

    return () => {
      if (editorRef.current) {
        editorRef.current.dispose();
        editorRef.current = null;
      }
    };
  }, []);

  useEffect(() => {
    if (editorRef.current && value !== editorRef.current.getValue()) {
      editorRef.current.setValue(value || '');
    }
  }, [value]);

  return React.createElement('div', {
    ref: containerRef,
    className: "w-full h-[400px] rounded-lg border border-[#574F72]/50 overflow-hidden",
    style: { backgroundColor: '#0E1E36' }
  });
}

