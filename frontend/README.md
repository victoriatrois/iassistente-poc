# Frontend workspace

This workspace contains the React Native mobile app for the iAssistente proof of concept.

## Requirements

- Node.js 22.11.0 or newer
- Android Studio for Android builds
- Xcode for iOS builds on macOS

## Run commands

From the `frontend` directory:

```bash
npm start
npm run android
npm run ios
npm test
npm run lint
```

## iOS setup

Before the first iOS run, or after native dependency changes:

```bash
bundle install
bundle exec pod install
```

You can also open `ios/frontend.xcworkspace` directly in Xcode.

## Notes

- This app uses the React Native CLI workflow.
- `App.tsx` is still close to the default scaffold.
