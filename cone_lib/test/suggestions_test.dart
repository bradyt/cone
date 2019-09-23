import 'package:test/test.dart';

import 'package:cone_lib/cone_lib.dart';

void main() {
  group('Test account suggestions', () {
    test('Get account name from line', () {
      expect(getAccountNameFromLine('account a:b:c'), 'a:b:c');
      expect(getAccountNameFromLine('  a:b:c  23.00 USD'), 'a:b:c');
      expect(getAccountNameFromLine('2019-07-14 open a:b:c'), 'a:b:c');
      expect(getAccountNameFromLine('2019-07-14 opening balance'), null);
      expect(getAccountNameFromLine('2019-07-14 open house'), null);
      expect(getAccountNameFromLine('  ; a comment'), null);
    });
  });
  group('Test description suggestions', () {
    test('Get transaction description from line', () {
      expect(getTransactionDescriptionFromLine('blah blah'), null);
      expect(getTransactionDescriptionFromLine('2019-07-14 hello'), 'hello');
      expect(getTransactionDescriptionFromLine('2019-07-14 hello ; a comment'),
          'hello');
      expect(
          getTransactionDescriptionFromLine(
              '2019-07-14=2019-07-15 hello ; a comment'),
          'hello');
    });
  });
}
