import 'package:flutter/foundation.dart';

import 'package:cone_lib/cone_lib.dart';

class SuggestionsModel {
  Set<String> _accounts;
  Set<String> _descriptions;

  List<String> descriptionSuggestions(String text) {
    return fuzzyMatch(text, _descriptions);
  }

  List<String> accountSuggestions(String text) {
    return fuzzyMatch(text, _accounts);
  }

  void updateSuggestions({@required String fileContents}) {
    _refreshAccounts(fileContents);
    _refreshDescriptions(fileContents);
  }

  void _refreshAccounts(String fileContents) {
    _accounts = getAccountsAndSubAccountsFromLines(fileContents.split('\n'));
  }

  void _refreshDescriptions(String fileContents) {
    _descriptions = fileContents
        .split('\n')
        .map(getTransactionDescriptionFromLine)
        .toSet()
          ..remove(null);
  }
}
List<String> fuzzyMatch(String input, Set<String> candidates) {
  final List<String> fuzzyText = input.split(' ');
  return candidates
      .where((String candidate) => fuzzyText.every((String subtext) =>
          candidate.toLowerCase().contains(subtext.toLowerCase())))
      .toList()
        ..sort();
}

