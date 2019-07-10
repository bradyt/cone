import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('cone.tangential.info/uri');

Future<String> pickUri() async {
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

Future<String> getDisplayName(String uri) async {
  String displayName;
  try {
    displayName =
        await _channel.invokeMethod<dynamic>('getDisplayName', <String, String>{
      'uri': uri,
    }) as String;
  } on PlatformException {
    rethrow;
  }
  return displayName;
}

Future<void> isUriOpenable(String uri) async {
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

Future<void> takePersistablePermission(String uri) async {
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

Future<String> readFile(String uri) async {
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

Future<void> appendFile(String uri, String contentsToAppend) async {
  await isUriOpenable(uri);
  String originalContents = await readFile(uri);
  originalContents = trimAllRight(originalContents);
  final String newContents =
      ((originalContents.isNotEmpty) ? originalContents + '\n\n' : '') +
          trimAllRight(contentsToAppend) +
          '\n';
  try {
    await _channel.invokeMethod<dynamic>('alterDocument', <String, String>{
      'uri': uri,
      'newContents': newContents,
    });
  } on PlatformException catch (e) {
    print('PlatformException $e');
  }
}

String trimAllRight(String input) {
  if (input == null || input.isEmpty) {
    return input;
  }
  String output = input;
  final RegExp re = RegExp(r'[\r\n\s]');
  while (re.hasMatch(output[output.length - 1])) {
    output = output.substring(0, output.length - 1);
  }
  return output;
}
