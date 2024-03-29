// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConeState extends ConeState {
  @override
  final ConeBrightness brightness;
  @override
  final DateTime today;
  @override
  final Journal journal;
  @override
  final Spacing spacing;
  @override
  final String contents;
  @override
  final String ledgerFileDisplayName;
  @override
  final String ledgerFileUri;
  @override
  final String numberLocale;
  @override
  final String systemLocale;
  @override
  final Transaction transaction;
  @override
  final Transaction hintTransaction;
  @override
  final bool currencyOnLeft;
  @override
  final bool debugMode;
  @override
  final bool initialized;
  @override
  final bool isRefreshing;
  @override
  final bool reverseSort;
  @override
  final bool saveInProgress;
  @override
  final int postingKey;
  @override
  final int refreshCount;
  @override
  final int transactionIndex;

  factory _$ConeState([void Function(ConeStateBuilder) updates]) =>
      (new ConeStateBuilder()..update(updates)).build();

  _$ConeState._(
      {this.brightness,
      this.today,
      this.journal,
      this.spacing,
      this.contents,
      this.ledgerFileDisplayName,
      this.ledgerFileUri,
      this.numberLocale,
      this.systemLocale,
      this.transaction,
      this.hintTransaction,
      this.currencyOnLeft,
      this.debugMode,
      this.initialized,
      this.isRefreshing,
      this.reverseSort,
      this.saveInProgress,
      this.postingKey,
      this.refreshCount,
      this.transactionIndex})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(spacing, 'ConeState', 'spacing');
    BuiltValueNullFieldError.checkNotNull(
        numberLocale, 'ConeState', 'numberLocale');
    BuiltValueNullFieldError.checkNotNull(
        transaction, 'ConeState', 'transaction');
    BuiltValueNullFieldError.checkNotNull(
        hintTransaction, 'ConeState', 'hintTransaction');
    BuiltValueNullFieldError.checkNotNull(
        currencyOnLeft, 'ConeState', 'currencyOnLeft');
    BuiltValueNullFieldError.checkNotNull(
        initialized, 'ConeState', 'initialized');
    BuiltValueNullFieldError.checkNotNull(
        isRefreshing, 'ConeState', 'isRefreshing');
    BuiltValueNullFieldError.checkNotNull(
        saveInProgress, 'ConeState', 'saveInProgress');
    BuiltValueNullFieldError.checkNotNull(
        postingKey, 'ConeState', 'postingKey');
    BuiltValueNullFieldError.checkNotNull(
        refreshCount, 'ConeState', 'refreshCount');
    BuiltValueNullFieldError.checkNotNull(
        transactionIndex, 'ConeState', 'transactionIndex');
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
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc(
                                                                                $jc(
                                                                                    0,
                                                                                    brightness
                                                                                        .hashCode),
                                                                                today
                                                                                    .hashCode),
                                                                            journal
                                                                                .hashCode),
                                                                        spacing
                                                                            .hashCode),
                                                                    contents
                                                                        .hashCode),
                                                                ledgerFileDisplayName
                                                                    .hashCode),
                                                            ledgerFileUri
                                                                .hashCode),
                                                        numberLocale.hashCode),
                                                    systemLocale.hashCode),
                                                transaction.hashCode),
                                            hintTransaction.hashCode),
                                        currencyOnLeft.hashCode),
                                    debugMode.hashCode),
                                initialized.hashCode),
                            isRefreshing.hashCode),
                        reverseSort.hashCode),
                    saveInProgress.hashCode),
                postingKey.hashCode),
            refreshCount.hashCode),
        transactionIndex.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ConeState')
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
  _$ConeState _$v;

  ConeBrightness _brightness;
  ConeBrightness get brightness => _$this._brightness;
  set brightness(ConeBrightness brightness) => _$this._brightness = brightness;

  DateTime _today;
  DateTime get today => _$this._today;
  set today(DateTime today) => _$this._today = today;

  JournalBuilder _journal;
  JournalBuilder get journal => _$this._journal ??= new JournalBuilder();
  set journal(JournalBuilder journal) => _$this._journal = journal;

  Spacing _spacing;
  Spacing get spacing => _$this._spacing;
  set spacing(Spacing spacing) => _$this._spacing = spacing;

  String _contents;
  String get contents => _$this._contents;
  set contents(String contents) => _$this._contents = contents;

  String _ledgerFileDisplayName;
  String get ledgerFileDisplayName => _$this._ledgerFileDisplayName;
  set ledgerFileDisplayName(String ledgerFileDisplayName) =>
      _$this._ledgerFileDisplayName = ledgerFileDisplayName;

  String _ledgerFileUri;
  String get ledgerFileUri => _$this._ledgerFileUri;
  set ledgerFileUri(String ledgerFileUri) =>
      _$this._ledgerFileUri = ledgerFileUri;

  String _numberLocale;
  String get numberLocale => _$this._numberLocale;
  set numberLocale(String numberLocale) => _$this._numberLocale = numberLocale;

  String _systemLocale;
  String get systemLocale => _$this._systemLocale;
  set systemLocale(String systemLocale) => _$this._systemLocale = systemLocale;

  TransactionBuilder _transaction;
  TransactionBuilder get transaction =>
      _$this._transaction ??= new TransactionBuilder();
  set transaction(TransactionBuilder transaction) =>
      _$this._transaction = transaction;

  TransactionBuilder _hintTransaction;
  TransactionBuilder get hintTransaction =>
      _$this._hintTransaction ??= new TransactionBuilder();
  set hintTransaction(TransactionBuilder hintTransaction) =>
      _$this._hintTransaction = hintTransaction;

  bool _currencyOnLeft;
  bool get currencyOnLeft => _$this._currencyOnLeft;
  set currencyOnLeft(bool currencyOnLeft) =>
      _$this._currencyOnLeft = currencyOnLeft;

  bool _debugMode;
  bool get debugMode => _$this._debugMode;
  set debugMode(bool debugMode) => _$this._debugMode = debugMode;

  bool _initialized;
  bool get initialized => _$this._initialized;
  set initialized(bool initialized) => _$this._initialized = initialized;

  bool _isRefreshing;
  bool get isRefreshing => _$this._isRefreshing;
  set isRefreshing(bool isRefreshing) => _$this._isRefreshing = isRefreshing;

  bool _reverseSort;
  bool get reverseSort => _$this._reverseSort;
  set reverseSort(bool reverseSort) => _$this._reverseSort = reverseSort;

  bool _saveInProgress;
  bool get saveInProgress => _$this._saveInProgress;
  set saveInProgress(bool saveInProgress) =>
      _$this._saveInProgress = saveInProgress;

  int _postingKey;
  int get postingKey => _$this._postingKey;
  set postingKey(int postingKey) => _$this._postingKey = postingKey;

  int _refreshCount;
  int get refreshCount => _$this._refreshCount;
  set refreshCount(int refreshCount) => _$this._refreshCount = refreshCount;

  int _transactionIndex;
  int get transactionIndex => _$this._transactionIndex;
  set transactionIndex(int transactionIndex) =>
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
  void update(void Function(ConeStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ConeState build() {
    _$ConeState _$result;
    try {
      _$result = _$v ??
          new _$ConeState._(
              brightness: brightness,
              today: today,
              journal: _journal?.build(),
              spacing: BuiltValueNullFieldError.checkNotNull(
                  spacing, 'ConeState', 'spacing'),
              contents: contents,
              ledgerFileDisplayName: ledgerFileDisplayName,
              ledgerFileUri: ledgerFileUri,
              numberLocale: BuiltValueNullFieldError.checkNotNull(
                  numberLocale, 'ConeState', 'numberLocale'),
              systemLocale: systemLocale,
              transaction: transaction.build(),
              hintTransaction: hintTransaction.build(),
              currencyOnLeft: BuiltValueNullFieldError.checkNotNull(
                  currencyOnLeft, 'ConeState', 'currencyOnLeft'),
              debugMode: debugMode,
              initialized: BuiltValueNullFieldError.checkNotNull(
                  initialized, 'ConeState', 'initialized'),
              isRefreshing: BuiltValueNullFieldError.checkNotNull(
                  isRefreshing, 'ConeState', 'isRefreshing'),
              reverseSort: reverseSort,
              saveInProgress: BuiltValueNullFieldError.checkNotNull(
                  saveInProgress, 'ConeState', 'saveInProgress'),
              postingKey: BuiltValueNullFieldError.checkNotNull(
                  postingKey, 'ConeState', 'postingKey'),
              refreshCount: BuiltValueNullFieldError.checkNotNull(
                  refreshCount, 'ConeState', 'refreshCount'),
              transactionIndex:
                  BuiltValueNullFieldError.checkNotNull(transactionIndex, 'ConeState', 'transactionIndex'));
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'journal';
        _journal?.build();

        _$failedField = 'transaction';
        transaction.build();
        _$failedField = 'hintTransaction';
        hintTransaction.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ConeState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
