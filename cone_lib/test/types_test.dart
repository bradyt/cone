import 'package:test/test.dart';

import 'package:cone_lib/src/types.dart';

void main() {
  group('A journal.', () {
    const String journalContents = '''
; a comment

account a

2020-01-01 example
  b    2.00 EUR
  c    EUR3.00
  d''';
    final Journal journal = Journal(contents: journalContents);
    final List<JournalItem> journalItems = journal.journalItems;

    // ignore: avoid_as
    final Transaction transaction = journalItems[3] as Transaction;

    test('A comment.', () {
      expect(journalItems[0] is Comment, true);
    });
    test('A directive.', () {
      expect(journalItems[1] is Directive, true);
    });
    test('A comment.', () {
      expect(journalItems[2] is Comment, true);
    });
    test('A transaction.', () {
      expect(journalItems[3] is Transaction, true);
    });
    test('An amount.', () {
      expect('${transaction.postings[0].amount}', '2.00 EUR');
    });
    test('Another amount.', () {
      expect('${transaction.postings[1].amount}', 'EUR3.00');
    });
    test('A posting.', () {
      expect('${transaction.postings[0]}',
          '    b                                       2.00 EUR');
    });
    test('A directive.', () {
      expect('${journalItems[1]}', 'account a');
    });
    test('A comment.', () {
      expect('${journalItems[0]}', '; a comment');
    });
    test('A transaction.', () {
      expect(
        '$transaction',
        '2020-01-01 example\n'
            '    b                                       2.00 EUR\n'
            '    c                                        EUR3.00\n'
            '    d',
      );
    });
  });
  group('Test of two transactions.', () {
    const String contents = '''
2020-01-01 an example
    a                                       2.00 EUR
    b

2020-01-02 another example
    a                                       3.00 EUR
    b''';

    test('Roundtrip.', () {
      expect('${Journal(contents: contents)}', contents);
    });
    test('Get transactions.', () {
      expect(
          Journal(contents: contents)
              .transactions[1]
              .postings[0]
              .amount
              .quantity,
          '3.00');
    });
  });
  group('Copying a posting.', () {
    const Posting posting0 = Posting(key: 0, account: 'a');
    final Posting posting1 = posting0.copyWith(key: 1);
    final Posting posting2 = posting0.copyWith(account: 'b');
    test('Just a key.', () {
      expect(posting1.key, 1);
    });
    test('Full check.', () {
      expect(posting2.key, 0);
      expect(posting2.account, 'b');
    });
  });
}
