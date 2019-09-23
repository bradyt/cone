// ignore_for_file: always_specify_types

import 'package:test/test.dart';

import 'package:cone_lib/src/format.dart' show transactionToString;
import 'package:cone_lib/src/types.dart' show Posting, Transaction;

void main() {
  group('Test basic printing of transaction', () {
    test('Test basic printing of transaction', () {
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
  a:b:c  20 null''',
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
          '  A  1 EUR',
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
          '  C    1 EUR',
        );
      });
    });
  });
}
