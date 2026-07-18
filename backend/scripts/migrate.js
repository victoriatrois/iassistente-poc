(async () => {
  const dotenv = await import('dotenv');
  const { execSync } = await import('node:child_process');
  const path = await import('node:path');

  dotenv.config({ path: '.env.local' });

  const command = process.argv[2];
  const args = process.argv.slice(3).join(' ');
  const backendRoot = path.join(__dirname, '..');

  try {
    execSync(`node-pg-migrate ${command} --migrations-dir migrations ${args}`, {
      stdio: 'inherit',
      cwd: backendRoot,
    });
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
})().catch((error) => {
  console.error(error);
  process.exit(1);
});
