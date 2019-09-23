// ignore_for_file: always_specify_types

import 'package:test/test.dart';

import 'package:cone_lib/src/format.dart' show transactionToString, padZeros;
import 'package:cone_lib/src/types.dart' show Posting, Transaction;

void main() {
  group('Test basic printing of transaction', () {
    test('Test basic printing of transaction', () {
      expect(
          transactionToString(
            locale: 'en_US',
            transaction: Transaction(
              date: '2000-01-01',
              postings: [
                Posting(account: 'a', amount: '1000'),
                Posting(account: 'a', amount: '1000', currency: 'hello'),
                Posting(account: 'a', amount: '1', currency: 'EUR'),
                Posting(account: 'abc', amount: '1', currency: 'JPY'),
              ],
            ),
            spacing: false,
            currencyOnLeft: true,
          ),
          '2000-01-01 null\n'
          '  a         1000.00\n'
          '  a    hello1000.00\n'
          '  a         EUR1.00\n'
          '  abc       JPY1'
        );
      expect(
          transactionToString(
            transaction: Transaction(
              date: '2000-01-01',
              postings: [],
            ),
          ),
          '2000-01-01 null');
      expect(
        transactionToString(
          transaction: Transaction(
            date: '2000-01-01',
            description: 'hello world',
            postings: [],
          ),
        ),
        '2000-01-01 hello world',
      );
      expect(
        transactionToString(
          locale: 'en_US',
          transaction: Transaction(
            date: '2000-01-01',
            description: 'hello world',
            postings: [
              Posting(
                account: 'a:b:c',
                amount: '20',
              ),
            ],
          ),
        ),
        '''
2000-01-01 hello world
  a:b:c  20.00''',
      );
      expect(
        transactionToString(
          locale: 'en_US',
          transaction: Transaction(
            date: '2000-01-01',
            description: 'hello world',
            postings: [
              Posting(
                account: 'a:b:c',
                amount: '20',
                currency: 'USD',
              ),
            ],
          ),
        ),
        '''
2000-01-01 hello world
  a:b:c  20.00 USD''',
      );
    });

    String justPostingsFormatted({List<List<String>> abbreviatedPostings}) =>
        transactionToString(
          locale: 'en_US',
          transaction: Transaction(
            date: '2000-01-01',
            description: 'hello world',
            postings: abbreviatedPostings
                .map(
                  (List<String> abbreviatedPosting) => Posting(
                    account: abbreviatedPosting[0],
                    amount: abbreviatedPosting[1],
                    currency: abbreviatedPosting[2],
                  ),
                )
                .toList(),
          ),
        ).split('\n').sublist(1).join('\n');

    group('Test printing of amounts', () {
      test('Test printing of amounts', () {
        expect(
          justPostingsFormatted(abbreviatedPostings: [
            ['A', '1', 'USD'],
          ]),
          '  A  1.00 USD',
        );
      });
      test('Test printing of amounts', () {
        expect(
          justPostingsFormatted(abbreviatedPostings: [
            ['A', '1', 'EUR'],
          ]),
          '  A  1.00 EUR',
        );
      });
      test('Test printing of transaction', () {
        expect(
          justPostingsFormatted(abbreviatedPostings: [
            ['A:B', '1', 'USD'],
            ['C', '1', 'USD'],
          ]),
          '  A:B  1.00 USD\n'
          '  C    1.00 USD',
        );
      });
      test('Test printing of transaction', () {
        expect(
          justPostingsFormatted(abbreviatedPostings: [
            ['A:B', '1', 'USD'],
            ['C', '1', 'EUR'],
          ]),
          '  A:B  1.00 USD\n'
          '  C    1.00 EUR',
        );
      });
    });
  });
  group('Test zero padding', () {
    void testPadZeros(
      String locale,
      String amount,
      String currency,
      String result,
    ) =>
        expect(
          padZeros(
            locale: locale,
            amount: amount,
            currency: currency,
          ),
          result,
        );

    test('USD', () {
      testPadZeros('en', '1', 'USD', '1.00');
    });
    test('USD', () {
      testPadZeros('en', '1.0', 'USD', '1.00');
    });
    test('GBP', () {
      testPadZeros('en_GB', '1', 'GBP', '1.00');
    });
    test('JPY', () {
      testPadZeros('ja', '1', 'JPY', '1');
    });
    test('Don\'t round', () {
      testPadZeros('en', '1.234', 'USD', '1.234');
    });
    test('Don\'t round JPY', () {
      testPadZeros('en', '1.2', 'JPY', '1.2');
    });
    test('Round zero decimals of JPY', () {
      testPadZeros('en', '1.0', 'JPY', '1');
    });
    test('Euros in locale fr', () {
      testPadZeros('fr', '1,0', 'EUR', '1,00');
    });
    test('Rubles in locale ru', () {
      testPadZeros('ru', '1,0', 'RUB', '1,00');
    });
  });
}
