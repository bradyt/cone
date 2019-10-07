import 'package:intl/intl.dart' show NumberFormat;

import 'package:cone_lib/cone_lib.dart' show padZeros, Posting;

String formattedAmountHint({
  String locale,
  int index,
  List<Posting> postings,
}) {
  final NumberFormat numberFormat = NumberFormat.decimalPattern(locale);
  final bool moreThanOneAccountWithNoAmount = postings
          .where((Posting posting) =>
              posting.account.isNotEmpty && posting.amount.isEmpty)
          .length >
      1;

  final int firstRowWithEmptyAmount =
      postings.indexWhere((Posting posting) => posting.amount.isEmpty);

  final num total = postings
      .map(
        (Posting posting) {
          num result;
          try {
            result = numberFormat.parse(posting.amount);
          } on FormatException catch (_) {}
          return result;
        },
      )
      .where((num x) => x != null)
      .fold(0, (num x, num y) => x + y);

  final bool allCurrenciesMatch =
      postings.map((Posting posting) => posting.currency).toSet().length == 1;

  final num amountHint = (index == firstRowWithEmptyAmount &&
          allCurrenciesMatch &&
          !moreThanOneAccountWithNoAmount &&
          firstRowWithEmptyAmount != -1)
      ? -total
      : 0;

  final String formattedAmountHint = numberFormat.format(amountHint);
  final String result = padZeros(
    locale: locale,
    amount: formattedAmountHint,
    currency: postings[index].currency,
  );
  return result;
}
