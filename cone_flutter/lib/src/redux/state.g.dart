// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConeState extends ConeState {
  @override
  final ConeBrightness? brightness;
  @override
  final DateTime? today;
  @override
  final Journal? journal;
  @override
  final Spacing spacing;
  @override
  final String? contents;
  @override
  final String? ledgerFileDisplayName;
  @override
  final String? ledgerFileUri;
  @override
  final String numberLocale;
  @override
  final String? systemLocale;
  @override
  final Transaction transaction;
  @override
  final Transaction hintTransaction;
  @override
  final bool currencyOnLeft;
  @override
  final bool? debugMode;
  @override
  final bool initialized;
  @override
  final bool isRefreshing;
  @override
  final bool? reverseSort;
  @override
  final bool saveInProgress;
  @override
  final int postingKey;
  @override
  final int refreshCount;
  @override
  final int transactionIndex;

  factory _$ConeState([void Function(ConeStateBuilder)? updates]) =>
      (new ConeStateBuilder()..update(updates))._build();

  _$ConeState._(
      {this.brightness,
      this.today,
      this.journal,
      required this.spacing,
      this.contents,
      this.ledgerFileDisplayName,
      this.ledgerFileUri,
      required this.numberLocale,
      this.systemLocale,
      required this.transaction,
      required this.hintTransaction,
      required this.currencyOnLeft,
      this.debugMode,
      required this.initialized,
      required this.isRefreshing,
      this.reverseSort,
      required this.saveInProgress,
      required this.postingKey,
      required this.refreshCount,
      required this.transactionIndex})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(spacing, r'ConeState', 'spacing');
    BuiltValueNullFieldError.checkNotNull(
        numberLocale, r'ConeState', 'numberLocale');
    BuiltValueNullFieldError.checkNotNull(
        transaction, r'ConeState', 'transaction');
    BuiltValueNullFieldError.checkNotNull(
        hintTransaction, r'ConeState', 'hintTransaction');
    BuiltValueNullFieldError.checkNotNull(
        currencyOnLeft, r'ConeState', 'currencyOnLeft');
    BuiltValueNullFieldError.checkNotNull(
        initialized, r'ConeState', 'initialized');
    BuiltValueNullFieldError.checkNotNull(
        isRefreshing, r'ConeState', 'isRefreshing');
    BuiltValueNullFieldError.checkNotNull(
        saveInProgress, r'ConeState', 'saveInProgress');
    BuiltValueNullFieldError.checkNotNull(
        postingKey, r'ConeState', 'postingKey');
    BuiltValueNullFieldError.checkNotNull(
        refreshCount, r'ConeState', 'refreshCount');
    BuiltValueNullFieldError.checkNotNull(
        transactionIndex, r'ConeState', 'transactionIndex');
  }

  @override
  ConeState rebuild(void Function(ConeStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConeStateBuilder toBuilder() => new ConeStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConeState &&
        brightness == other.brightness &&
        today == other.today &&
        journal == other.journal &&
        spacing == other.spacing &&
        contents == other.contents &&
        ledgerFileDisplayName == other.ledgerFileDisplayName &&
        ledgerFileUri == other.ledgerFileUri &&
        numberLocale == other.numberLocale &&
        systemLocale == other.systemLocale &&
        transaction == other.transaction &&
        hintTransaction == other.hintTransaction &&
        currencyOnLeft == other.currencyOnLeft &&
        debugMode == other.debugMode &&
        initialized == other.initialized &&
        isRefreshing == other.isRefreshing &&
        reverseSort == other.reverseSort &&
        saveInProgress == other.saveInProgress &&
        postingKey == other.postingKey &&
        refreshCount == other.refreshCount &&
        transactionIndex == other.transactionIndex;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, brightness.hashCode);
    _$hash = $jc(_$hash, today.hashCode);
    _$hash = $jc(_$hash, journal.hashCode);
    _$hash = $jc(_$hash, spacing.hashCode);
    _$hash = $jc(_$hash, contents.hashCode);
    _$hash = $jc(_$hash, ledgerFileDisplayName.hashCode);
    _$hash = $jc(_$hash, ledgerFileUri.hashCode);
    _$hash = $jc(_$hash, numberLocale.hashCode);
    _$hash = $jc(_$hash, systemLocale.hashCode);
    _$hash = $jc(_$hash, transaction.hashCode);
    _$hash = $jc(_$hash, hintTransaction.hashCode);
    _$hash = $jc(_$hash, currencyOnLeft.hashCode);
    _$hash = $jc(_$hash, debugMode.hashCode);
    _$hash = $jc(_$hash, initialized.hashCode);
    _$hash = $jc(_$hash, isRefreshing.hashCode);
    _$hash = $jc(_$hash, reverseSort.hashCode);
    _$hash = $jc(_$hash, saveInProgress.hashCode);
    _$hash = $jc(_$hash, postingKey.hashCode);
    _$hash = $jc(_$hash, refreshCount.hashCode);
    _$hash = $jc(_$hash, transactionIndex.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConeState')
          ..add('brightness', brightness)
          ..add('today', today)
          ..add('journal', journal)
          ..add('spacing', spacing)
          ..add('contents', contents)
          ..add('ledgerFileDisplayName', ledgerFileDisplayName)
          ..add('ledgerFileUri', ledgerFileUri)
          ..add('numberLocale', numberLocale)
          ..add('systemLocale', systemLocale)
          ..add('transaction', transaction)
          ..add('hintTransaction', hintTransaction)
          ..add('currencyOnLeft', currencyOnLeft)
          ..add('debugMode', debugMode)
          ..add('initialized', initialized)
          ..add('isRefreshing', isRefreshing)
          ..add('reverseSort', reverseSort)
          ..add('saveInProgress', saveInProgress)
          ..add('postingKey', postingKey)
          ..add('refreshCount', refreshCount)
          ..add('transactionIndex', transactionIndex))
        .toString();
  }
}

