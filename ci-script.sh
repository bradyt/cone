#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# Run dartfmt
echo "--- Running dart format in cone_lib... ---"
(cd cone_lib && dart format --set-exit-if-changed . >/dev/null)

echo "--- Running dart format in cone_flutter... ---"
(cd cone_flutter && dart format --set-exit-if-changed . >/dev/null)

echo "--- Running dart format in uri_picker... ---"
(cd uri_picker && dart format --set-exit-if-changed . >/dev/null)

# Get all packages
(cd cone_lib && dart pub get)

(cd cone_flutter && flutter pub get)

(cd uri_picker && flutter pub get)

# Build runner
(cd cone_lib && dart pub run build_runner build)
(cd cone_flutter && dart run build_runner build --delete-conflicting-outputs)

# Analyze
echo "--- Running dartanalyzer in cone_lib... ---"
(cd cone_lib && dartanalyzer ./ --fatal-infos --fatal-warnings)

echo "--- Running dartanalyzer in cone_flutter... ---"
(cd cone_flutter && dartanalyzer ./ --fatal-infos --fatal-warnings)

echo "--- Running dartanalyzer in uri_picker... ---"
(cd uri_picker && dartanalyzer ./ --fatal-infos --fatal-warnings)

# Run tests
echo "--- Running tests in cone_lib... ---"
(cd cone_lib && pub run test)

echo "--- Running tests in cone_flutter... ---"
(cd cone_flutter && flutter test)

echo "--- Running tests in uri_picker... ---"
(cd uri_picker && flutter test)
