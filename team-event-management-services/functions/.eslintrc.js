module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
    jest: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
    "plugin:@typescript-eslint/recommended",
    "prettier",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["tsconfig.json", "tsconfig.dev.json"],
    sourceType: "module",
    tsconfigRootDir: __dirname,
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore generated files
    "/coverage/**/*",
  ],
  plugins: ["@typescript-eslint", "import"],
  rules: {
    "quotes": ["error", "single"],
    "import/no-unresolved": 0,
    "indent": "off",
    "require-jsdoc": 0, // Disabled as it's not always needed for modern TypeScript
    "valid-jsdoc": 0,
    "max-len": ["error", { "code": 120 }],
    "@typescript-eslint/explicit-module-boundary-types": "off", // Can be enabled for stricter typing
    "@typescript-eslint/no-unused-vars": ["warn", { "argsIgnorePattern": "^_" }],
  },
};