class ConeStateBuilder implements Builder<ConeState, ConeStateBuilder> {
  _$ConeState? _$v;

  ConeBrightness? _brightness;
  ConeBrightness? get brightness => _$this._brightness;
  set brightness(ConeBrightness? brightness) => _$this._brightness = brightness;

  DateTime? _today;
  DateTime? get today => _$this._today;
  set today(DateTime? today) => _$this._today = today;

  JournalBuilder? _journal;
  JournalBuilder get journal => _$this._journal ??= new JournalBuilder();
  set journal(JournalBuilder? journal) => _$this._journal = journal;

  Spacing? _spacing;
  Spacing? get spacing => _$this._spacing;
  set spacing(Spacing? spacing) => _$this._spacing = spacing;

  String? _contents;
  String? get contents => _$this._contents;
  set contents(String? contents) => _$this._contents = contents;

  String? _ledgerFileDisplayName;
  String? get ledgerFileDisplayName => _$this._ledgerFileDisplayName;
  set ledgerFileDisplayName(String? ledgerFileDisplayName) =>
      _$this._ledgerFileDisplayName = ledgerFileDisplayName;

  String? _ledgerFileUri;
  String? get ledgerFileUri => _$this._ledgerFileUri;
  set ledgerFileUri(String? ledgerFileUri) =>
      _$this._ledgerFileUri = ledgerFileUri;

  String? _numberLocale;
  String? get numberLocale => _$this._numberLocale;
  set numberLocale(String? numberLocale) => _$this._numberLocale = numberLocale;

  String? _systemLocale;
  String? get systemLocale => _$this._systemLocale;
  set systemLocale(String? systemLocale) => _$this._systemLocale = systemLocale;

  TransactionBuilder? _transaction;
  TransactionBuilder get transaction =>
      _$this._transaction ??= new TransactionBuilder();
  set transaction(TransactionBuilder? transaction) =>
      _$this._transaction = transaction;

  TransactionBuilder? _hintTransaction;
  TransactionBuilder get hintTransaction =>
      _$this._hintTransaction ??= new TransactionBuilder();
  set hintTransaction(TransactionBuilder? hintTransaction) =>
      _$this._hintTransaction = hintTransaction;

  bool? _currencyOnLeft;
  bool? get currencyOnLeft => _$this._currencyOnLeft;
  set currencyOnLeft(bool? currencyOnLeft) =>
      _$this._currencyOnLeft = currencyOnLeft;

  bool? _debugMode;
  bool? get debugMode => _$this._debugMode;
  set debugMode(bool? debugMode) => _$this._debugMode = debugMode;

