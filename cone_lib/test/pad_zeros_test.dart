import 'package:test/test.dart';

import 'package:cone_lib/pad_zeros.dart';

void main() {
  test(
      'We want padZeros to throw an exception if the locale '
      'or quantity arguments are null.', () {
    expect(() => padZeros(commodity: 'EUR'), throwsException);
  });
  test('Provoke exception.', () {
    expect(padZeros(locale: 'en', quantity: 'EUR'), 'EUR');
  });
  group('Try many combinations.', () {
    final Map<List<String?>, String> outputs = <List<String?>, String>{
      <String>['de', '0', 'EUR']: '0,00',
      <String>['de', '0', 'JPY']: '0',
      <String>['de', '0', 'USD']: '0,00',
      <String?>['de', '0', null]: '0,00',
      <String>['de', '1,234', 'EUR']: '1,234',
      <String>['de', '1,234', 'JPY']: '1,234',
      <String>['de', '1,234', 'USD']: '1,234',
      <String?>['de', '1,234', null]: '1,234',
      <String>['de', '1.234', 'EUR']: '1234,00',
      <String>['de', '1.234', 'JPY']: '1234',
      <String>['de', '1.234', 'USD']: '1234,00',
      <String?>['de', '1.234', null]: '1234,00',
      <String>['en', '0', 'EUR']: '0.00',
      <String>['en', '0', 'JPY']: '0',
      <String>['en', '0', 'USD']: '0.00',
      <String?>['en', '0', null]: '0.00',
      <String>['en', '1,234', 'EUR']: '1234.00',
      <String>['en', '1,234', 'JPY']: '1234',
      <String>['en', '1,234', 'USD']: '1234.00',
      <String?>['en', '1,234', null]: '1234.00',
      <String>['en', '1.234', 'EUR']: '1.234',
      <String>['en', '1.234', 'JPY']: '1.234',
      <String>['en', '1.234', 'USD']: '1.234',
      <String?>['en', '1.234', null]: '1.234',
      <String>['ja', '0', 'EUR']: '0.00',
      <String>['ja', '0', 'JPY']: '0',
      <String>['ja', '0', 'USD']: '0.00',
      <String?>['ja', '0', null]: '0.00',
      <String>['ja', '1,234', 'EUR']: '1234.00',
      <String>['ja', '1,234', 'JPY']: '1234',
      <String>['ja', '1,234', 'USD']: '1234.00',
      <String?>['ja', '1,234', null]: '1234.00',
      <String>['ja', '1.234', 'EUR']: '1.234',
      <String>['ja', '1.234', 'JPY']: '1.234',
      <String>['ja', '1.234', 'USD']: '1.234',
      <String?>['ja', '1.234', null]: '1.234',
    };
    for (final String locale in <String>[
      'de',
      'en',
      'ja',
    ]) {
      for (final String quantity in <String>[
        '0',
        '1,234',
        '1.234',
      ]) {
        for (final String? commodity in <String?>[
          'EUR',
          'JPY',
          'USD',
          null,
        ]) {
          test('Test padZeros with $locale, $quantity, $commodity.', () {
            expect(
                padZeros(
                    locale: locale, quantity: quantity, commodity: commodity),
                outputs.entries
                    .firstWhere((MapEntry<List<String?>, String> entry) =>
                        entry.key[0] == locale &&
                        entry.key[1] == quantity &&
                        entry.key[2] == commodity)
                    .value);
          });
        }
      }
    }
  });
}
