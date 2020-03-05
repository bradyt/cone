import 'package:built_collection/built_collection.dart';
import 'package:cone_lib/cone_lib.dart'
    show Posting, PostingBuilder, Transaction, TransactionBuilder;
import 'package:redux/redux.dart';
// ignore: unused_import
import 'package:redux_logging/redux_logging.dart' show LoggingMiddleware;

import 'package:cone/src/redux/middleware.dart';
import 'package:cone/src/redux/reducers.dart';
import 'package:cone/src/types.dart' show ConeBrightness, Spacing;

ConeState coneInitialState = ConeState(
  initialized: false,
  isRefreshing: false,
  postingKey: 2,
  refreshCount: 0,
  saveInProgress: false,
  transaction: Transaction(
    (TransactionBuilder tb) => tb
      ..postings = BuiltList<Posting>(
        <Posting>[
          Posting((PostingBuilder b) => b..key = 0),
          Posting((PostingBuilder b) => b..key = 1),
        ],
      ).toBuilder(),
  ),
);

class ConeState {
  const ConeState({
    this.brightness,
    this.contents,
    this.currencyOnLeft,
    this.date,
    this.debugMode,
    this.defaultCurrency,
    this.initialized,
    this.isRefreshing,
    this.ledgerFileDisplayName,
    this.ledgerFileUri,
    this.numberLocale,
    this.postingKey,
    this.refreshCount,
    this.reverseSort,
    this.saveInProgress,
    this.spacing,
    this.systemLocale,
    this.transaction,
  });

  final ConeBrightness brightness;
  final Spacing spacing;
  final String contents;
  final String date;
  final String defaultCurrency;
  final String ledgerFileDisplayName;
  final String ledgerFileUri;
  final String numberLocale;
  final String systemLocale;
  final Transaction transaction;
  final bool currencyOnLeft;
  final bool debugMode;
  final bool initialized;
  final bool isRefreshing;
  final bool reverseSort;
  final bool saveInProgress;
  final int postingKey;
  final int refreshCount;

  ConeState copyWith({
    ConeBrightness brightness,
    Spacing spacing,
    String contents,
    String date,
    String defaultCurrency,
    String ledgerFileDisplayName,
    String ledgerFileUri,
    String numberLocale,
    String systemLocale,
    Transaction transaction,
    bool currencyOnLeft,
    bool debugMode,
    bool initialized,
    bool isRefreshing,
    bool reverseSort,
    bool saveInProgress,
    int postingKey,
    int refreshCount,
  }) {
    return ConeState(
      brightness: brightness ?? this.brightness,
      contents: contents ?? this.contents,
      currencyOnLeft: currencyOnLeft ?? this.currencyOnLeft,
      date: date ?? this.date,
      debugMode: debugMode ?? this.debugMode,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      initialized: initialized ?? this.initialized,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      ledgerFileDisplayName:
          ledgerFileDisplayName ?? this.ledgerFileDisplayName,
      ledgerFileUri: ledgerFileUri ?? this.ledgerFileUri,
      numberLocale: numberLocale ?? this.numberLocale,
      postingKey: postingKey ?? this.postingKey,
      refreshCount: refreshCount ?? this.refreshCount,
      reverseSort: reverseSort ?? this.reverseSort,
      saveInProgress: saveInProgress ?? this.saveInProgress,
      spacing: spacing ?? this.spacing,
      systemLocale: systemLocale ?? this.systemLocale,
      transaction: transaction ?? this.transaction,
    );
  }

//   @override
//   String toString() {
//     return '''
// ConeState(
//       brightness: '$brightness',
//       contents: '${contents?.split('\n')?.elementAt(0)}...',
//       currencyOnLeft: '$currencyOnLeft',
//       debugMode: '$debugMode',
//       defaultCurrency: '$defaultCurrency',
//       initialized: '$initialized',
//       isRefreshing: '$isRefreshing',
//       ledgerFileDisplayName:'$ledgerFileDisplayName',
//       ledgerFileUri: '$ledgerFileUri',
//       numberLocale: '$numberLocale',
//       postingKey: '$postingKey',
//       refreshCount: '$refreshCount',
//       reverseSort: '$reverseSort',
//       saveInProgress: '$saveInProgress',
//       spacing: '$spacing',
//       systemLocale: '$systemLocale',
//       transaction: '$transaction',
//   );''';
//   }
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
