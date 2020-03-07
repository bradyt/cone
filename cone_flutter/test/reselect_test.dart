// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';

import 'package:built_collection/built_collection.dart';
import 'package:cone_lib/cone_lib.dart'
    show
        Amount,
        AmountBuilder,
        Posting,
        PostingBuilder,
        Transaction,
        TransactionBuilder;

import 'package:cone/src/redux/state.dart' show ConeState, ConeStateBuilder;
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

import '../test/utils_test.dart';

void main() {
  final ConeState state = ConeState(
    (ConeStateBuilder b) => b
      ..numberLocale = 'en'
      ..spacing = Spacing.zero
      ..contents = ''
      ..defaultCurrency = ''
      ..reverseSort = false,
  );
  test('Test formattedExample.', () {
    expect(formattedExample(state), '5.00');
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
    test('Test an invalid transaction.', () {
      expect(
          validTransaction(ConeState(
              (ConeStateBuilder b) => b..transaction = TransactionBuilder())),
          false);
    });
    test('Test a valid transaction.', () {
      expect(
          validTransaction(ConeState((ConeStateBuilder b) => b
            ..transaction = Transaction()
                .copyWith(
              date: '1970-01-01',
              description: 'example transaction',
            )
                .addAllPostings(<Posting>[
              Posting().copyWith(
                  account: 'a', amount: Amount().copyWith(quantity: '0')),
              Posting().copyWith(account: 'a'),
              Posting(),
            ]).toBuilder())),
          true);
    });
    test('Test atLeastTwoAccounts.', () {
      expect(
          validTransaction(
            ConeState(
              (ConeStateBuilder b) => b
                ..transaction = Transaction(
                  (TransactionBuilder tb) => tb
                    ..postings = BuiltList<Posting>(
                      <Posting>[
                        Posting(
                          (PostingBuilder b) => b
                            ..account = 'a'
                            ..amount = Amount(
                              (AmountBuilder b) => b..quantity = '0',
                            ).toBuilder(),
                        ),
                      ],
                    ).toBuilder(),
                ).toBuilder(),
            ),
          ),
          false);
    });
    test('Test atLeastOneQuantity.', () {
      expect(
          validTransaction(
            ConeState(
              (ConeStateBuilder b) => b
                ..transaction = Transaction(
                  (TransactionBuilder tb) => tb
                    ..postings = BuiltList<Posting>(
                      <Posting>[
                        Posting(
                          (PostingBuilder b) => b..account = 'a',
                        ),
                      ],
                    ).toBuilder(),
                ).toBuilder(),
            ),
          ),
          false);
    });
    test('Test allQuantitiesHaveAccounts.', () {
      expect(
          validTransaction(
            ConeState(
              (ConeStateBuilder b) => b
                ..transaction = Transaction(
                  (TransactionBuilder tb) => tb
                    ..postings = ListBuilder<Posting>(
                      <Posting>[
                        Posting(
                          (PostingBuilder b) => b
                            ..amount = Amount(
                              (AmountBuilder b) => b..quantity = '0',
                            ).toBuilder(),
                        ),
                      ],
                    ),
                ).toBuilder(),
            ),
          ),
          false);
    });
    test('Test atMostOneEmptyQuantity.', () {
      expect(
          validTransaction(
            ConeState(
              (ConeStateBuilder b) => b
                ..transaction = Transaction(
                  (TransactionBuilder tb) => tb
                    ..postings = ListBuilder<Posting>(
                      <Posting>[
                        Posting((PostingBuilder b) => b..account = 'a'),
                        Posting((PostingBuilder b) => b..account = 'a'),
                      ],
                    ),
                ).toBuilder(),
            ),
          ),
          false);
    });
  });
}
