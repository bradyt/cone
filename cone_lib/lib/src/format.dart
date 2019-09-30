// ignore_for_file: avoid_as
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
  bool spacing = true,
}) {
  final List<Posting> paddedPostings = transaction.postings
      .map(
        (Posting posting) => Posting(
          account: posting.account,
          amount: padZeros(
            locale: locale,
            amount: posting.amount,
            currency: posting.currency,
          ),
          currency: posting.currency,
        ),
      )
      .toList();

  final List<List<String>> spreadPostings = paddedPostings.map(
    (Posting posting) {
      final List<String> splitAmount =
          splitOnDecimalSeparator(locale: locale, amount: posting.amount);
      String currency;
      if (posting.currency == null || posting.amount.isEmpty) {
        currency = '';
      } else if (posting.currency.contains(RegExp(r'[-\t0-9+.@*;\n "{}=]')) &&
          !RegExp(r'^".*"$').hasMatch(posting.currency)) {
        currency = '"${posting.currency}"';
      } else {
        currency = posting.currency;
      }
      return <String>[
        posting.account,
        if (currencyOnLeft && currency.isNotEmpty)
          currency + (spacing ? ' ' : '')
        else
          '',
        ...splitAmount,
        if (!currencyOnLeft && currency.isNotEmpty)
          (spacing ? ' ' : '') + currency
        else
          '',
      ];
    },
  ).toList();

  final List<List<String>> postingsAboutDecimal = spreadPostings
      .map(
        (List<String> posting) => <String>[
          posting[0],
          posting[1] + posting[2],
          posting[3] + posting[4],
        ],
      )
      .toList();

  final int maxWidthOfColumnOne = postingsAboutDecimal.fold(
      0, (int prev, List<String> element) => max(prev, element[0].length));

  final int maxWidthOfColumnTwo = postingsAboutDecimal.fold(
      0, (int prev, List<String> element) => max(prev, element[1].length));

  final StringBuffer buffer = StringBuffer()
    ..write('${transaction.date} ${transaction.description}');

  for (final List<String> posting in postingsAboutDecimal) {
    buffer.write('''

  ${posting[0].padRight(maxWidthOfColumnOne)}  ${posting[1].padLeft(maxWidthOfColumnTwo)}${posting[2]}'''
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

  if (amount.length >= 16) {
    return amount;
  } else {
    try {
      final num parsed = parser.parse(amount);
      final int integerDigits = parsed.round().toString().length;

      formatter = NumberFormat(
          '0.${'0' * decimalDigits}'
          '${'#' * (16 - integerDigits - decimalDigits)}',
          locale);
      return formatter.format(parsed);
    } on FormatException catch (_) {}
    return amount;
  }
}
