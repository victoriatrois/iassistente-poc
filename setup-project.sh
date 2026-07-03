#!/bin/bash

# Setup Linting Configuration and Git Hooks
# This script replicates the linting setup from the reference repository
# Usage: ./setup-linting.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if we're in a git repository
if [ ! -d .git ]; then
    log_error "Not a git repository. Please initialize with 'git init' first."
    exit 1
fi

log_info "Starting linting configuration setup..."

# Create .husky directory if it doesn't exist
if [ ! -d .husky ]; then
    log_info "Creating .husky directory..."
    mkdir -p .husky
fi

# Create commitlint.config.js
log_info "Setting up commitlint configuration..."
cat > commitlint.config.js << 'EOF'
module.exports = {
  extends: ["@commitlint/config-conventional"],
};
EOF
log_success "Created commitlint.config.js"

# Create .eslintrc.json
log_info "Setting up ESLint configuration..."
cat > .eslintrc.json << 'EOF'
{
  "extends": [
    "eslint:recommended",
    "plugin:jest/recommended",
    "next/core-web-vitals",
    "prettier"
  ]
}
EOF
log_success "Created .eslintrc.json"

# Create .secretlintrc.json
log_info "Setting up Secretlint configuration..."
cat > .secretlintrc.json << 'EOF'
{
  "rules": [
    {
      "id": "@secretlint/secretlint-rule-preset-recommend"
    }
  ]
}
EOF
log_success "Created .secretlintrc.json"

# Create .secretlintignore
log_info "Setting up Secretlint ignore patterns..."
cat > .secretlintignore << 'EOF'
node_modules/
.next/
dist/
build/
.git/
EOF
log_success "Created .secretlintignore"

# Setup Husky git hooks
log_info "Setting up Husky git hooks..."

# Create pre-commit hook
mkdir -p .husky
cat > .husky/pre-commit << 'EOF'
files=$(git diff --cached --name-only --diff-filter=ACM)
if [ -n "$files" ]; then
  npx secretlint $files || exit 1
fi
EOF
chmod +x .husky/pre-commit
log_success "Created pre-commit hook"

# Create commit-msg hook
cat > .husky/commit-msg << 'EOF'
npx commitlint --edit $1
EOF
chmod +x .husky/commit-msg
log_success "Created commit-msg hook"

# Check for package.json and update it if needed
if [ ! -f package.json ]; then
    log_warning "package.json not found. Creating one..."
    cat > package.json << 'EOF'
{
  "name": "my-project",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "dev": "node infra/scripts/dev.js",
    "test": "node infra/scripts/test.js",
    "test:watch": "jest --watchAll --runInBand --verbose",
    "services:up": "docker compose -f infra/compose.yaml up -d",
    "services:stop": "docker compose -f infra/compose.yaml stop",
    "services:down": "docker compose -f infra/compose.yaml down",
    "services:wait:database": "node infra/scripts/wait-for-postgres.js",
    "migrations:create": "node-pg-migrate --migrations-dir infra/migrations create",
    "migrations:up": "node-pg-migrate --migrations-dir infra/migrations --envPath .env.development up",
    "lint:prettier:check": "prettier --check .",
    "lint:prettier:fix": "prettier --write .",
    "lint:eslint:check": "next lint --dir .",
    "lint:secretlint:check": "npx secretlint \"**/*\"",
    "prepare": "husky",
    "commit": "cz"
  },
  "author": "",
  "license": "MIT",
  "dependencies": {
    "async-retry": "1.3.3",
    "dotenv": "16.4.5",
    "module-alias": "2.2.3",
    "next": "14.2.5",
    "next-connect": "1.0.0",
    "node-pg-migrate": "7.6.1",
    "pg": "8.12.0",
    "react": "18.3.1",
    "react-dom": "18.3.1",
    "secretlint": "11.2.5",
    "swr": "2.2.5",
    "uuid": "11.1.0"
  },
  "devDependencies": {}
}
EOF
    log_success "Created package.json with all scripts and dependencies"
else
    log_info "Checking package.json for required scripts..."
    # Check if scripts exist, if not we'll inform the user
    if ! grep -q "lint:prettier:check" package.json; then
        log_warning "Missing lint:prettier:check script in package.json"
    fi
fi

# Install dependencies
log_info "Installing required dependencies..."
log_info "Installing npm packages... (this may take a moment)"

