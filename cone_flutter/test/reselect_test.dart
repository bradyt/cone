// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';

import 'package:cone_lib/cone_lib.dart' show Amount, Posting, Transaction;

import 'package:cone/src/redux/state.dart' show ConeState;
import 'package:cone/src/reselect.dart'
    show
        formattedExample,
        // hideAddTransactionButton,
        // makeSaveButtonAvailable,
        quantityHint,
        reselectAccountSuggestions,
        reselectDescriptionSuggestions,
        reselectTransactions,
        validTransaction;
import 'package:cone/src/types.dart' show Spacing;

void main() {
  const ConeState state = ConeState(
    numberLocale: 'en',
    spacing: Spacing.zero,
    contents: '',
  );
  test('Test formattedExample.', () {
    expect(formattedExample(state), 'null5.00');
  });
  test('Test reselectTransactions.', () {
    expect(reselectTransactions(state), <Transaction>[]);
  });
  // test('Test makeSaveButtonAvailable.', () {
  //   expect(makeSaveButtonAvailable(state), true);
  // });
  // test('Test hideAddTransactionButton.', () {
  //   expect(hideAddTransactionButton(state), true);
  // });
  test('Test quantityHint.', () {
    expect(quantityHint(state), '0.00');
  });
  test('Test reselectDescriptionSuggestions.', () {
    expect(reselectDescriptionSuggestions(state)(''), <String>[]);
  });
  test('Test reselectAccountSuggestions.', () {
    expect(reselectAccountSuggestions(state)(''), <String>[]);
  });
  group('Test validTransaction.', () {
    test('Test validTransaction.', () {
      expect(
          validTransaction(
              ConeState(transaction: Transaction(postings: <Posting>[]))),
          false);
    });
    // test('Test validTransaction.', () {
    //   expect(
    //       validTransaction(ConeState(
    //           transaction: Transaction(postings: <Posting>[
    //         Posting(account: 'a', amount: Amount(quantity: '0')),
    //         Posting(account: 'b'),
    //         Posting(),
    //       ]))),
    //       true);
    // });
    test('Test atLeastTwoAccounts.', () {
      expect(
          validTransaction(ConeState(
              transaction: Transaction(postings: <Posting>[
            Posting(account: 'a', amount: Amount(quantity: '0')),
          ]))),
          false);
    });
    test('Test atLeastOneQuantity.', () {
      expect(
          validTransaction(ConeState(
              transaction: Transaction(postings: <Posting>[
            Posting(account: 'a'),
          ]))),
          false);
    });
    test('Test allQuantitiesHaveAccounts.', () {
      expect(
          validTransaction(ConeState(
              transaction: Transaction(postings: <Posting>[
            Posting(amount: Amount(quantity: '0')),
          ]))),
          false);
    });
    test('Test atMostOneEmptyQuantity.', () {
      expect(
          validTransaction(ConeState(
              transaction: Transaction(postings: <Posting>[
            Posting(account: 'a'),
            Posting(account: 'a'),
          ]))),
          false);
    });
  });
}
