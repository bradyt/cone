// ignore_for_file: public_member_api_docs

List<String> payees(String fileContents) =>
    (fileContents.split('\n').map(getTransactionDescriptionFromLine).toSet()
          ..remove(null))
        .toList()
          ..sort();

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

List<String> accounts(String fileContents) =>
    (fileContents.split('\n').map(getAccountNameFromLine).toSet()..remove(null))
        .toList()
          ..sort();

Set<String> getAccountsAndSubAccountsFromLines(List<String> lines) {
  final Set<String> accounts = lines.map(getAccountNameFromLine).toSet()
    ..remove(null);
  return accounts.union(getSubAccounts(accounts));
}

String getAccountNameFromLine(String line) {
  String result;
  if (line.isNotEmpty) {
    if (line.startsWith(RegExp('[ \t]+[^ \t;]'))) {
      result = line.trim().split('  ').first;
    } else if (line.startsWith('account')) {
      result = line.replaceFirst('account', '').trim();
    } else if (line.startsWith(RegExp(r'[-0-9]{10} open [A-Za-z]+:'))) {
      result = line.trim().split(' ').last;
    }
  }
  return result;
}

Set<String> getSubAccounts(Set<String> accounts) {
  final Set<String> subAccounts = <String>{};
  for (String account in accounts) {
    while (account.lastIndexOf(':') != -1) {
      account = account.substring(0, account.lastIndexOf(':'));
      subAccounts.add(account);
    }
  }
  return subAccounts;
}