# Core linting and dev tools
npm install --save-dev \
  "@babel/preset-typescript@7.24.1" \
  "@commitlint/cli@19.4.0" \
  "@commitlint/config-conventional@19.2.2" \
  "@secretlint/secretlint-rule-aws@11.2.5" \
  "@secretlint/secretlint-rule-preset-recommend@11.2.5" \
  "@types/async-retry@1.4.9" \
  "@types/jest@29.5.12" \
  "@types/node@20.11.21" \
  "@types/pg@8.11.5" \
  "@types/react@18.2.60" \
  "@types/react-dom@18.2.19" \
  "commitizen@4.3.0" \
  "concurrently@8.2.2" \
  "cz-conventional-changelog@3.3.0" \
  "eslint@8.57.0" \
  "eslint-config-next@15.5.3" \
  "eslint-config-prettier@9.1.0" \
  "eslint-plugin-jest@28.8.0" \
  "husky@9.1.4" \
  "jest@29.7.0" \
  "prettier@3.3.3" \
  "ts-jest@29.1.2" \
  "typescript@5.3.3" 2>/dev/null || log_warning "Some dev dependencies may have failed to install"

# Core dependencies
npm install \
  "async-retry@1.3.3" \
  "dotenv@16.4.5" \
  "module-alias@2.2.3" \
  "next@14.2.5" \
  "next-connect@1.0.0" \
  "node-pg-migrate@7.6.1" \
  "pg@8.12.0" \
  "react@18.3.1" \
  "react-dom@18.3.1" \
  "secretlint@11.2.5" \
  "swr@2.2.5" \
  "uuid@11.1.0" 2>/dev/null || log_warning "Some dependencies may have failed to install"

log_success "Dependencies installed"

# Initialize Husky if not already initialized
log_info "Initializing Husky..."
npx husky install 2>/dev/null || log_warning "Husky initialization encountered an issue (this may be normal)"

# Verify setup
log_info "Verifying setup..."

VERIFY_SUCCESS=true

if [ ! -f commitlint.config.js ]; then
    log_error "commitlint.config.js not found"
    VERIFY_SUCCESS=false
else
    log_success "commitlint.config.js verified"
fi

if [ ! -f .eslintrc.json ]; then
    log_error ".eslintrc.json not found"
    VERIFY_SUCCESS=false
else
    log_success ".eslintrc.json verified"
fi

if [ ! -f .secretlintrc.json ]; then
    log_error ".secretlintrc.json not found"
    VERIFY_SUCCESS=false
else
    log_success ".secretlintrc.json verified"
fi

if [ ! -f .husky/pre-commit ]; then
    log_error ".husky/pre-commit hook not found"
    VERIFY_SUCCESS=false
else
    log_success ".husky/pre-commit hook verified"
fi

if [ ! -f .husky/commit-msg ]; then
    log_error ".husky/commit-msg hook not found"
    VERIFY_SUCCESS=false
else
    log_success ".husky/commit-msg hook verified"
fi

echo ""
if [ "$VERIFY_SUCCESS" = true ]; then
    log_success "Linting setup completed successfully!"
    echo ""
    echo -e "${BLUE}Available commands:${NC}"
    echo ""
    echo -e "${YELLOW}Development:${NC}"
    echo "  npm run dev                   - Start development server"
    echo "  npm run test                  - Run tests once"
    echo "  npm run test:watch            - Run tests in watch mode"
    echo ""
    echo -e "${YELLOW}Services (requires Docker):${NC}"
    echo "  npm run services:up           - Start Docker services"
    echo "  npm run services:stop         - Stop Docker services"
    echo "  npm run services:down         - Tear down Docker services"
    echo "  npm run services:wait:database - Wait for database to be ready"
    echo ""
    echo -e "${YELLOW}Migrations:${NC}"
    echo "  npm run migrations:create     - Create a new migration"
    echo "  npm run migrations:up         - Run pending migrations"
    echo ""
    echo -e "${YELLOW}Linting & Code Quality:${NC}"
    echo "  npm run lint:prettier:check   - Check code formatting"
    echo "  npm run lint:prettier:fix     - Fix code formatting"
    echo "  npm run lint:eslint:check     - Check code quality"
    echo "  npm run lint:secretlint:check - Check for secrets"
    echo ""
    echo -e "${YELLOW}Commits:${NC}"
    echo "  npm run commit                - Create conventional commits with Commitizen"
    echo ""
    echo -e "${YELLOW}Git hooks are now active:${NC}"
    echo "  pre-commit  - Checks for secrets before each commit"
    echo "  commit-msg  - Validates commit message format"
else
    log_error "Setup verification failed. Please check the errors above."
    exit 1
fi
