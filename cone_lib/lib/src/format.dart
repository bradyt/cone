// ignore_for_file: avoid_as
// ignore_for_file: prefer_interpolation_to_compose_strings
// ignore_for_file: public_member_api_docs

import 'dart:math' show max;

import 'package:intl/intl.dart' show NumberFormat;
import 'package:intl/number_symbols.dart' show NumberSymbols;
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;

import 'package:cone_lib/src/types.dart';

String transactionToString({
  String locale,
  Transaction transaction,
  bool currencyOnLeft = false,
}) {
  // extract postings
  final List<Posting> postings = transaction.postings;

  //
  // first pass
  //
  final List<List<String>> postingsWithSplitAmounts = <List<String>>[];
  int maxWidthOfAccounts = -1;
  int maxWidthOfWholeNumberParts = -1;
  int maxWidthOfDecimalParts = -1;
  for (final Posting posting in postings) {
    maxWidthOfAccounts = max(posting.account.length, maxWidthOfAccounts);
    if (posting.amount.isNotEmpty) {
      final String zeroPaddedAmount = padZeros(
        locale: locale,
        amount: posting.amount,
        currency: posting.currency,
      );
      final List<String> splittedAmount = splitOnDecimalSeparator(
        locale: locale,
        amount: zeroPaddedAmount,
      );
      final String partBeforeDecimal =
          (currencyOnLeft ? posting.currency + ' ' : '') + splittedAmount[0];
      final String decimalAndAfter = splittedAmount[1];
      maxWidthOfWholeNumberParts =
          max(partBeforeDecimal.length, maxWidthOfWholeNumberParts);
      maxWidthOfDecimalParts =
          max(decimalAndAfter.length, maxWidthOfDecimalParts);
      postingsWithSplitAmounts.add(<String>[
        posting.account,
        partBeforeDecimal,
        decimalAndAfter,
        posting.currency,
      ]);
    } else {
      postingsWithSplitAmounts.add(<String>[posting.account, '', '', '']);
    }
  }

  // header
  // String result = '${transaction.date} ${transaction.description}';
  final StringBuffer buffer = StringBuffer()
    ..write('${transaction.date} ${transaction.description}');

  //
  // second pass
  //
  for (final List<String> posting in postingsWithSplitAmounts) {
    buffer.write(('\n  ' +
            posting[0].padRight(maxWidthOfAccounts) +
            '  ' +
            posting[1].padLeft(maxWidthOfWholeNumberParts) +
            posting[2] +
            ((!currencyOnLeft) ? ' ${posting[3]}' : ''))
        .trimRight());
  }

  return buffer.toString();
}

List<String> splitOnDecimalSeparator({
  String locale,
  String amount,
}) {
  final NumberSymbols symbols = numberFormatSymbols[locale] as NumberSymbols;
  final int indexOfDecimalSeparator = amount.indexOf(symbols.DECIMAL_SEP);
  if (indexOfDecimalSeparator > 0) {
    final String wholeNumberPart = amount.substring(0, indexOfDecimalSeparator);
    final String decimalPart = amount.substring(indexOfDecimalSeparator);
    return <String>[wholeNumberPart, decimalPart];
  }
  return <String>[amount, ''];
}

String padZeros({String locale, String amount, String currency}) {
  final int decimalDigits = NumberFormat.currency(name: currency).decimalDigits;
  final NumberFormat parser = NumberFormat.decimalPattern(locale);
  NumberFormat formatter;

  final num parsed = parser.parse(amount);
  final int integerDigits = parsed.round().toString().length;

  if (amount.length >= 16) {
    return amount;
  } else {
    formatter = NumberFormat(
        '0.${'0' * decimalDigits}${'#' * (16 - integerDigits - decimalDigits)}',
        locale);
    return formatter.format(parsed);
  }
}
