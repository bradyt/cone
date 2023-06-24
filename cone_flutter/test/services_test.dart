import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cone/src/services.dart';

void main() {
  test('Test PersistentSettings.', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'brightness': 0,
    });

    final PersistentSettings settings = await PersistentSettings.getSettings();

    expect(
      settings.brightness,
      0,
    );
  });
  test('Test appendFile.', () async {
    String mockFile = '';
    TestWidgetsFlutterBinding.ensureInitialized();
    const MethodChannel('tangential.info/uri_picker')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'readTextfromuri') {
        return mockFile;
      } else if (methodCall.method == 'alterDocument') {
        mockFile += methodCall.arguments['newContents'] as String;
      }
      return '';
    });
    await appendFile('foo', 'bar');
    expect(mockFile, 'bar\n');
    await appendFile('foo', 'baz');
    expect(mockFile, 'bar\nbaz\n');
  });
}
