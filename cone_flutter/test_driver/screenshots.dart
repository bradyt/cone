import 'package:flutter/material.dart' show WidgetsApp;
import 'package:flutter/services.dart' show MethodCall, MethodChannel;
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cone/main.dart' as app;

void main() {
  enableFlutterDriverExtension();

  WidgetsApp.debugAllowBannerOverride = false;

  String? bufferContents;

  const MethodChannel('tangential.info/uri_picker')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'pickUri') {
      bufferContents = '''
account assets:cash
account assets:bs:checking
account assets:bs:savings
account expenses:groceries
account expenses:miscellaneous
account liabilities:moneybank
account liabilities:viza
account income:snpp

1995-05-05 Springfield Power Company
  assets:bs:checking  362.19 USD
  income:snpp
''';
      return Future<String>.value('Google Drive - ledger.txt');
    } else if (methodCall.method == 'readTextFromUri') {
      return bufferContents;
    } else if (methodCall.method == 'alterDocument') {
      bufferContents = methodCall.arguments['newContents'] as String?;
    }
    return null;
  });

  app.main(
    snapshots: true,
  );
}
