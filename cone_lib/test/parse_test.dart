// ignore_for_file: always_specify_types

import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';

import 'package:cone_lib/src/parse.dart';

String sampleJournal = '''
account a:b ; a comment
account Expenses:Food
    note This account is all about the chicken!
    alias food
    payee ^(KFC|Popeyes)\$
    check commodity == "\$"
    assert commodity == "\$"
    eval print("Hello!")
    default
commodity 1,000.00 USD
commodity EUR
  format 1.000,00
payee bank fees
payee email

# hello world

;; more notes

2000-01-01 email
  a  1.00 USD
  b''';

void main() {
  group('Test basic printing of transaction', () {
    test('Test basic printing of transaction', () {
      expect(
        getChunks(sampleJournal),
        [
          'account a:b ; a comment',
          '''
account Expenses:Food
    note This account is all about the chicken!
    alias food
    payee ^(KFC|Popeyes)\$
    check commodity == "\$"
    assert commodity == "\$"
    eval print("Hello!")
    default''',
          'commodity 1,000.00 USD',
          'commodity EUR\n  format 1.000,00',
          'payee bank fees',
          'payee email',
          '''
# hello world

;; more notes''',
          '''
2000-01-01 email
  a  1.00 USD
  b'''
        ],
      );

      expect(getAccounts(sampleJournal), ['b', 'a', 'Expenses:Food', 'a:b']);
      expect(getPayees(sampleJournal), ['bank fees', 'email']);
      expect(getTokens(''), <Token<String>>[]);
    });
  });
}
