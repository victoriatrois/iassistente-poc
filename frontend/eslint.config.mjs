import js from '@eslint/js';
import reactPlugin from 'eslint-plugin-react';

export default [
  {
    ignores: [
      'node_modules/**',
      'Pods/**',
      'android/**',
      'ios/**',
      'dist/**',
      'build/**',
      '.git/**',
    ],
  },
  {
    files: ['**/*.{js,jsx,ts,tsx}'],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: 'module',
      parserOptions: {
        ecmaFeatures: {
          jsx: true,
        },
      },
    },
    plugins: {
      react: reactPlugin,
    },
    rules: {
      // React Native and general rules
      'no-unused-vars': 'warn',
      'react/jsx-uses-vars': 'warn',
    },
  },
];
