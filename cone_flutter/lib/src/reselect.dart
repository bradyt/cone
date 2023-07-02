// ignore_for_file: prefer_function_declarations_over_variables

import 'package:cone_lib/cone_lib.dart'
    show
        CommodityDirective,
        Journal,
        JournalItem,
        Posting,
        Transaction,
        TransactionBuilder;
import 'package:cone_lib/pad_zeros.dart' show padZeros;
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;
import 'package:built_collection/built_collection.dart';
import 'package:reselect/reselect.dart'
    show createSelector1, createSelector2, createSelector3, Selector;

import 'package:cone/src/redux/state.dart';
import 'package:cone/src/utils.dart'
    show
        accounts,
        blendHintTransaction,
        descriptions,
        emptyPostingFields,
        filterSuggestions,
        implicitTransaction,
        reducePostingFields,
        sortSuggestions;

final Iterable<MapEntry<String?, String?>> localeCommodities =
    numberFormatSymbols.entries.map<MapEntry<String?, String?>>(
  (MapEntry<dynamic, dynamic> entry) => MapEntry<String?, String?>(
    entry.key as String?,
    entry.value.DEF_CURRENCY_CODE as String?,
  ),
);

final Selector<ConeState, Iterable<MapEntry<String?, String?>>>
    reselectLocaleCommodities = createSelector1(
  (ConeState state) => state.systemLocale,
  (String? locale) {
    final int localeIndex = Iterable<int>.generate(localeCommodities.length)
        .firstWhere(
            (int index) => localeCommodities.elementAt(index).key == locale,
            orElse: () => -1);
    return (localeIndex == -1)
        ? localeCommodities
        : Iterable<MapEntry<String?, String?>>.generate(
            localeCommodities.length,
            (int index) {
              if (index == 0) {
                return localeCommodities.elementAt(localeIndex);
              } else if (index <= localeIndex) {
                return localeCommodities.elementAt(index - 1);
              } else {
                return localeCommodities.elementAt(index);
              }
            },
          );
  },
);

final Selector<ConeState, Iterable<String>> reselectJournalCommodities =
    createSelector1(
  (ConeState state) => state.journal!.journalItems,
  (BuiltList<JournalItem> journalItems) {
    final List<String> commodities = <String>[];
    for (final JournalItem journalItem in journalItems) {
      if (journalItem is CommodityDirective) {
        commodities.add(journalItem.commodity);
      } else if (journalItem is Transaction) {
        for (final Posting posting in journalItem.postings) {
          final String commodity = posting.amount.commodity;
          if (commodity.isNotEmpty) {
            commodities.add(commodity);
          }
        }
      }
    }
    final List<String> sortedByRecency = <String>[];
    for (final String commodity in commodities.reversed) {
      if (!sortedByRecency.contains(commodity)) {
        sortedByRecency.add(commodity);
      }
    }
    return sortedByRecency;
  },
);

final Selector<ConeState, Iterable<MapEntry<String?, String?>>>
    reselectCommodities = createSelector2(
  reselectLocaleCommodities,
  reselectJournalCommodities,
  (Iterable<MapEntry<String?, String?>> localeCommodities,
      Iterable<String> journalCommodities) {
    return Iterable<MapEntry<String?, String?>>.generate(
      journalCommodities.length + localeCommodities.length,
      (int index) => (index < journalCommodities.length)
          ? MapEntry<String, String>(
              '',
              journalCommodities.elementAt(index),
            )
          : localeCommodities.elementAt(
              index - journalCommodities.length,
            ),
    );
  },
);

final Selector<ConeState, Transaction> reselectHintTransaction =
    createSelector1(
  (ConeState state) => state,
  (ConeState state) => (state.transactionIndex == -1)
      ? Transaction()
      : reselectTransactions(state).elementAt(state.transactionIndex),
);

final Selector<ConeState, DateFormat> reselectDateFormat = createSelector1(
  reselectTransactions,
  (BuiltList<Transaction> transactions) => (transactions.isEmpty)
      ? DateFormat('yyyy-MM-dd')
      : ((transactions.last.date.contains('/'))
          ? DateFormat('yyyy/MM/dd')
          : ((transactions.last.date.contains('.'))
              ? DateFormat('yyyy.MM.dd')
              : DateFormat('yyyy-MM-dd'))),
);

