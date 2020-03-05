// ignore_for_file: prefer_function_declarations_over_variables

import 'package:cone_lib/cone_lib.dart'
    show
        Amount,
        AmountBuilder,
        Journal,
        Posting,
        Transaction,
        TransactionBuilder;
import 'package:cone_lib/pad_zeros.dart' show padZeros;
import 'package:intl/intl.dart' show DateFormat;
import 'package:reselect/reselect.dart'
    show createSelector1, createSelector2, Selector;

import 'package:cone/src/redux/state.dart';
import 'package:cone/src/utils.dart'
    show
        accounts,
        descriptions,
        emptyPostingFields,
        filterSuggestions,
        implicitTransaction,
        reducePostingFields,
        sortSuggestions;

final Selector<ConeState, DateFormat> reselectDateFormat = createSelector1(
  reselectTransactions,
  (List<Transaction> transactions) => (transactions.isEmpty)
      ? DateFormat('yyyy-MM-dd')
      : ((transactions.last.date.contains('/'))
          ? DateFormat('yyyy/MM/dd')
          : ((transactions.last.date.contains('.'))
              ? DateFormat('yyyy.MM.dd')
              : DateFormat('yyyy-MM-dd'))),
);

final Selector<ConeState, Journal> reselectJournal = createSelector1(
  (ConeState state) => state.contents,
  (String contents) => Journal(contents: contents),
);

final Selector<ConeState, bool> descriptionIsEmpty = createSelector1(
  (ConeState state) => state.transaction.description,
  (String description) => description?.isEmpty ?? true,
);

final Selector<ConeState, List<List<bool>>> emptyPostingsFields =
    createSelector1(
  (ConeState state) => state.transaction.postings.toList(),
  (List<Posting> postings) => postings.map(emptyPostingFields).toList(),
);

final Selector<ConeState, List<int>> reducePostingsFields = createSelector1(
  (ConeState state) => state.transaction.postings.toList(),
  (List<Posting> postings) => postings.map(reducePostingFields).toList(),
);

final Selector<ConeState, bool> needsNewPosting = createSelector1(
  reducePostingsFields,
  (List<int> reduction) => reduction.every((int row) => row > 0),
);

bool validTransaction(ConeState state) {
  final List<int> reduction = state.transaction.postings
      .map(
        reducePostingFields,
      )
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

// final Selector<ConeState, bool> validTransaction = createSelector2(
//   descriptionIsEmpty,
//   reducePostingsFields,
//   (bool descriptionIsEmpty, List<int> reduction) {
//     print(reduction);
//     final bool atLeastTwoAccounts =
//         reduction.where((int n) => n % 2 == 1).toList().length >= 2;
//     final bool atLeastOneQuantity = reduction.any((int n) => n >= 2);
//     final bool allQuantitiesHaveAccounts = !reduction.contains(2);
//     final bool atMostOneEmptyQuantity =
//         reduction.where((int n) => n == 1).toList().length <= 1;
//     return !descriptionIsEmpty &&
//         atLeastTwoAccounts &&
//         atLeastOneQuantity &&
//         allQuantitiesHaveAccounts &&
//         atMostOneEmptyQuantity;
//   },
// );

final Selector<ConeState, List<Transaction>> reselectTransactions =
    createSelector1(
  reselectJournal,
  (Journal journal) => journal.journalItems.whereType<Transaction>().toList(),
);

final Selector<ConeState, bool> makeSaveButtonAvailable = createSelector2(
  (ConeState state) => state.debugMode,
  validTransaction,
  (bool debugMode, bool validTransaction) => debugMode || validTransaction,
);

final Selector<ConeState, String> formattedExample =
    (ConeState state) => Amount(
          (AmountBuilder b) => b
            ..commodity = state.defaultCurrency
            ..commodityOnLeft = state.currencyOnLeft
            ..quantity = padZeros(
              locale: state.numberLocale,
              quantity: '5',
              commodity: state.defaultCurrency,
            )
            ..spacing = state.spacing.index,
        ).toString();

final Selector<ConeState, String> formattedTransaction = (ConeState state) {
  final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //ignore: lines_longer_than_80_chars
  return '${state.transaction.rebuild((TransactionBuilder b) => b..date = state.transaction.date ?? today)}';
};

final Selector<ConeState, Transaction> reselectImplicitTransaction =
    (ConeState state) {
  return implicitTransaction(
    date: state.date,
    defaultCommodity: state.defaultCurrency,
    padZeros: ({String quantity, String commodity}) => padZeros(
      locale: state.numberLocale,
      quantity: quantity,
      commodity: commodity,
    ),
    transaction: state.transaction,
  );
};

final Selector<ConeState, bool> hideAddTransactionButton =
    (ConeState state) => state.contents == null || state.saveInProgress;

final Selector<ConeState, String> quantityHint = (ConeState state) => padZeros(
      locale: state.numberLocale,
      quantity: '0',
      commodity: state.defaultCurrency,
    );

final Selector<ConeState, List<String> Function(String)>
    reselectDescriptionSuggestions = createSelector1(
  (ConeState state) => sortSuggestions(descriptions(reselectJournal(state))),
  (List<String> sortedDescriptions) =>
      (String pattern) => filterSuggestions(pattern, sortedDescriptions),
);

final Selector<ConeState, List<String> Function(String)>
    reselectAccountSuggestions = createSelector1(
  (ConeState state) => sortSuggestions(accounts(reselectJournal(state))),
  (List<String> sortedAccounts) =>
      (String pattern) => filterSuggestions(pattern, sortedAccounts),
);
