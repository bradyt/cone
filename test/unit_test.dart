import 'package:test/test.dart';

import 'package:cone/src/utils.dart';

void main() {
  group('Number of new lines to add', () {
    test('Empty', () {
      expect(MeasureNewlines('').numberOfNewlinesToAddBetween(), 0);
    });
    test('Nonempty', () {
      expect(MeasureNewlines('Hello').numberOfNewlinesToAddBetween(), 2);
    });
    test('Nonempty with one trailing newline', () {
      expect(MeasureNewlines('Hello\n').numberOfNewlinesToAddBetween(), 1);
    });
    test('Nonempty with two trailing newlines', () {
      expect(MeasureNewlines('Hello' + '\n' * 2).numberOfNewlinesToAddBetween(),
          0);
    });
  });

  group('Needs new line', () {
    test('Nonempty', () {
      expect(MeasureNewlines('Hello').needsNewline(), true);
    });
    test('Nonempty with one trailing newline', () {
      expect(MeasureNewlines('Hello\n').needsNewline(), false);
    });
  });

  group('Append file', () {
    void testAppendFile(
        String oldContents, String contentsToAdd, String expectedNewContents) {
      final String actualNewContents =
          combineContentsWithLinebreak(oldContents, contentsToAdd);
      expect(actualNewContents, expectedNewContents);
    }

    test('Original is empty', () {
      testAppendFile('', 'Taco Time!', 'Taco Time!\n');
    });
    test('Original is one linebreak', () {
      testAppendFile('\n', 'Taco Time!', '\nTaco Time!\n');
    });
    test('Original is nonempty', () {
      testAppendFile(
          'hello world', 'Taco Time!', 'hello world\n\nTaco Time!\n');
    });
    test('Original is nonempty with one linebreak', () {
      testAppendFile(
          'hello world\n', 'Taco Time!', 'hello world\n\nTaco Time!\n');
    });
    test('Original is nonempty with two linebreaks', () {
      testAppendFile(
          'hello world\n\n', 'Taco Time!', 'hello world\n\nTaco Time!\n');
    });
  });
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
  group('Test beancount description suggestions', () {
    test('Get beancount transaction description from line', () {
      expect(getTransactionDescriptionFromBeancountLine('blah blah'), null);
      expect(
          getTransactionDescriptionFromBeancountLine('2019-07-14 hello'), null);
      expect(
          getTransactionDescriptionFromBeancountLine(
              '2019-07-14 hello ; a comment'),
          null);
      expect(
          getTransactionDescriptionFromBeancountLine(
              '2019-07-14=2019-07-15 hello ; a comment'),
          null);
      expect(
          getTransactionDescriptionFromBeancountLine(
              '2019-07-14 ! hello ; a comment'),
          '! hello ; a comment');
    });
  });
  group('Test fuzzy match', () {
    test('Test fuzzy match', () {
      expect(fuzzyMatch('as', <String>{'assets'}), <String>['assets']);
      expect(fuzzyMatch('as', <String>{'Assets'}), <String>[]);
      expect(fuzzyMatch('As', <String>{'assets'}), <String>[]);
      expect(fuzzyMatch('As', <String>{'Assets'}), <String>['Assets']);
    });
  });
}
