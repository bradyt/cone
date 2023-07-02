import 'package:flutter/material.dart' hide Actions;
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cone/main.dart';
import 'package:cone/src/add_transaction.dart';
import 'package:cone/src/redux/actions.dart';
import 'package:cone/src/redux/state.dart';

void main() {
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    const String mockedUri = 'Google Drive - blah.txt';
    String? mockedFile = '';

    const MethodChannel('tangential.info/uri_picker')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'pickUri') {
        return mockedUri;
      } else if (methodCall.method == 'getDisplayName') {
        return null;
      } else if (methodCall.method == 'takePersistablePermission') {
        return null;
      } else if (methodCall.method == 'readTextFromUri') {
        if (methodCall.arguments['uri'] == mockedUri) {
          return mockedFile;
        }
      } else if (methodCall.method == 'alterDocument') {
        if (methodCall.arguments['uri'] == mockedUri) {
          return mockedFile = methodCall.arguments['newContents'] as String?;
        }
      }
      return '';
    });

    SharedPreferences.setMockInitialValues(<String, Object>{
      'brightness': 0,
    });

    final Store<ConeState> store = Store<ConeState>(
      coneReducer,
      initialState: ConeState(),
      middleware: widgetTestConeMiddleware,
    );

    WidgetsFlutterBinding.ensureInitialized();
    store
      ..dispatch(UpdateSystemLocaleAction(Intl.systemLocale))
      ..dispatch(Actions.getPersistentSettings);

    await tester.pumpWidget(
      ConeWidgetTest(
        widgetTest: true,
        child: Provider<Store<ConeState>>.value(
          value: store,
          child: StoreProvider<ConeState>(
            store: store,
            child: ConeInitializing(),
          ),
        ),
      ),
      const Duration(seconds: 1),
    );

    final Finder coneTitleFinder = find.text('cone');
    expect(coneTitleFinder, findsOneWidget);

    final Finder settingsButtonFinder = find.byIcon(Icons.settings);
    expect(settingsButtonFinder, findsOneWidget);

    final Finder addButtonFinder = find.byIcon(Icons.add);
    expect(addButtonFinder, findsNothing);

    await tester.tap(settingsButtonFinder);

    await tester.pumpAndSettle();

    final Finder settingsTitleFinder = find.text('Settings');
    expect(settingsTitleFinder, findsOneWidget);

    final Finder pickFileFinder = find.widgetWithIcon(ListTile, Icons.link);
    expect(pickFileFinder, findsOneWidget);

    Finder fileNameFinder(String fileName) =>
        find.descendant(of: pickFileFinder, matching: find.text(fileName));

    expect(fileNameFinder('null'), findsOneWidget);

    await tester.tap(pickFileFinder);

    await tester.pumpAndSettle();

    expect(fileNameFinder('Google Drive - blah.txt'), findsOneWidget);

    await tester.pageBack();

    await tester.pumpAndSettle();

    expect(addButtonFinder, findsOneWidget);

    await tester.tap(addButtonFinder);

    await tester.pumpAndSettle();

    final Finder addTransactionTitleFinder = find.text('Add transaction');
    expect(addTransactionTitleFinder, findsOneWidget);

    final Finder todayTextFinder =
        find.text(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    expect(todayTextFinder, findsOneWidget);

    final Finder calendarIconFinder =
        find.widgetWithIcon(TextField, Icons.calendar_today);
    expect(calendarIconFinder, findsOneWidget);

    final Finder saveIconFinder =
        find.widgetWithIcon(FloatingActionButton, Icons.save);
    expect(saveIconFinder, findsOneWidget);

    final Finder fabFinder = find.widgetWithIcon(
      FloatingActionButton,
      Icons.save,
    );

    expect(
      (tester.widget(fabFinder) as FloatingActionButton).onPressed,
      isNull,
    );

    final Finder textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsNWidgets(8));

    final Finder dismissibleFinder = find.byType(Dismissible);
    expect(dismissibleFinder, findsNWidgets(2));

    final Finder dateFieldFinder = find.widgetWithText(
        DateField, DateFormat('yyyy-MM-dd').format(DateTime.now()));
    expect(dateFieldFinder, findsOneWidget);

    store
      ..dispatch(UpdateDescriptionAction('Example transaction'))
      ..dispatch(UpdateAccountAction(index: 0, account: 'expenses:food'))
      ..dispatch(UpdateAccountAction(index: 1, account: 'assets:cash'));

    await tester.enterText(textFieldFinder.at(3), '5');

    await tester.pumpAndSettle();

    expect(
      (tester.widget(fabFinder) as FloatingActionButton).onPressed,
      isNotNull,
    );

    await tester.tap(fabFinder);

    await tester.pumpAndSettle();

    expect(coneTitleFinder, findsOneWidget);

    expect(find.text('assets:cash'), findsOneWidget);
    expect(find.text('  assets:cash'), findsOneWidget);
    expect(find.text('5.00 USD'), findsNWidgets(2));

    await tester.pumpAndSettle(const Duration(seconds: 4));

    expect(find.text('5.00 USD'), findsOneWidget);
  });
}
