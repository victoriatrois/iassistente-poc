(async () => {
	const dotenv = await import('dotenv');
	dotenv.config({ path: '.env.local' });
})().catch((error) => {
	console.error(error);
	process.exit(1);
});
