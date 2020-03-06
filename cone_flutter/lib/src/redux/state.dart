import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cone_lib/cone_lib.dart'
    show Posting, PostingBuilder, Transaction, TransactionBuilder;
import 'package:redux/redux.dart';
// ignore: unused_import
import 'package:redux_logging/redux_logging.dart' show LoggingMiddleware;

import 'package:cone/src/redux/middleware.dart';
import 'package:cone/src/redux/reducers.dart';
import 'package:cone/src/types.dart' show ConeBrightness, Spacing;

part 'state.g.dart';

abstract class ConeState implements Built<ConeState, ConeStateBuilder> {
  factory ConeState([void Function(ConeStateBuilder) updates]) = _$ConeState;
  ConeState._();

  @nullable
  ConeBrightness get brightness;
  @nullable
  Spacing get spacing;
  @nullable
  String get contents;
  @nullable
  String get date;
  @nullable
  String get defaultCurrency;
  @nullable
  String get ledgerFileDisplayName;
  @nullable
  String get ledgerFileUri;
  @nullable
  String get numberLocale;
  @nullable
  String get systemLocale;
  Transaction get transaction;
  @nullable
  bool get currencyOnLeft;
  @nullable
  bool get debugMode;
  bool get initialized;
  bool get isRefreshing;
  @nullable
  bool get reverseSort;
  bool get saveInProgress;
  int get postingKey;
  int get refreshCount;

  static void _initializeBuilder(ConeStateBuilder b) => b
    ..initialized = false
    ..isRefreshing = false
    ..postingKey = 2
    ..refreshCount = 0
    ..saveInProgress = false
    ..transaction = Transaction(
      (TransactionBuilder tb) => tb
        ..postings = BuiltList<Posting>(
          <Posting>[
            Posting((PostingBuilder b) => b..key = 0),
            Posting((PostingBuilder b) => b..key = 1),
          ],
        ).toBuilder(),
    ).toBuilder();
}

List<Middleware<ConeState>> coneMiddleware = <Middleware<ConeState>>[
  firstConeMiddleware,
  // LoggingMiddleware<ConeState>.printer(
  //     // formatter: coneLogFormatter,
  //     ),
];

String coneLogFormatter(
  dynamic state,
  dynamic action,
  DateTime timestamp,
) {
  return '{\n'
      '  Action: $action,\n'
      // '  State: $state,\n'
      '  Transaction: Transaction(\n'
      '      date: ${state.transaction.date},\n'
      '      description: ${state.transaction.description},\n'
      '      postings: <Posting>[\n'
      // ignore: lines_longer_than_80_chars
      '${state.transaction.postings.map((Posting posting) => '          Posting(\n'
          '              account: ${posting.account}\n'
          '              amount: Amount(\n'
          '                  quantity: ${posting.amount?.quantity}\n'
          '                  commodity: ${posting.amount?.commodity}\n'
          '              ),\n'
          '          ),\n').join('')}'
      '      ],\n'
      '  );\n'
      '  Timestamp: $timestamp\n'
      '}';
}

ConeState coneReducer(ConeState state, dynamic action) {
  return firstConeReducer(state, action);
}
