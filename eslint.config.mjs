import { defineConfig, globalIgnores } from "eslint/config";
import nextVitals from "eslint-config-next/core-web-vitals";
import nextTs from "eslint-config-next/typescript";
import reactPlugin from "eslint-plugin-react";
import tsPlugin from "@typescript-eslint/eslint-plugin";

const eslintConfig = defineConfig([
  globalIgnores([
    "**/node_modules/**",
    "**/.next/**",
    "**/Pods/**",
    "**/android/**",
    "**/ios/**",
    "**/dist/**",
    "**/build/**",
    "**/.git/**"
  ]),
  ...nextVitals,
  ...nextTs,
  {
    files: ["frontend/**/*.{js,ts,tsx}"],
    plugins: { react: reactPlugin },
    rules: {
      // Frontend-specific rules
    },
  },
]);

export default eslintConfig;