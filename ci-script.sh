#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# Run dartfmt
echo "--- Running dartfmt in cone_lib... ---"
(cd cone_lib && dartfmt --set-exit-if-changed . >/dev/null)

echo "--- Running dartfmt in cone_flutter... ---"
(cd cone_flutter && dartfmt --set-exit-if-changed . >/dev/null)

echo "--- Running dartfmt in uri_picker... ---"
(cd uri_picker && dartfmt --set-exit-if-changed . >/dev/null)

# Get all packages
(cd cone_lib && pub get)

(cd cone_flutter && flutter packages get)

(cd uri_picker && flutter packages get)

# Build runner
(cd cone_lib && pub run build_runner build)
(cd cone_flutter && flutter pub run build_runner build)

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

# Coverage
(cd cone_lib && pub run test_coverage --no-badge --min-coverage 79)
