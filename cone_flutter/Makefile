.PHONY: coverage
coverage:
	flutter test --coverage
	genhtml -o coverage coverage/lcov.info
	reload-browser 'Google Chrome'
