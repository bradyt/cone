import 'dart:async';

import 'package:flutter/services.dart';

class UriPicker {
  static const MethodChannel _channel =
      const MethodChannel('uri_picker');

  static Future<String> pickUri() async {
    final String uri = await _channel.invokeMethod('pickUri');
    return uri;
  }
}