// final Selector<ConeState, Journal> reselectJournal = createSelector1(
//   (ConeState state) => state.contents,
//   (String contents) => Journal(contents: contents),
// );

final Selector<ConeState, bool> descriptionIsEmpty = createSelector1(
  (ConeState state) => state.transaction.description,
  (String? description) => description?.isEmpty ?? true,
);

final Selector<ConeState, List<List<bool>>> emptyPostingsFields =
    createSelector1(
  (ConeState state) => blendHintTransaction(
    transaction: state.transaction,
    hintTransaction: state.hintTransaction,
  ).postings.toList(),
  (List<Posting> postings) => postings.map(emptyPostingFields).toList(),
);

final Selector<ConeState, List<int>> reducePostingsFields = createSelector1(
  (ConeState state) => blendHintTransaction(
    transaction: state.transaction,
    hintTransaction: state.hintTransaction,
  ).postings.toList(),
  (List<Posting> postings) => postings.map(reducePostingFields).toList(),
);

final Selector<ConeState, bool> needsNewPosting = createSelector2(
  reducePostingsFields,
  (ConeState state) => state.transaction.postings.length < 2,
  (List<int> reduction, bool tooFew) =>
      tooFew || reduction.every((int row) => row > 0),
);

bool validTransaction(ConeState state) {
  final List<int> reduction = blendHintTransaction(
          transaction: state.transaction,
          hintTransaction: state.hintTransaction)
      .postings
      .map(reducePostingFields)
      .toList();
  final bool atLeastTwoAccounts =
      reduction.where((int n) => n % 2 == 1).toList().length >= 2;
  final bool atLeastOneQuantity = reduction.any((int n) => n >= 2);
  final bool allQuantitiesHaveAccounts = !reduction.contains(2);
  final bool atMostOneEmptyQuantity =
      reduction.where((int n) => n == 1).toList().length <= 1;
  return atLeastTwoAccounts &&
      atLeastOneQuantity &&
      allQuantitiesHaveAccounts &&
      atMostOneEmptyQuantity;
}

final Selector<ConeState, BuiltList<Transaction>> reselectTransactions =
    createSelector2(
  (ConeState state) => state.journal,
  (ConeState state) => state.reverseSort,
  (Journal? journal, bool? reverseSort) => reverseSort!
      ? journal!.journalItems.reversed.whereType<Transaction>().toBuiltList()
      : journal!.journalItems.whereType<Transaction>().toBuiltList(),
);

final Selector<ConeState, bool> makeSaveButtonAvailable = createSelector3(
  (ConeState state) => state.debugMode,
  (ConeState state) => state.saveInProgress,
  validTransaction,
  (bool? debugMode, bool saveInProgress, bool validTransaction) =>
      (debugMode! || validTransaction) && !saveInProgress,
);

final Selector<ConeState, String> formattedTransaction = (ConeState state) {
  //ignore: lines_longer_than_80_chars
  return '${state.transaction.rebuild((TransactionBuilder b) => b..date = state.transaction.date)}';
};

final Selector<ConeState, Transaction> reselectImplicitTransaction =
    (ConeState state) {
  return implicitTransaction(
    defaultCommodity: reselectCommodities(state).first.value,
    hintTransaction: state.hintTransaction,
    padZeros: ({String? quantity, String? commodity}) => padZeros(
      locale: state.numberLocale,
      quantity: quantity,
      commodity: commodity,
    ),
    transaction: state.transaction,
  );
};

final Selector<ConeState, bool> hideAddTransactionButton = (ConeState state) =>
    state.contents == null || state.saveInProgress || state.isRefreshing;

final Selector<ConeState, String> quantityHint = (ConeState state) => padZeros(
      locale: state.numberLocale,
      quantity: '0',
      commodity: reselectCommodities(state).first.value,
    );

final Selector<ConeState, List<String> Function(String)>
    reselectDescriptionSuggestions = createSelector1(
  (ConeState state) => sortSuggestions(descriptions(state.journal!)),
  (List<String> sortedDescriptions) =>
      (String pattern) => filterSuggestions(pattern, sortedDescriptions),
);

final Selector<ConeState, List<String> Function(String)>
    reselectAccountSuggestions = createSelector1(
  (ConeState state) => sortSuggestions(accounts(state.journal!)),
  (List<String> sortedAccounts) =>
      (String pattern) => filterSuggestions(pattern, sortedAccounts),
);
