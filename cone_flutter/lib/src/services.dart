import 'package:flutter/services.dart' show PlatformException;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uri_picker/uri_picker.dart';

class PersistentSettings {
  const PersistentSettings({
    this.brightness,
    this.currencyOnLeft,
    this.debugMode,
    this.defaultCurrency,
    this.ledgerFileDisplayName,
    this.ledgerFileUri,
    this.numberLocale,
    this.reverseSort,
    this.spacing,
  });

  final String? defaultCurrency;
  final String? ledgerFileDisplayName;
  final String? ledgerFileUri;
  final String? numberLocale;
  final bool? currencyOnLeft;
  final bool? debugMode;
  final bool? reverseSort;
  final int? brightness;
  final int? spacing;

  static Future<PersistentSettings> getSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return PersistentSettings(
      brightness: prefs.getInt('brightness'),
      currencyOnLeft: prefs.getBool('currency_on_left'),
      debugMode: prefs.getBool('debug_mode'),
      defaultCurrency: prefs.getString('default_currency'),
      ledgerFileDisplayName: prefs.getString('ledger_file_display_name'),
      ledgerFileUri: prefs.getString('ledger_file_uri'),
      numberLocale: prefs.getString('number_locale'),
      reverseSort: prefs.getBool('reverse_sort'),
      spacing: prefs.getInt('spacing'),
    );
  }
}

Future<void> appendFile(String uri, String contentsToAppend) async {
  await UriPicker.isUriOpenable(uri);
  final String originalContents = (await UriPicker.readTextFromUri(uri))!;
  final String newContents =
      combineContentsWithLinebreak(originalContents, contentsToAppend);
  try {
    await UriPicker.alterDocument(uri, newContents);
  } on PlatformException catch (_) {
    rethrow;
  }
}

String combineContentsWithLinebreak(String firstPart, String secondPart) {
  return firstPart +
      '\n' * MeasureNewlines(firstPart).numberOfNewlinesToAddBetween()! +
      secondPart +
      ((MeasureNewlines(secondPart).needsNewline()) ? '\n' : '');
}

class MeasureNewlines {
  MeasureNewlines(String contents) {
    listOfCleanLines =
        contents.split(re).map((String line) => line.trim()).toList();
    lastLine = listOfCleanLines.length - 1;
    lastNonEmptyLine =
        listOfCleanLines.lastIndexWhere((String line) => line.isNotEmpty);
    distance = lastLine - lastNonEmptyLine!;
  }

  static final RegExp re = RegExp(r'\r\n?|\n');
  late List<String> listOfCleanLines;
  late int lastLine;
  int? lastNonEmptyLine;
  int? distance;

  int? numberOfNewlinesToAddBetween() {
    int? result;
    if (lastNonEmptyLine == -1) {
      result = 0;
    } else if (distance == 0) {
      result = 2;
    } else if (distance == 1) {
      result = 1;
    } else if (distance! > 1) {
      result = 0;
    }
    return result;
  }

  bool needsNewline() {
    return distance == 0;
  }
}
