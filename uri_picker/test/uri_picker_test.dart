import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uri_picker/uri_picker.dart';

void main() {
  const MethodChannel channel = MethodChannel('tangential.info/uri_picker');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await UriPicker.pickUri(), '42');
  });
}
