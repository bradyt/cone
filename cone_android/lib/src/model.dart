import 'package:cone_lib/cone_lib.dart'
    show getChunks, padZeros, Posting, Transaction;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart' show Provider;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cone/src/state_management/file_model.dart';
import 'package:cone/src/state_management/format_model.dart';
import 'package:cone/src/state_management/settings_model.dart';
import 'package:cone/src/state_management/suggestions_model.dart';
import 'package:cone/src/state_management/transaction_model.dart';
import 'package:cone/src/state_management/posting_model.dart';

class ConeModel extends ChangeNotifier {
  //
  // Constructor
  //

  ConeModel({@required SharedPreferences sharedPreferences})
      : assert(sharedPreferences != null,
            'Please wait for shared preferences before initializing model'),
        _settings = SettingsModel(sharedPreferences: sharedPreferences),
        _file = FileModel(uri: sharedPreferences.getString('ledger_file_uri')),
        _suggestions = SuggestionsModel(),
        _transaction = TransactionModel(),
        _format = FormatModel() {
    refreshFileContents();
    resetTransaction();
  }

  //
  // Provider
  //

  static ConeModel of(BuildContext context, {bool listen}) {
    return Provider.of<ConeModel>(context, listen: listen ?? true);
  }

  //
  // Models
  //

  final SettingsModel _settings;
  final FileModel _file;
  final SuggestionsModel _suggestions;
  final TransactionModel _transaction;
  final FormatModel _format;

  //
  // Transactions (draft, todo)
  //

  List<String> _chunks;
  List<String> get chunks => _chunks;

  //
  // Settings
  //

  bool get debugMode => _settings.debugMode;
  String get numberLocale => _settings.numberLocale;
  String get defaultCurrency => _settings.defaultCurrency;
  bool get currencyOnLeft => _settings.currencyOnLeft;
  Spacing get spacing => _settings.spacing;
  String get ledgerFileUri => _settings.ledgerFileUri;
  String get ledgerFileDisplayName => _settings.ledgerFileDisplayName;
  String get ledgerFileAlias => _file.alias;
  String get formattedExample {
    final String amount = padZeros(
      locale: numberLocale,
      amount: '5',
      currency: defaultCurrency,
    );
    final String insertSpacing = (spacing == Spacing.zero) ? '' : ' ';
    if (currencyOnLeft) {
      return '$defaultCurrency$insertSpacing$amount';
    } else {
      return '$amount$insertSpacing$defaultCurrency';
    }
  }

  bool get reverseSort => _settings.reverseSort;
  ConeBrightness get brightness => _settings.brightness;

  void toggleDebugMode() {
    _settings.toggleDebugMode();
    notifyListeners();
  }

  void setNumberLocale(String _numberLocale) {
    if (_numberLocale != null) {
      _settings.numberLocale = _numberLocale;
      notifyListeners();
    }
  }

  void setDefaultCurrency(String _defaultCurrency) {
    if (_defaultCurrency != null) {
      _settings.defaultCurrency = _defaultCurrency;
      notifyListeners();
    }
  }

  void toggleCurrencyOnLeft() {
    _settings.toggleCurrencyOnLeft();
    notifyListeners();
  }

  void toggleSpacing() {
    _settings.toggleSpacing();
    notifyListeners();
  }

  void toggleSort() {
    _settings.toggleSort();
    notifyListeners();
  }

  void setLedgerFile(String _ledgerFileUri, String _ledgerFileDisplayName) {
    _settings.setLedgerFile(_ledgerFileUri, _ledgerFileDisplayName);
    notifyListeners();
  }

  void setBrightness(ConeBrightness value) {
    _settings.setBrightness(value);
    notifyListeners();
  }

  //
  // File
  //

  String get fileContents => _file.contents;
  String get dateFormat => _file.dateFormat;
  bool get isRefreshingFileContents => _file.isRefreshingContents;
  bool get hideAddTransactionButton =>
      (fileContents == null) || isRefreshingFileContents;

  Future<void> pickLedgerFileUri() async {
    await _file.pickUri(debugMode: debugMode);
    _settings.setLedgerFile(_file.uri, _file.displayName);
    await refreshFileContents();
  }

  Future<void> refreshFileContents() async {
    await _file.refreshContents(notifyListeners: notifyListeners);
    _suggestions.updateSuggestions(fileContents: _file?.contents ?? '');
    _chunks = getChunks(_file?.contents ?? '');
  }

  //
  // Suggestions
  //

  List<String> descriptionSuggestions(String text) {
    return _suggestions.descriptionSuggestions(text);
  }

  List<String> accountSuggestions(String text) {
    return _suggestions.accountSuggestions(text);
  }

  //
  // Save
  //

  bool get saveInProgress => _file.saveInProgress;

  bool get makeSaveButtonAvailable =>
      !saveInProgress && (debugMode || !transactionIsNotValid);

  Future<void> appendTransaction(String transaction) async {
    try {
      await _file.appendTransaction(
        transaction: transaction,
        notifyListeners: notifyListeners,
      );
    } on PlatformException catch (_) {
      rethrow;
    }
  }

  //
  // Transaction
  //

  void resetTransaction() {
    _transaction.reset(
      notifyListeners: notifyListeners,
      defaultCurrency: defaultCurrency,
      dateFormat: dateFormat,
    );
  }

  TextEditingController get dateController => _transaction.dateController;
  TextEditingController get descriptionController =>
      _transaction.descriptionController;
  FocusNode get dateFocus => _transaction.dateFocus;
  FocusNode get descriptionFocus => _transaction.descriptionFocus;
  SuggestionsBoxController get suggestionsBoxController =>
      _transaction.suggestionsBoxController;
  List<PostingModel> get postingModels => _transaction.postingModels;

  void ensurePostingsAreNotFull() => _transaction.ensurePostingsAreNotFull(
        defaultCurrency: defaultCurrency,
        notifyListeners: notifyListeners,
      );

  void removeAtAndNotifyListeners(int index) =>
      _transaction.removeAtAndNotifyListeners(
        index: index,
        notifyListeners: notifyListeners,
      );

  void closeSuggestionBoxControllers() =>
      _transaction.closeSuggestionBoxControllers();

  bool get transactionIsNotValid => _transaction.transactionIsNotValid;

  String formattedAmountHint(int i) => _transaction.formattedAmountHint(
        index: i,
        locale: numberLocale,
      );

  DateTime get initialDate {
    DateTime result;
    try {
      // dateFormat is from file_model
      result = DateFormat(dateFormat).parseStrict(dateController.text);
    } catch (_) {
      result = DateTime.now();
    }
    return result;
  }

  SnackBar snackBar(String transaction) => SnackBar(
        content: Text.rich(
          TextSpan(text: transaction),
          style: const TextStyle(
            fontFamily: 'IBMPlexMono',
          ),
        ),
      );

  //
  // Format
  //

  String formattedTransaction() => _format.formattedTransaction(
        locale: _settings.numberLocale,
        transaction: Transaction(
          date: dateController.text,
          description: descriptionController.text,
          postings: postingModels
              .map((PostingModel pb) => Posting(
                    account: pb.accountController.text,
                    amount: pb.amountController.text,
                    currency: pb.currencyController.text,
                    currencyOnLeft: currencyOnLeft,
                  ))
              .toList(),
        ),
        currencyOnLeft: currencyOnLeft,
        spacing: spacing.index == 1,
      );
}