  bool? _initialized;
  bool? get initialized => _$this._initialized;
  set initialized(bool? initialized) => _$this._initialized = initialized;

  bool? _isRefreshing;
  bool? get isRefreshing => _$this._isRefreshing;
  set isRefreshing(bool? isRefreshing) => _$this._isRefreshing = isRefreshing;

  bool? _reverseSort;
  bool? get reverseSort => _$this._reverseSort;
  set reverseSort(bool? reverseSort) => _$this._reverseSort = reverseSort;

  bool? _saveInProgress;
  bool? get saveInProgress => _$this._saveInProgress;
  set saveInProgress(bool? saveInProgress) =>
      _$this._saveInProgress = saveInProgress;

  int? _postingKey;
  int? get postingKey => _$this._postingKey;
  set postingKey(int? postingKey) => _$this._postingKey = postingKey;

  int? _refreshCount;
  int? get refreshCount => _$this._refreshCount;
  set refreshCount(int? refreshCount) => _$this._refreshCount = refreshCount;

  int? _transactionIndex;
  int? get transactionIndex => _$this._transactionIndex;
  set transactionIndex(int? transactionIndex) =>
      _$this._transactionIndex = transactionIndex;

  ConeStateBuilder() {
    ConeState._initializeBuilder(this);
  }

  ConeStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _brightness = $v.brightness;
      _today = $v.today;
      _journal = $v.journal?.toBuilder();
      _spacing = $v.spacing;
      _contents = $v.contents;
      _ledgerFileDisplayName = $v.ledgerFileDisplayName;
      _ledgerFileUri = $v.ledgerFileUri;
      _numberLocale = $v.numberLocale;
      _systemLocale = $v.systemLocale;
      _transaction = $v.transaction.toBuilder();
      _hintTransaction = $v.hintTransaction.toBuilder();
      _currencyOnLeft = $v.currencyOnLeft;
      _debugMode = $v.debugMode;
      _initialized = $v.initialized;
      _isRefreshing = $v.isRefreshing;
      _reverseSort = $v.reverseSort;
      _saveInProgress = $v.saveInProgress;
      _postingKey = $v.postingKey;
      _refreshCount = $v.refreshCount;
      _transactionIndex = $v.transactionIndex;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConeState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ConeState;
  }

  @override
  void update(void Function(ConeStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConeState build() => _build();

  _$ConeState _build() {
    _$ConeState _$result;
    try {
      _$result = _$v ??
          new _$ConeState._(
              brightness: brightness,
              today: today,
              journal: _journal?.build(),
              spacing: BuiltValueNullFieldError.checkNotNull(
                  spacing, r'ConeState', 'spacing'),
              contents: contents,
              ledgerFileDisplayName: ledgerFileDisplayName,
              ledgerFileUri: ledgerFileUri,
              numberLocale: BuiltValueNullFieldError.checkNotNull(
                  numberLocale, r'ConeState', 'numberLocale'),
              systemLocale: systemLocale,
              transaction: transaction.build(),
              hintTransaction: hintTransaction.build(),
              currencyOnLeft: BuiltValueNullFieldError.checkNotNull(
                  currencyOnLeft, r'ConeState', 'currencyOnLeft'),
              debugMode: debugMode,
              initialized: BuiltValueNullFieldError.checkNotNull(
                  initialized, r'ConeState', 'initialized'),
              isRefreshing: BuiltValueNullFieldError.checkNotNull(
                  isRefreshing, r'ConeState', 'isRefreshing'),
              reverseSort: reverseSort,
              saveInProgress: BuiltValueNullFieldError.checkNotNull(
                  saveInProgress, r'ConeState', 'saveInProgress'),
              postingKey: BuiltValueNullFieldError.checkNotNull(
                  postingKey, r'ConeState', 'postingKey'),
              refreshCount: BuiltValueNullFieldError.checkNotNull(
                  refreshCount, r'ConeState', 'refreshCount'),
              transactionIndex:
                  BuiltValueNullFieldError.checkNotNull(transactionIndex, r'ConeState', 'transactionIndex'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'journal';
        _journal?.build();

        _$failedField = 'transaction';
        transaction.build();
        _$failedField = 'hintTransaction';
        hintTransaction.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ConeState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
