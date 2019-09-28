// ignore_for_file: always_specify_types

import 'package:test/test.dart';

import 'package:cone_lib/src/parse.dart';

String sampleJournal = '''
account a:b
commodity 1,000.00 USD
commodity EUR
  format 1.000,00
payee bank fees

# hello world

;; more notes

2000-01-01 email
  a  1.00 USD
  b''';

void main() {
  group('Test basic printing of transaction', () {
    test('Test basic printing of transaction', () {
      expect(
        parser.parse(sampleJournal).value,
        [
          'account a:b',
          'commodity 1,000.00 USD',
          'commodity EUR\n  format 1.000,00',
          'payee bank fees',
          '''
# hello world

;; more notes''',
          '''
2000-01-01 email
  a  1.00 USD
  b'''
        ],
      );

      expect(getAccounts(sampleJournal), ['a', 'a:b', 'b']);
      expect(getPayees(sampleJournal), ['bank fees', 'email']);
    });
  });
}
