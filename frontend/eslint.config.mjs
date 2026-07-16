import js from '@eslint/js';

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
    rules: {
      // React Native and general rules
      'no-unused-vars': 'warn',
    },
  },
];
