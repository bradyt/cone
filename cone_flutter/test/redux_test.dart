import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cone/src/redux/actions.dart';
import 'package:cone/src/redux/reducers.dart';
import 'package:cone/src/redux/state.dart';
import 'package:cone/src/services.dart';
import 'package:cone/src/types.dart';

void main() {
  group('Test state.dart.', () {
    test('Test ConeState.', () {
      //ignore: unnecessary_type_check
      expect(ConeState() is ConeState, true);
    });
    test('Test coneMiddleWare.', () {
      //ignore: unnecessary_type_check
      expect(coneMiddleware is List, true);
    });
    test('Test coneReducer.', () {
      expect(
          //ignore: unnecessary_type_check
          coneReducer(ConeState(), Actions.markInitialized) is ConeState,
          true);
    });
  });
  group('Test action.dart.', () {
    test('Test InitializeSettingsAction.', () {
      //ignore: unnecessary_type_check
      expect(InitializeSettingsAction() is InitializeSettingsAction, true);
    });
    test('Test UpdateSettingsAction.', () {
      expect(
        UpdateSettingsAction('key', 'value').toString(),
        'UpdateSettingsAction(key, \'value\')',
      );
      expect(
        UpdateSettingsAction('key', true).toString(),
        'UpdateSettingsAction(key, true)',
      );
      expect(UpdateUriAction('uri').uri, 'uri');
      expect(UpdateSystemLocaleAction('zh').systemLocale, 'zh');
      expect(UpdateContentsAction('account a').toString(),
          'UpdateContentsAction(\'account a...\')');
      expect(UpdateDateAction('2000-01-01').date, '2000-01-01');
      expect(UpdateDescriptionAction('tacos').description, 'tacos');
      expect(
        UpdateAccountAction(index: 0, account: 'assets').account,
        'assets',
      );
      expect(UpdateQuantityAction(quantity: '0').quantity, '0');
      expect(UpdateCommodityAction(commodity: 'EUR').commodity, 'EUR');
      expect(RemovePostingAtAction(0).index, 0);
      expect(
        SetBrightness(ConeBrightness.auto).toString(),
        'SetBrightness(ConeBrightness.auto)',
      );
    });
  });
  group('Test reducers.dart.', () {
    const PersistentSettings settings = PersistentSettings();
    final ConeState coneFinalState = <dynamic>[
      UpdateSystemLocaleAction('en'),
      InitializeSettingsAction(settings: settings),
      Actions.addPosting,
      RemovePostingAtAction(0),
      Actions.resetTransaction,
      Actions.addPosting,
      Actions.addPosting,
      UpdateDateAction('2000-01-01'),
      UpdateDescriptionAction('example'),
      UpdateAccountAction(index: 0, account: 'assets'),
      UpdateQuantityAction(index: 0, quantity: '0'),
      UpdateCommodityAction(index: 0, commodity: 'EUR'),
      UpdateSettingsAction('debug_mode', true),
      UpdateSettingsAction('default_currency', 'EUR'),
      UpdateSettingsAction('ledger_file_uri', '/tmp/blah.dat'),
      UpdateSettingsAction('number_locale', 'en'),
      UpdateSettingsAction('currency_on_left', true),
      UpdateSettingsAction('spacing', Spacing.zero),
      UpdateSettingsAction('reverse_sort', true),
      Actions.refreshFileContents,
      UpdateContentsAction(''),
      SetBrightness(ConeBrightness.auto),
    ].fold<ConeState>(ConeState(), firstConeReducer);

    test('Test reduction is a state.', () {
      //ignore: unnecessary_type_check
      expect(coneFinalState is ConeState, true);
    });
  });
  group('Test middleware.dart.', () {
    final Store<ConeState> store = Store<ConeState>(
      coneReducer,
      initialState: ConeState(),
      middleware: coneMiddleware,
    );

    SharedPreferences.setMockInitialValues(<String, Object>{
      'brightness': 0,
    });

    TestWidgetsFlutterBinding.ensureInitialized();
    const MethodChannel('tangential.info/uri_picker')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'pickUri') {
        return 'some-filename.dat';
      } else if (methodCall.method == 'readTextfromuri') {
        if (methodCall.arguments['uri'] == 'some-filename.dat') {
          return '2000-01-01 example\n  a  0 EUR\n  b\n';
        }
      }
      return '';
    });

    test('Test one.', () {
      store
        ..dispatch(UpdateSystemLocaleAction('en'))
        ..dispatch(Actions.getPersistentSettings)
        ..dispatch(UpdateSettingsAction('key', true))
        ..dispatch(UpdateSettingsAction('key', 0))
        ..dispatch(UpdateSettingsAction('key', Spacing.zero))
        ..dispatch(UpdateSettingsAction('key', 'value'))
        ..dispatch(SetBrightness(ConeBrightness.auto))
        ..dispatch(Actions.pickLedgerFileUri)
        ..dispatch(Actions.refreshFileContents)
        ..dispatch(Actions.submitTransaction);
    });
  });
}
