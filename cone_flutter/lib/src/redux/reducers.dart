import 'package:built_collection/built_collection.dart';
import 'package:cone_lib/cone_lib.dart'
    show Posting, PostingBuilder, Transaction, TransactionBuilder;

import 'package:cone/src/redux/actions.dart';
import 'package:cone/src/redux/state.dart';
import 'package:cone/src/reselect.dart';
import 'package:cone/src/types.dart' show ConeBrightness, Spacing;
import 'package:cone/src/utils.dart'
    show localeCurrency, localeCurrencyOnLeft, localeSpacing;

ConeState firstConeReducer(ConeState state, dynamic action) {
  if (action is InitializeSettingsAction) {
    return state.copyWith(
      brightness: ConeBrightness.values[action.settings.brightness ?? 0],
      currencyOnLeft: action.settings.currencyOnLeft ??
          localeCurrencyOnLeft(state.systemLocale),
      debugMode: action.settings.debugMode ?? false,
      defaultCurrency:
          action.settings.defaultCurrency ?? localeCurrency(state.systemLocale),
      initialized: true,
      ledgerFileUri: action.settings.ledgerFileUri,
      ledgerFileDisplayName: action.settings.ledgerFileDisplayName,
      numberLocale: action.settings.numberLocale ?? state.systemLocale,
      reverseSort: action.settings.reverseSort ?? true,
      spacing: Spacing
          .values[action.settings.spacing ?? localeSpacing(state.systemLocale)],
    );
  } else if (action is UpdateSystemLocaleAction) {
    return state.copyWith(
      systemLocale: action.systemLocale,
    );
  } else if (action == Actions.addPosting) {
    return state.copyWith(
      postingKey: state.postingKey + 1,
      transaction: state.transaction.rebuild(
        (TransactionBuilder tb) => tb.postings = tb.postings
          ..add(
            Posting(
              (PostingBuilder pb) => pb.key = state.postingKey,
            ),
          ),
      ),
    );
  } else if (action is RemovePostingAtAction) {
    return state.copyWith(
      transaction: state.transaction.rebuild(
        (TransactionBuilder tb) => tb.postings = tb.postings
          ..removeAt(
            action.index,
          ),
      ),
    );
  } else if (action == Actions.resetTransaction) {
    return state.copyWith(
      postingKey: state.postingKey + 2,
      transaction: Transaction(
        (TransactionBuilder tb) => tb
          ..postings = ListBuilder<Posting>(
            <Posting>[
              Posting((PostingBuilder b) => b..key = state.postingKey),
              Posting((PostingBuilder b) => b..key = state.postingKey + 1),
            ],
          ),
      ),
    );
  } else if (action is UpdateHintDateAction) {
    return state.copyWith(
      date: reselectDateFormat(state).format(action.date),
    );
  } else if (action is UpdateDateAction) {
    return state.copyWith(
      transaction: state.transaction.rebuild(
        (TransactionBuilder b) => b..date = action.date,
      ),
    );
  } else if (action is UpdateDescriptionAction) {
    return state.copyWith(
      transaction: state.transaction.rebuild(
        (TransactionBuilder b) => b..description = action.description,
      ),
    );
  } else if (action is UpdateAccountAction) {
    return state.copyWith(
      transaction: state.transaction.rebuild(
        (TransactionBuilder tb) =>
            tb.postings[action.index] = tb.postings[action.index].rebuild(
          (PostingBuilder pb) => pb.account = action.account,
        ),
      ),
    );
  } else if (action is UpdateQuantityAction) {
    return state.copyWith(
      transaction: state.transaction.rebuild(
        (TransactionBuilder tb) =>
            tb.postings[action.index] = tb.postings[action.index].rebuild(
          (PostingBuilder pb) =>
              pb.amount = pb.amount..quantity = action.quantity,
        ),
      ),
    );
  } else if (action is UpdateCommodityAction) {
    return state.copyWith(
      transaction: state.transaction.rebuild(
        (TransactionBuilder tb) =>
            tb.postings[action.index] = tb.postings[action.index].rebuild(
          (PostingBuilder pb) =>
              pb.amount = pb.amount..commodity = action.commodity,
        ),
      ),
    );
  } else if (action is UpdateSettingsAction) {
    ConeState newState;
    switch (action.key) {
      case 'debug_mode':
        newState = state.copyWith(debugMode: action.value as bool);
        break;
      case 'default_currency':
        newState = state.copyWith(defaultCurrency: action.value as String);
        break;
      case 'ledger_file_uri':
        newState = state.copyWith(ledgerFileUri: action.value as String);
        break;
      case 'ledger_file_display_name':
        newState =
            state.copyWith(ledgerFileDisplayName: action.value as String);
        break;
      case 'number_locale':
        newState = state.copyWith(numberLocale: action.value as String);
        break;
      case 'currency_on_left':
        newState = state.copyWith(currencyOnLeft: action.value as bool);
        break;
      case 'spacing':
        newState = state.copyWith(spacing: action.value as Spacing);
        break;
      case 'reverse_sort':
        newState = state.copyWith(reverseSort: action.value as bool);
        break;
      default:
        newState = state;
    }
    return newState;
  } else if (action == Actions.refreshFileContents) {
    return state.copyWith(
      isRefreshing: true,
    );
  } else if (action is UpdateContentsAction) {
    return state.copyWith(
      contents: action.contents,
      isRefreshing: false,
      refreshCount: state.refreshCount + 1,
    );
  } else if (action == Actions.markInitialized) {
    return state.copyWith(
      initialized: true,
    );
  } else if (action is SetBrightness) {
    return state.copyWith(
      brightness: action.brightness,
    );
  }

  return state;
}
