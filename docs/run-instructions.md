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
POSTGRES_DB=notes_db
POSTGRES_USER=notes_user
POSTGRES_PASSWORD=notes_password
DATABASE_URL=<postgresql connection string built from the values above>
```

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
