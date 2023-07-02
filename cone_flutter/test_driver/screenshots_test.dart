import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('cone app', () {
    FlutterDriver? driver;

    Future<void> takeScreenshot(int index) async =>
        File('./android/fastlane/screenshots/screenshot-$index.png')
            .writeAsBytes(await driver!.screenshot());

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver!.close();
      }
    });

    test('first screenshot', () async {
      await Future<void>.delayed(const Duration(seconds: 2));
      await Directory('./android/fastlane/screenshots/')
          .create(recursive: true);
      await takeScreenshot(1);
    });

    test('navigate to settings', () async {
      await driver!.tap(find.byValueKey('Settings'));
      await takeScreenshot(2);
    });

    test('set desired settings', () async {
      await driver!.tap(find.byValueKey('Pick ledger file'));
      await driver!.tap(find.byValueKey('Toggle reverse sort'));
      await driver!.tap(find.byValueKey('Formatting'));
      await driver!.tap(find.byValueKey('Currency on left'));
      await driver!.tap(find.byValueKey('Spacing'));
      await driver!.tap(find.text('5.00 USD'));
      await takeScreenshot(3);
    });

    test('go back', () async {
      await driver!.tap(find.pageBack());
      await takeScreenshot(4);
    });

    test('press add button', () async {
      await driver!.tap(find.byType('FloatingActionButton'));
    });

    test('update field values', () async {
      await driver!.enterText('Springfield Grocery Store');
    });

    test('focus on first account name', () async {
      await driver!.tap(find.byValueKey('Account 0'));
    });

    test('update field values', () async {
      await driver!.enterText('g');
      await driver!.tap(find.text('g'));
      await takeScreenshot(5);
    });

    test('click groceries', () async {
      await driver!.tap(find.text('expenses:groceries'));
    });

    test('fill a few more', () async {
      await driver!.tap(find.byValueKey('Amount 0'));
      await driver!.enterText('37.58');
      await driver!.tap(find.byValueKey('Account 1'));
      await driver!.enterText('assets:cash');
      await driver!.tap(find.byValueKey('Amount 1'));
      await driver!.enterText('20');
      await driver!.tap(find.byValueKey('Account 2'));
      await driver!.enterText('bs ch');
    });

    test('finish', () async {
      await driver!.enterText('bs ch');
      await driver!.tap(find.text('bs ch'));
      await takeScreenshot(6);
    });

    test('press save button', () async {
      await driver!.tap(find.text('assets:bs:checking'));
      await driver!.tap(find.byType('FloatingActionButton'));
      await takeScreenshot(7);
    });
  });
}
