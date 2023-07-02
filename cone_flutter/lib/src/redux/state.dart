import 'package:built_value/built_value.dart';
import 'package:cone_lib/cone_lib.dart'
    show Journal, JournalBuilder, Posting, Transaction, TransactionBuilder;
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

  ConeBrightness? get brightness;
  DateTime? get today;
  Journal? get journal;
  Spacing get spacing;
  String? get contents;
  String? get ledgerFileDisplayName;
  String? get ledgerFileUri;
  String get numberLocale;
  String? get systemLocale;
  Transaction get transaction;
  Transaction get hintTransaction;
  bool get currencyOnLeft;
  bool? get debugMode;
  bool get initialized;
  bool get isRefreshing;
  bool? get reverseSort;
  bool get saveInProgress;
  int get postingKey;
  int get refreshCount;
  int get transactionIndex;

  static void _initializeBuilder(ConeStateBuilder b) => b
    ..initialized = false
    ..isRefreshing = false
    ..postingKey = 0
    ..refreshCount = 0
    ..saveInProgress = false
    ..transactionIndex = -1
    ..spacing = Spacing.one
    ..currencyOnLeft = false
    ..numberLocale = 'en_US';
}

List<Middleware<ConeState>> coneMiddleware = <Middleware<ConeState>>[
  firstConeMiddleware,
  isolateRefreshConeMiddleware,
  // LoggingMiddleware<ConeState>.printer(
  //     // formatter: coneLogFormatter,
  //     ),
];

List<Middleware<ConeState>> widgetTestConeMiddleware = <Middleware<ConeState>>[
  firstConeMiddleware,
  widgetTestRefreshConeMiddleware,
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
          '                  quantity: ${posting.amount.quantity}\n'
          '                  commodity: ${posting.amount.commodity}\n'
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
