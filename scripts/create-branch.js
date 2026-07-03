#!/usr/bin/env node

const { execSync } = require('child_process');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

const branchTypes = [
  'feat',
  'fix',
  'docs',
  'style',
  'refactor',
  'perf',
  'test',
  'build',
  'dependencies',
  'ci',
  'chore',
  'revert',
];

function question(prompt) {
  return new Promise((resolve) => {
    rl.question(prompt, resolve);
  });
}

async function getGitHubRepoInfo() {
  try {
    const remoteUrl = execSync('git remote get-url origin', { encoding: 'utf-8' }).trim();
    const match = remoteUrl.match(/github\.com[:/]([^/]+)\/([^/]+?)(\.git)?$/);
    if (match) {
      return { owner: match[1], repo: match[2] };
    }
  } catch (error) {
    // Silently fail, will ask user instead
  }
  return null;
}

async function fetchGitHubIssue(owner, repo, issueNumber, token) {
  const url = `https://api.github.com/repos/${owner}/${repo}/issues/${issueNumber}`;
  const headers = {
    'Accept': 'application/vnd.github.v3+json',
    ...(token && { 'Authorization': `token ${token}` }),
  };

  const response = await fetch(url, { headers });
  if (!response.ok) {
    throw new Error(`GitHub API error: ${response.status} ${response.statusText}`);
  }
  return response.json();
}

function extractCategoryCode(title) {
  // Extract [XX.X] or [XX] pattern from title
  const match = title.match(/\[([^\]]+)\]/);
  if (match) {
    // Remove dots from the category code (e.g., "04S.1" -> "04S1")
    return match[1].replace(/\./g, '');
  }
  return null;
}

function cleanTitleForBranch(title) {
  // Remove category code from title
  let cleaned = title.replace(/^\s*\[[^\]]+\]\s*/, '');
  // Convert to lowercase, replace spaces with hyphens, remove special chars
  cleaned = cleaned.toLowerCase().replace(/\s+/g, '-').replace(/[^\w-]/g, '');
  return cleaned;
}

async function createBranch() {
  console.log('\n🌿 Branch Creator\n');

  // Show available types
  console.log('Available branch types:');
  branchTypes.forEach((type, index) => {
    console.log(`  ${index + 1}. ${type}`);
  });

  // Get branch type
  const typeChoice = await question('\nSelect branch type (number or name): ');
  let branchType = typeChoice.toLowerCase().trim();

  // Validate type
  if (isNaN(typeChoice)) {
    if (!branchTypes.includes(branchType)) {
      console.error('❌ Invalid branch type');
      rl.close();
      process.exit(1);
    }
  } else {
    const index = parseInt(typeChoice) - 1;
    if (index < 0 || index >= branchTypes.length) {
      console.error('❌ Invalid selection');
      rl.close();
      process.exit(1);
    }
    branchType = branchTypes[index];
  }

  // Get issue number
  const issueNumberInput = await question('\nEnter GitHub issue number (e.g., 17): ');
  if (!issueNumberInput.trim()) {
    console.error('❌ Issue number is required');
    rl.close();
    process.exit(1);
  }

  if (!/^\d+$/.test(issueNumberInput.trim())) {
    console.error('❌ Issue number must be numeric');
    rl.close();
    process.exit(1);
  }

  const issueNumber = issueNumberInput.trim();

  // Get project/milestone name
  const projectName = await question('Enter GitHub project/milestone name (e.g., ValidateSolution): ');
  if (!projectName.trim()) {
    console.error('❌ Project name is required');
    rl.close();
    process.exit(1);
  }

  // Fetch issue from GitHub
  console.log('\n🔍 Fetching issue from GitHub...');
  try {
    const repoInfo = await getGitHubRepoInfo();
    if (!repoInfo) {
      console.error('❌ Could not determine GitHub repository from git remote');
      rl.close();
      process.exit(1);
    }

    const token = process.env.GITHUB_TOKEN;
    const issue = await fetchGitHubIssue(repoInfo.owner, repoInfo.repo, issueNumber, token);

    const title = issue.title;
    const categoryCode = extractCategoryCode(title);
    if (!categoryCode) {
      console.warn('⚠️  Could not extract category code from title. Using fallback.');
    }

    const description = cleanTitleForBranch(title);

    if (!categoryCode) {
      console.error('❌ Could not parse category code from issue title. Please ensure it follows the format: [XX.X] Title');
      rl.close();
      process.exit(1);
    }

    console.log('\n📋 Issue Details:');
    console.log(`   Title: ${title}`);
    console.log(`   Category: ${categoryCode}`);
    console.log(`   Description: ${description}`);

    const fullBranchName = `${branchType}/${projectName}/${categoryCode}/${issueNumber}/${description}`;
    console.log(`\n📌 Branch name: ${fullBranchName}\n`);

    const confirm = await question('Create this branch? (yes/no): ');
    if (confirm.toLowerCase() !== 'yes' && confirm.toLowerCase() !== 'y') {
      console.log('Cancelled.');
      rl.close();
      process.exit(0);
    }

    // Create and checkout new branch
    execSync(`git checkout -b ${fullBranchName}`, { stdio: 'inherit' });
    console.log(`\n✅ Branch '${fullBranchName}' created and checked out!\n`);
  } catch (error) {
    console.error(`\n❌ Error: ${error.message}`);
    console.error('\nNote: If the error is authentication-related, set GITHUB_TOKEN environment variable:');
    console.error('   export GITHUB_TOKEN=your_github_token');
    rl.close();
    process.exit(1);
  }

  rl.close();
}

createBranch().catch((error) => {
  console.error('Error:', error.message);
  rl.close();
  process.exit(1);
});
