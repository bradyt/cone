
Notes for deploying.

# Prep

```
git clean -dffx
cd cone_flutter
make build
```

# Installing fastlane

See <https://github.com/fastlane/docs/issues/931>.

```
gem install --user-install bundler
bundle config set path 'vendor/bundle'
```

# Android

# iOS

```
flutter build ios --build-name 0.0.1 --build-number 0.0.3
cd ios
```

## Manually, via Xcode

See <https://flutter.dev/docs/deployment/ios>.

```
open Runner.xcworkspace
```

Build iOS 8.0. Use automatic provisioning signing.

Product > Archive

Validate App

Strip Swift symbols

Upload your app's symbols to receive symbolicated reports from Apple

Automatically manage signing

Symbols: Included
Bitcode: Not included

Distribute app

## Automatically, via fastlane

```
bundle update
bundle exec fastlane ios beta
```

See `./cone_flutter/ios/fastlane/Gymfile`.
