// ignore_for_file: public_member_api_docs

import 'package:petitparser/petitparser.dart';

import 'package:cone_lib/src/types.dart';

class _JournalGrammarDefinition extends GrammarDefinition {
  @override
  Parser<List<Token<String>>> start() => journalItem()
      .flatten()
      .map((String string) => string.trim())
      .token()
      .star()
      .end();

  Parser<dynamic> journalItem() => block() | inert();

  Parser<List<dynamic>> block() =>
      (pattern('A-Za-z0-9~')) &
      restOfLine() &
      (newline() & restOfBlock()).optional();

  Parser<List<dynamic>> restOfBlock() => indentedLine()
      .separatedBy<dynamic>(newline(), optionalSeparatorAtEnd: true);

  Parser<List<dynamic>> indentedLine() => anyOf(' \t').plus() & restOfLine();

  Parser<List<dynamic>> inert() =>
      (newline() | (pattern('A-Za-z0-9~').not() & any() & restOfLine())).plus();

  Parser<String> newline() => char('\n');

  Parser<List<String>> restOfLine() => newline().neg().star();
}

class _JournalParserDefinition extends _JournalGrammarDefinition {}

class JournalParser extends GrammarParser {
  JournalParser() : super(_JournalParserDefinition());
}

JournalItem parseJournalItem(Token<String> token) {
  if (token.value.startsWith(RegExp(r'[0-9~]'))) {
    return _parseTransaction(token);
  } else if (token.value.startsWith(RegExp(r'[A-Za-z]'))) {
    if (token.value.startsWith('account')) {
      return AccountDirective(
        firstLine: token.line,
        lastLine: Token.lineAndColumnOf(token.buffer, token.stop)[0],
        account: token.value.split('account ')[1].split(';')[0].trim(),
      );
    } else {
      return Directive(
        firstLine: token.line,
        lastLine: Token.lineAndColumnOf(token.buffer, token.stop)[0],
        directive: token.value,
      );
    }
  } else {
    return Comment(
      firstLine: token.line,
      lastLine: Token.lineAndColumnOf(token.buffer, token.stop)[0],
      comment: token.value,
    );
  }
}

Transaction _parseTransaction(Token<String> token) {
  final String chunk = token.value;
  final List<String> lines = chunk.split('\n');
  final String date = '${lines[0].split(' ')[0]}';
  final int splitAt = lines[0].indexOf(' ');
  final String description = lines[0].substring(splitAt).trim();
  final List<Posting> postings = <Posting>[];
  for (final String line in lines.sublist(1)) {
    if (!line.startsWith(RegExp(r'[ \t]*;'))) {
      final String account = '${line.trim().split('  ')[0]}';
      final int splitAt2 = line.trim().indexOf('  ');
      Amount amount;
      if (splitAt2 != -1) {
        amount = _parseAmount(line.trim().substring(splitAt2).trim());
      }
      postings.add(
        Posting(
          account: account,
          amount: amount,
        ),
      );
    }
  }
  return Transaction(
    firstLine: token.line,
    lastLine: Token.lineAndColumnOf(token.buffer, token.stop)[0],
    date: date,
    description: description,
    postings: postings,
  );
}

Amount _parseAmount(String amount) {
  String commodity;
  String quantity;
  bool commodityOnLeft;
  int spacing;

  if (amount.startsWith(RegExp(r'[-+0-9.,]+'))) {
    commodityOnLeft = false;
    quantity = RegExp(r'^[-+0-9.,]+').stringMatch(amount);
    commodity = amount.split(RegExp(r'^[-+0-9.,]+'))[1].trim();
    spacing = (amount.startsWith(RegExp(r'[-+0-9.,]+ '))) ? 1 : 0;
  } else if (amount.startsWith(RegExp(r'[A-Za-z]+'))) {
    commodity = RegExp(r'^[A-Za-z]+').stringMatch(amount);
    quantity = amount.split(RegExp(r'^[A-Za-z]+'))[1].trim();
    spacing = (amount.startsWith(RegExp(r'[A-Za-z]+ '))) ? 1 : 0;
    commodityOnLeft = true;
  }

  return Amount(
    commodity: commodity,
    commodityOnLeft: commodityOnLeft,
    quantity: quantity,
    spacing: spacing,
  );
}
