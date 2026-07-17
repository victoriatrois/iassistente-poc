# Backend workspace

This workspace contains the Next.js backend for the iAssistente proof of concept.

## Run commands

From the `backend` directory:

```bash
npm run dev
npm run build
npm run start
npm run test
npm run migrate:create
npm run migrate:up
```

## Local workflow

- The repository-level Docker setup lives in `../infra/docker-compose.yml`.
- The backend container runs `npm --workspace=backend run dev` from the monorepo root.
- When working from the repo root, use `npm run dev:backend`, `npm run build`, and `npm run migrate:up`.

## Notes

- `app/page.tsx` is still scaffold content.
- Backend environment values come from the repository `.env.local` file when using the Docker workflow.
