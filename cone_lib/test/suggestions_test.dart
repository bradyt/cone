// ignore_for_file: always_specify_types

import 'package:test/test.dart';

import 'package:cone_lib/cone_lib.dart';

void main() {
  group('Test account suggestions', () {
    test('Get account name from line', () {
      expect(getAccounts('account a:b:c'), ['a:b:c']);
      expect(getAccounts('2\n  a:b:c  23.00 USD'), ['a:b:c']);
      expect(getAccounts('2019-07-14 open a:b:c'), ['a:b:c']);
      expect(getAccounts('2019-07-14 opening balance'), <String>[]);
      expect(getAccounts('2019-07-14 open house'), <String>[]);
      expect(getAccounts('  ; a comment'), <String>[]);
    });
  });
  group('Test description suggestions', () {
    test('Get transaction description from line', () {
      expect(getPayees('blah blah'), <String>[]);
      expect(getPayees('2019-07-14 hello'), ['hello']);
      expect(getPayees('2019-07-14 hello ; a comment'), ['hello']);
      expect(getPayees('2019-07-14=2019-07-15 hello ; a comment'), ['hello']);
      expect(getPayees('payee KFC'), ['KFC']);
    });
  });
  group('Test description suggestions', () {
    const String testFile = '''
account a:b:c
payee KFC
;; a comment
commodity \$1,000.00

commodity \$
  format 1,000.00

2019-01-01 hello world
  a  12.34
  ; another comment
  b  1
more stuff

2019-07-14 open a:b
2019-07-14 opening balance
2019-07-14 open house
''';
    test('Get transaction description from line', () {
      expect(getAccounts(testFile), [
        'a',
        'a:b',
        'a:b:c',
        'b',
      ]);
      expect(
        getChunks(testFile),
        [
          'account a:b:c',
          'payee KFC',
          ';; a comment',
          'commodity \$1,000.00',
          '''
commodity \$
  format 1,000.00''',
          '''
2019-01-01 hello world
  a  12.34
  ; another comment
  b  1''',
          'more stuff',
          '2019-07-14 open a:b',
          '2019-07-14 opening balance',
          '2019-07-14 open house',
        ],
      );
    });
  });
}
