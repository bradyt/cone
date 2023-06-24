import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:file_picker_writable/file_picker_writable.dart';

class UriPicker {
  static const MethodChannel _channel =
      MethodChannel('tangential.info/uri_picker');

  static Future<String?> pickUri() async {
    if (Platform.isIOS || Platform.isAndroid) {
      return await FilePickerWritable().openFile(
        (fileInfo, file) async => fileInfo.identifier,
      );
    }
    String? uri;
    try {
      uri = await _channel.invokeMethod<dynamic>('pickUri') as String?;
    } on PlatformException {
      rethrow;
    } on MissingPluginException {
      rethrow;
    }
    return uri;
  }

  static Future<String?> putEmptyFile() async {
    if (Platform.isIOS || Platform.isAndroid) {
      Directory tempDir = await getTemporaryDirectory();

      Duration tz = DateTime.now().timeZoneOffset;
      int tzHours = tz.abs().inHours;
      int tzMinutes = tz.abs().inMinutes - 60 * tzHours;
      bool tzIsNegative = tz.isNegative;

      String padInt(int n) => '$n'.padLeft(2, '0');

      String tzOffset =
          '${(tzIsNegative) ? '-' : '+'}${padInt(tzHours)}${padInt(tzMinutes)}';

      String nowString = DateFormat("yyyyMMddTHHmmss").format(DateTime.now());
      String fileName = '$nowString${tzOffset}_${const Uuid().v4()}.txt';
      File file = File('${tempDir.path}/$fileName');
      await file.writeAsString('');

      return await FilePickerWritable()
          .openFileForCreate(
            fileName: fileName,
            writer: (tempFile) => tempFile.writeAsString(''),
          )
          .then((FileInfo? fileInfo) => fileInfo!.identifier);
    }
    String? uri;
    try {
      uri = await _channel.invokeMethod<dynamic>('pickUri') as String?;
    } on PlatformException {
      rethrow;
    } on MissingPluginException {
      rethrow;
    }
    return uri;
  }

  static Future<String?> getDisplayName(String uri) async {
    if (Platform.isIOS || Platform.isAndroid) {
      return await FilePickerWritable().readFile(
        identifier: uri,
        reader: (fileInfo, file) async => fileInfo.fileName,
      );
    }
    String? displayName;
    try {
      displayName = await _channel
          .invokeMethod<dynamic>('getDisplayName', <String, String>{
        'uri': uri,
      }) as String?;
    } on PlatformException {
      rethrow;
    }
    return displayName;
  }

  static Future<void> isUriOpenable(String uri) async {
    if (Platform.isIOS || Platform.isAndroid) {
      return;
    }
    try {
      await _channel.invokeMethod<dynamic>('isUriOpenable', <String, String>{
        'uri': uri,
      });
    } on PlatformException {
      rethrow;
    } on MissingPluginException {
      rethrow;
    }
  }

  static Future<void> takePersistablePermission(String uri) async {
    if (Platform.isIOS || Platform.isAndroid) {
      return;
    }
    try {
      await _channel
          .invokeMethod<dynamic>('takePersistablePermission', <String, String>{
        'uri': uri,
      });
    } on PlatformException {
      rethrow;
    } on MissingPluginException {
      rethrow;
    }
  }

  static Future<String?> readTextFromUri(String uri) async {
    if (Platform.isIOS || Platform.isAndroid) {
      return await FilePickerWritable().readFile(
        identifier: uri,
        reader: (fileInfo, file) => file.readAsString(),
      );
    }
    String? fileContents;
    try {
      fileContents = await _channel
          .invokeMethod<dynamic>('readTextFromUri', <String, String>{
        'uri': uri,
      }) as String?;
    } on PlatformException {
      rethrow;
    }
    return fileContents;
  }

  static Future<String> alterDocument(String uri, String newContents) async {
    if (Platform.isIOS || Platform.isAndroid) {
      Directory tempDir = await getTemporaryDirectory();
      String randomFileName = const Uuid().v4();
      File file = File('${tempDir.path}/$randomFileName');
      await file.writeAsString(newContents);
      final FileInfo fileInfo =
          await FilePickerWritable().writeFileWithIdentifier(uri, file);
      if (fileInfo.identifier != uri) {
        stdout.writeln(
            'omg the identifier changed!\n\nSee:\n\n$uri\n\nvs\n\n${fileInfo.identifier}\n');
      }
      return fileInfo.identifier;
    }
    await isUriOpenable(uri);
    try {
      await _channel.invokeMethod<dynamic>('alterDocument', <String, String>{
        'uri': uri,
        'newContents': newContents,
      });
    } on PlatformException catch (e) {
      stdout.writeln('PlatformException $e');
    }
    return 'Not implemented on macOS.';
  }
}
