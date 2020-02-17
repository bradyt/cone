import 'package:test/test.dart';

import 'package:cone_lib/cone_lib.dart' show Journal;

import 'package:cone/src/utils.dart'
    show
        accounts,
        descriptions,
        filterSuggestions,
        localeSpacing,
        localeCurrency,
        localeCurrencyOnLeft,
        sortSuggestions;

void main() {
  test('Test localeSpacing.', () {
    expect(localeSpacing('en'), 0);
    expect(localeSpacing('de'), 1);
    expect(localeSpacing('ja'), 0);
  });
  test('Test localeCurrencyOnLeft.', () {
    expect(localeCurrencyOnLeft('en'), true);
    expect(localeCurrencyOnLeft('de'), false);
    expect(localeCurrencyOnLeft('ja'), true);
  });
  test('Test localeCurrency.', () {
    expect(localeCurrency('en'), 'USD');
    expect(localeCurrency('de'), 'EUR');
    expect(localeCurrency('ja'), 'JPY');
  });
  test('Test descriptions.', () {
    expect(
      descriptions(Journal(contents: '2000-01-01 example')),
      <String>['example'],
    );
  });
  test('Test accounts.', () {
    expect(
      accounts(Journal(contents: 'account a')),
      <String>['a'],
    );
    expect(
      accounts(Journal(contents: '2000-01-01 example\n  a  0 EUR\n  b')),
      <String>['a', 'b'],
    );
  });
  test('Test sortSuggestions.', () {
    expect(
      sortSuggestions(<String>['a', 'b']),
      <String>['b', 'a'],
    );
    expect(
      sortSuggestions(<String>['a', 'a', 'b']),
      <String>['a', 'b'],
    );
    expect(
      sortSuggestions(<String>['a', 'b', 'b', 'a']),
      <String>['a', 'b'],
    );
  });
  test('Test filterSuggestions.', () {
    expect(filterSuggestions('', <String>['a']), <String>['a']);
    expect(filterSuggestions('a', <String>['a']), <String>['a']);
    expect(filterSuggestions('z', <String>['a']), <String>[]);
    expect(filterSuggestions('a b', <String>['abc']), <String>['abc']);
    expect(filterSuggestions('a z', <String>['abc']), <String>[]);
  });
}
