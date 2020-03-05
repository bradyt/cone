analyze:
	ls lib/**/*.dart test/*.dart | entr -s 'dartanalyzer .'

watch:
	pub run build_runner watch

docs:
	ls lib/**/*.dart | entr dartdoc

.PHONY: test

test:
	ls lib/**/*.dart test/*.dart | entr -s 'pub run test'

parse_test:
	ls lib/**/*.dart test/*.dart | entr -s 'pub run test test/parse_test.dart'

test_coverage:
	ls lib/**/*.dart test/*.dart | entr -s 'pub run test_coverage && genhtml -o coverage coverage/lcov.info'
