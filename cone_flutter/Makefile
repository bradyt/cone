PACKAGES=.packages
STATEGDART=lib/src/redux/state.g.dart

$(PACKAGES):
	flutter pub get

get: $(PACKAGES)

$(STATEGDART): $(PACKAGES)
	cd ../cone_lib && make build
	dart run build_runner build

build: $(STATEGDART)

watch: $(PACKAGES)
	dart run build_runner watch

analyze:
	flutter analyze --watch

.PHONY: coverage build
coverage:
	flutter test --coverage
	genhtml -o coverage coverage/lcov.info
	reload-browser 'Google Chrome'

install:
	flutter build apk --flavor=play --target-platform android-arm,android-arm64,android-x64 --split-per-abi

test_android_build: $(STATEGDART)
	flutter build apk --flavor=dev --target-platform android-x64 --split-per-abi

test_ios_build: $(STATEGDART)
	flutter build ios
