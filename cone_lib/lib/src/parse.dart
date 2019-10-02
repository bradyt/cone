// ignore_for_file: public_member_api_docs

import 'package:petitparser/petitparser.dart';

class LedgerGrammarDefinition extends GrammarDefinition {
  @override
  Parser start() =>
      journalItem()
          .flatten()
          .token()
          .separatedBy<Token<String>>(
            newline().star(),
            includeSeparators: false,
            optionalSeparatorAtEnd: true,
          )
          .end() |
      epsilon<dynamic>().map((dynamic _) => <Token<String>>[]).end();

  Parser journalItem() => directive() | transaction() | inert();

  Parser directive() =>
      letter() & restOfLine() & (newline() & indentedLine()).star();

  Parser transaction() =>
      digit() & restOfLine() & (newline() & indentedLine()).star();

  Parser indentedLine() => anyOf(' \t').plus() & restOfLine();

  Parser inert() => inertLine().separatedBy<dynamic>(newline().plus());

  Parser inertLine() => pattern('A-Za-z0-9').neg() & restOfLine();

  Parser newline() => char('\n');

  Parser restOfLine() => newline().neg().star();
}

class LedgerParserDefinition extends LedgerGrammarDefinition {}

class LedgerParser extends GrammarParser {
  LedgerParser() : super(LedgerParserDefinition());
}

Parser parser = LedgerParser();

List<Token<String>> getTokens(String fileContents) =>
    // ignore: avoid_as
    parser.parse(fileContents).value as List<Token<String>>;

List<String> getChunks(String fileContents) =>
    getTokens(fileContents).map((Token<String> token) => token.input).toList();

List<String> getPayees(String fileContents) {
  final List<String> payees = <String>[];

  for (final String chunk in getChunks(fileContents)) {
    if (chunk.startsWith('payee')) {
      payees.add(chunk.replaceFirst(RegExp('payee '), ''));
    } else if (chunk.startsWith(RegExp(r'[0-9]'))) {
      final int beginning = chunk.indexOf(' ');
      final int end = chunk.indexOf(RegExp(r'[;\n]'));
      payees.add(
        (end == -1)
            ? chunk.substring(beginning).trim()
            : chunk.substring(beginning, end).trim(),
      );
    }
  }

  return payees..sort();
}

List<String> getTransactions(String fileContents) {
  final List<String> transactions = <String>[];

  for (final String chunk in getChunks(fileContents)) {
    if (chunk.startsWith(RegExp(r'[0-9]'))) {
      transactions.add(chunk);
    }
  }
  return transactions;
}

List<String> getAccounts(String fileContents) {
  final Set<String> accounts = <String>{};

  for (final String chunk in getChunks(fileContents)) {
    if (chunk.startsWith('account')) {
      accounts.add(chunk.replaceFirst(RegExp('account '), ''));
    } else if (chunk.startsWith(RegExp(r'[0-9]'))) {
      for (final String line in chunk.split('\n')) {
        if (line.startsWith(RegExp(r'[ \t]+[^ \t;]'))) {
          accounts.add(line.trim().split('  ')[0]);
        } else if (line.startsWith(RegExp(r'[-0-9=]+ open [A-Za-z]+:'))) {
          accounts.add(line.replaceFirst(RegExp(r'[-0-9=]+ open '), ''));
        }
      }
    }
  }

  return accounts.toList()..sort();
}

List<String> getAccountsAndSubAccounts(String fileContents) {
  final Set<String> accounts = getAccounts(fileContents).toSet();
  return accounts.union(getSubAccounts(accounts)).toList();
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
