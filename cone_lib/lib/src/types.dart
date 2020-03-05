// ignore_for_file: public_member_api_docs

import 'dart:math' show max;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:petitparser/petitparser.dart';

import 'package:cone_lib/parse.dart';

part 'types.g.dart';

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

abstract class JournalItem {}

abstract class Comment implements JournalItem, Built<Comment, CommentBuilder> {
  factory Comment([void Function(CommentBuilder) updates]) = _$Comment;
  Comment._();

  int get firstLine;
  int get lastLine;
  String get comment;

  @override
  String toString() => '$comment';
}

abstract class Directive implements JournalItem {}

abstract class AccountDirective
    implements Directive, Built<AccountDirective, AccountDirectiveBuilder> {
  factory AccountDirective([void Function(AccountDirectiveBuilder) updates]) =
      _$AccountDirective;
  AccountDirective._();

  int get firstLine;
  int get lastLine;
  String get account;

  @override
  String toString() => '$account';
}

abstract class OtherDirective
    implements Directive, Built<OtherDirective, OtherDirectiveBuilder> {
  factory OtherDirective([void Function(OtherDirectiveBuilder) updates]) =
      _$OtherDirective;
  OtherDirective._();

  int get firstLine;
  int get lastLine;
  String get other;

  @override
  String toString() => '$other';
}

abstract class Transaction
    implements JournalItem, Built<Transaction, TransactionBuilder> {
  factory Transaction([void Function(TransactionBuilder) updates]) =
      _$Transaction;
  Transaction._();

  int get firstLine;
  int get lastLine;
  String get date;
  String get description;
  BuiltList<Posting> get postings;

  static void _initializeBuilder(TransactionBuilder b) => b
    ..firstLine = -1
    ..lastLine = -1
    ..date = ''
    ..description = '';

  @override
  String toString() => <String>[
        '$date $description'.trimRight(),
        for (Posting posting in postings) '$posting',
      ].join('\n');
}

abstract class Posting implements Built<Posting, PostingBuilder> {
  factory Posting([void Function(PostingBuilder) updates]) = _$Posting;
  Posting._();

  int get key;
  String get account;
  Amount get amount;

  static void _initializeBuilder(PostingBuilder b) => b
    ..key = -1
    ..account = '';

  @override
  String toString() {
    final int padding = max(
        2,
        (amount?.commodityOnLeft ?? true)
            ? 52 - 4 - account.length - 2 - amount.toString().length
            : 52 - 4 - account.length - 2 - amount.quantity.toString().length);
    return '    $account  ${' ' * padding}$amount'.trimRight();
  }
}

abstract class Amount implements Built<Amount, AmountBuilder> {
  factory Amount([void Function(AmountBuilder) updates]) = _$Amount;
  Amount._();

  String get commodity;
  String get quantity;
  @nullable
  bool get commodityOnLeft;
  @nullable
  int get spacing;

  static void _initializeBuilder(AmountBuilder b) => b
    ..quantity = ''
    ..commodity = '';

  @override
  String toString() {
    if (commodityOnLeft ?? true) {
      return '${commodity ?? ''}${' ' * (spacing ?? 0)}$quantity';
    } else {
      return '$quantity${' ' * (spacing ?? 0)}${commodity ?? ''}';
    }
  }
}
