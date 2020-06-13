import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:file_picker_writable/file_picker_writable.dart';

class UriPicker {
  static const MethodChannel _channel =
      const MethodChannel('tangential.info/uri_picker');

  static Future<String> pickUri() async {
    if (Platform.isIOS) {
      return await FilePickerWritable()
          .openFilePicker()
          .then((FileInfo fileInfo) => fileInfo.identifier);
    }
    String uri;
    try {
      uri = await _channel.invokeMethod<dynamic>('pickUri') as String;
    } on PlatformException {
      rethrow;
    } on MissingPluginException {
      rethrow;
    }
    return uri;
  }

  static Future<String> getDisplayName(String uri) async {
    if (Platform.isIOS) {
      return await FilePickerWritable()
          .readFileWithIdentifier(uri)
          .then((FileInfo fileInfo) => fileInfo.fileName);
    }
    String displayName;
    try {
      displayName = await _channel
          .invokeMethod<dynamic>('getDisplayName', <String, String>{
        'uri': uri,
      }) as String;
    } on PlatformException {
      rethrow;
    }
    return displayName;
  }

  static Future<void> isUriOpenable(String uri) async {
    if (Platform.isIOS) {
      return true;
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
    if (Platform.isIOS) {
      return true;
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

  static Future<String> readTextFromUri(String uri) async {
    if (Platform.isIOS) {
      return await FilePickerWritable()
          .readFileWithIdentifier(uri)
          .then((FileInfo fileInfo) => fileInfo.file.readAsString());
    }
    String fileContents;
    try {
      fileContents = await _channel
          .invokeMethod<dynamic>('readTextFromUri', <String, String>{
        'uri': uri,
      }) as String;
    } on PlatformException {
      rethrow;
    }
    return fileContents;
  }

  static Future<String> alterDocument(String uri, String newContents) async {
    if (Platform.isIOS) {
      Directory tempDir = await getTemporaryDirectory();
      String randomFileName = Uuid().v4();
      File file = File('${tempDir.path}/$randomFileName');
      await file.writeAsString(newContents);
      final FileInfo fileInfo =
          await FilePickerWritable().writeFileWithIdentifier(uri, file);
      if (fileInfo.identifier != uri) {
        print(
            'omg the identifier changed!\n\nSee:\n\n${uri}\n\nvs\n\n${fileInfo.identifier}\n');
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
      print('PlatformException $e');
    }
    return 'Not implemented on Android.';
  }
}
