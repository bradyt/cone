import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:uri_picker/uri_picker.dart';

Future<void> appendFile(String uri, String contentsToAppend) async {
  await UriPicker.isUriOpenable(uri);
  final String originalContents = await UriPicker.readTextFromUri(uri);
  final String newContents =
      combineContentsWithLinebreak(originalContents, contentsToAppend);
  try {
    await UriPicker.alterDocument(uri, newContents);
  } on PlatformException catch (_) {
    rethrow;
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


String generateTitleFromPlatformException(PlatformException e) {
  final RegExp pascalWords = RegExp(r'(?:[A-Z]+|^)[a-z]*');
  List<String> getPascalWords(String input) =>
      pascalWords.allMatches(input).map((Match m) => m[0]).toList();
  final List<String> keyWords = getPascalWords(e.code.split('.').last)
    ..removeLast();
  final String sentence = keyWords.join(' ');
  final String title = (sentence == null || sentence.isEmpty)
      ? null
      : sentence[0].toUpperCase() + sentence.substring(1).toLowerCase();

  return title;
}

Future<int> showGenericInfo(
    {BuildContext context, String title, Map<String, String> info}) {
  return showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      final Iterable<MapEntry<String, String>> entries = info.entries;
      return AlertDialog(
        title: (title != null) ? Text(title) : null,
        content: ListView.builder(
          itemCount: info.length,
          itemBuilder: (BuildContext content, int index) {
            final MapEntry<String, String> entry = entries.elementAt(index);
            return ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value),
            );
          },
        ),
        actions: <Widget>[
          RaisedButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<int> showError(
    {BuildContext context,
    PlatformException e,
    String ledgerFileUri,
    String ledgerFileDisplayName}) {
  final String title = generateTitleFromPlatformException(e);
  final Map<String, String> info = <String, String>{
    'Code': e.code,
    'Message': e.message,
    if (ledgerFileDisplayName != null) 'Display name': ledgerFileDisplayName,
    if (ledgerFileUri != null) ...<String, String>{
      'Uri authority component': Uri.tryParse(ledgerFileUri).authority,
      'Uri path component': Uri.tryParse(Uri.decodeFull(ledgerFileUri)).path,
      'Uri': Uri.decodeFull(ledgerFileUri),
    }
  };
  return showGenericInfo(context: context, title: title, info: info);
}
