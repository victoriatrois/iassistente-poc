require('dotenv').config({ path: '.env.local' });

const { execSync } = require('child_process');
const path = require('path');

const command = process.argv[2];
const args = process.argv.slice(3).join(' ');

const nodePgMigrateCmd = path.join(__dirname, '..', 'node_modules', '.bin', 'node-pg-migrate');

try {
  execSync(`${nodePgMigrateCmd} ${command} --migrations-dir migrations ${args}`, {
    stdio: 'inherit',
    cwd: __dirname,
  });
} catch (error) {
  process.exit(1);
}
