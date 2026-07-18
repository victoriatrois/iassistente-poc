module.exports = {
  extends: '@react-native',
  ignorePatterns: [
    'node_modules',
    'Pods',
    'android',
    'ios',
    'dist',
    'build',
    '.git',
  ],
  overrides: [
    {
      files: ['metro.config.js', 'babel.config.js', '.eslintrc.js'],
      rules: {
        '@typescript-eslint/no-require-imports': 'off',
      },
    },
  ],
};
