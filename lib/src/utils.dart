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
  final String originalContents = await readFile(uri);
  final String newContents =
      combineContentsWithLinebreak(originalContents, contentsToAppend);
  try {
    await _channel.invokeMethod<dynamic>('alterDocument', <String, String>{
      'uri': uri,
      'newContents': newContents,
    });
  } on PlatformException catch (e) {
    print('PlatformException $e');
  }
}

class MeasureNewlines {
  MeasureNewlines(String contents) {
    listOfCleanLines =
        contents.split(re).map((String line) => line.trim()).toList();
    lastLine = listOfCleanLines.length - 1;
    lastNonEmptyLine =
        listOfCleanLines.lastIndexWhere((String line) => line.isNotEmpty);
    distance = lastLine - lastNonEmptyLine;
  }

  static final RegExp re = RegExp(r'\r\n?|\n');
  List<String> listOfCleanLines;
  int lastLine;
  int lastNonEmptyLine;
  int distance;

  int numberOfNewlinesToAddBetween() {
    int result;
    if (lastNonEmptyLine == -1) {
      result = 0;
    } else if (distance == 0) {
      result = 2;
    } else if (distance == 1) {
      result = 1;
    } else if (distance > 1) {
      result = 0;
    }
    return result;
  }

  bool needsNewline() {
    return distance == 0;
  }
}

String combineContentsWithLinebreak(String firstPart, String secondPart) {
  return firstPart +
      '\n' * MeasureNewlines(firstPart).numberOfNewlinesToAddBetween() +
      secondPart +
      ((MeasureNewlines(secondPart).needsNewline()) ? '\n' : '');
}

String getAccountNameFromLine(String line) {
  String result;
  if (line.isNotEmpty) {
    if (line.startsWith(RegExp('[ \t]+[^ \t]'))) {
      result = line.trim().split('  ').first;
    } else if (line.startsWith('account')) {
      result = line.replaceFirst('account', '').trim();
    } else if (line.startsWith(RegExp(r'[-0-9]{10} open [A-Za-z]+:'))) {
      result = line.trim().split(' ').last;
    }
  }
  return result;
}

String getTransactionDescriptionFromLine(String line) {
  final RegExp re = RegExp(r'[-0-9=]{10,21}');
  String result;
  if (line.startsWith(re)) {
    final String dateRemoved = line.replaceFirst(re, '');
    final int commentStart = dateRemoved.indexOf(';');
    final String description = (commentStart == -1)
        ? dateRemoved
        : dateRemoved.substring(0, commentStart);
    result = description.trim();
  }
  return result;
}

String getTransactionDescriptionFromBeancountLine(String line) {
  final RegExp re = RegExp(r'[-0-9]{10}');
  String result;
  if (line.startsWith(re)) {
    final String dateRemoved = line.replaceFirst(re, '').trim();
    if (dateRemoved.startsWith(RegExp(r'[*!]'))) {
      result = dateRemoved.trim();
    }
  }
  return result;
}
