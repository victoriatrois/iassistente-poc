#!/usr/bin/env node

const { execSync } = require("child_process");

// Get current branch name
// Priority: environment variable (from GitHub Actions) > git command (local)
let branchName = process.env.BRANCH_NAME;
if (!branchName) {
  try {
    branchName = execSync("git rev-parse --abbrev-ref HEAD", {
      encoding: "utf-8",
    }).trim();
  } catch (error) {
    console.error("❌ Could not determine current branch");
    process.exit(1);
  }
}

// Skip validation for certain branches
if (
  branchName === "main" ||
  branchName === "master" ||
  branchName === "develop"
) {
  process.exit(0);
}

// Branch naming convention pattern:
// {branchType}/{projectName}/{categoryCode}/{issueNumber}/{description}
// Example: feat/ValidateSolution/04S1/17/document-user-id-strategy
const branchPattern =
  /^(feat|fix|docs|style|refactor|perf|test|chore)\/([a-zA-Z0-9-]+)\/([a-zA-Z0-9]+)\/(\d+)\/[a-z0-9-]+$/;

if (!branchPattern.test(branchName)) {
  console.error("\n❌ Branch name does not follow the project convention!");
  console.error(`\nCurrent branch: ${branchName}`);
  console.error("\n📋 Expected format:");
  console.error(
    "   {branchType}/{projectName}/{categoryCode}/{issueNumber}/{description}",
  );
  console.error("\n📝 Example:");
  console.error(
    "   feature/ValidateSolution/04S1/17/document-user-id-strategy",
  );
  console.error(
    '\n✅ Use "npm run branch" to create a properly formatted branch!\n',
  );
  process.exit(1);
}

console.log(`✅ Branch name is valid: ${branchName}`);
process.exit(0);
