// ignore_for_file: public_member_api_docs

import 'dart:math' show max;

import 'package:petitparser/petitparser.dart';

import 'package:cone_lib/parse.dart';

class Journal {
  Journal({String contents}) {
    final List<Token<String>> tokens =
        // ignore: avoid_as
        JournalParser().parse(contents).value as List<Token<String>>;
    journalItems = tokens.map<JournalItem>(parseJournalItem).toList();
    transactions = journalItems.whereType<Transaction>().toList();
  }

  List<JournalItem> journalItems;
  List<Transaction> transactions;

  @override
  String toString() => <String>[
        for (JournalItem item in journalItems) '$item',
      ].join('\n');
}

abstract class JournalItem {
  const JournalItem({
    this.firstLine,
    this.lastLine,
  });

  final int firstLine;
  final int lastLine;
}

class Comment extends JournalItem {
  const Comment({
    int firstLine,
    int lastLine,
    this.comment,
  }) : super(firstLine: firstLine, lastLine: lastLine);

  final String comment;

  @override
  String toString() => '$comment';
}

class Directive extends JournalItem {
  const Directive({
    int firstLine,
    int lastLine,
    this.directive,
  }) : super(firstLine: firstLine, lastLine: lastLine);

  final String directive;

  @override
  String toString() => '$directive';
}

class AccountDirective extends Directive {
  const AccountDirective({
    int firstLine,
    int lastLine,
    this.account,
  }) : super(firstLine: firstLine, lastLine: lastLine);

  final String account;

  @override
  String toString() => '$account';
}

class Transaction extends JournalItem {
  const Transaction({
    int firstLine,
    int lastLine,
    this.date,
    this.description,
    this.postings,
  }) : super(firstLine: firstLine, lastLine: lastLine);

  final String date;
  final String description;
  final List<Posting> postings;

  @override
  String toString() => <String>[
        '$date $description',
        for (Posting posting in postings) '$posting',
      ].join('\n');

  Transaction copyWith({
    String date,
    String description,
    List<Posting> postings,
  }) =>
      Transaction(
        date: date ?? this.date,
        description: description ?? this.description,
        postings: postings ?? this.postings,
      );
}

class Posting {
  const Posting({
    this.key,
    this.account,
    this.amount,
  });

  final int key;
  final String account;
  final Amount amount;

  Posting copyWith({
    int key,
    String account,
    Amount amount,
  }) =>
      Posting(
        key: key ?? this.key,
        account: account ?? this.account,
        amount: amount ?? this.amount,
      );

  @override
  String toString() {
    if (amount == null) {
      return '    $account';
    } else {
      final int padding = max(
          2,
          (amount.commodityOnLeft)
              ? 52 - 4 - account.length - 2 - amount.toString().length
              : 52 -
                  4 -
                  account.length -
                  2 -
                  amount.quantity.toString().length);
      return '    $account  ${' ' * padding}$amount'.trimRight();
    }
  }
}

class Amount {
  const Amount({
    this.commodity,
    this.commodityOnLeft,
    this.quantity,
    this.spacing,
  });

  final String commodity;
  final String quantity;
  final bool commodityOnLeft;
  final int spacing;

  @override
  String toString() {
    if (commodityOnLeft ?? true) {
      return '$commodity${' ' * (spacing ?? 0)}$quantity';
    } else {
      return '$quantity${' ' * (spacing ?? 0)}$commodity';
    }
  }
}
