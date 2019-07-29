import 'dart:async';

import 'package:flutter/services.dart';

class UriPicker {
  static const MethodChannel _channel =
      const MethodChannel('tangential.info/uri_picker');

  static Future<String> pickUri() async {
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

  static Future<void> alterDocument(String uri, String newContents) async {
    await isUriOpenable(uri);
    try {
      await _channel.invokeMethod<dynamic>('alterDocument', <String, String>{
        'uri': uri,
        'newContents': newContents,
      });
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
  }
}
