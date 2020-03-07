.PHONY: coverage
coverage:
	flutter test --coverage
	genhtml -o coverage coverage/lcov.info
	reload-browser 'Google Chrome'

builder_watch:
	flutter pub run build_runner watch
