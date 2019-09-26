import 'package:flutter/foundation.dart';

import 'package:cone_lib/cone_lib.dart';

class SuggestionsModel {
  List<String> _accounts;
  List<String> _descriptions;

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
    _accounts = getAccountsAndSubAccounts(fileContents);
  }

  void _refreshDescriptions(String fileContents) {
    _descriptions = getPayees(fileContents);
  }
}

List<String> fuzzyMatch(String input, List<String> candidates) {
  final List<String> fuzzyText = input.split(' ');
  return candidates
      .where((String candidate) => fuzzyText.every((String subtext) =>
          candidate.toLowerCase().contains(subtext.toLowerCase())))
      .toList();
}
