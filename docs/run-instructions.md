# Run instructions

## Prerequisites

- Node.js 22.11.0 or newer
- npm
- Docker Desktop
- Xcode for iOS development on macOS
- Android Studio for Android development

## 1. Configure environment variables

From the repository root:

```bash
cp .env.example .env.local
```

Set local values in `.env.local`. Example:

```env
POSTGRES_DB=<your_db_name>
POSTGRES_USER=<your_db_user>
POSTGRES_PASSWORD=<your_db_password>
DATABASE_URL=<set a local PostgreSQL connection string here>
```

If you run backend tests and migrations locally, also set `backend/.env.local`.
Vitest and migration scripts read `backend/.env.local` first.

### Important: use one PostgreSQL target consistently

Pick one and keep it consistent across `npm run migrate:up`, `npm run test:backend`, and `npm run dev:backend`:

- Local Homebrew PostgreSQL: set `DATABASE_URL` in `backend/.env.local` for your local instance.
- Docker PostgreSQL service: set `DATABASE_URL` in `backend/.env.local` to point to the `postgres` host.

If these commands point to different databases, migrations may appear successful while tests still fail.

## 2. Start backend services

From the repository root:

```bash
npm run services:up
```

Useful follow-up commands:

```bash
npm run services:logs
npm run services:ps
npm run services:down
```

If you want to run the backend directly from the workspace instead of Docker:

```bash
npm run dev:backend
```

Apply database migrations before backend tests that depend on schema changes:

```bash
npm run migrate:up
```

If migration fails with `must be owner of table user` on local PostgreSQL, run once:

```bash
psql -d notes_db -c 'ALTER TABLE "user" OWNER TO notes_user; ALTER TABLE note OWNER TO notes_user;'
```

Then rerun:

```bash
npm run migrate:up
```

## 3. Start the frontend bundler

In a new terminal:

```bash
cd frontend
npm start
```

## 4. Run on Android

- Start an Android emulator or connect a device.
- In another terminal:

```bash
cd frontend
npm run android
```

## 5. Run on iOS

If this is your first run, or native iOS dependencies changed:

```bash
cd frontend
bundle install
bundle exec pod install
```

Then launch the app:

```bash
cd frontend
npm run ios
```

You can also open `frontend/ios/frontend.xcworkspace` in Xcode.

## 6. Build, test, and lint

From the repository root:

```bash
npm run build
npm run test
npm run lint
```
