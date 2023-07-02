// ignore_for_file: avoid_as
// ignore_for_file: public_member_api_docs

import 'package:intl/intl.dart' show NumberFormat;

String padZeros({String? locale, String? quantity, String? commodity}) {
  if (locale == null || quantity == null) {
    throw Exception('Please use explicit locale with padZeros');
  }
  final int? decimalDigits =
      NumberFormat.currency(name: commodity).decimalDigits;
  final NumberFormat parser = NumberFormat.decimalPattern(locale);
  NumberFormat formatter;

  if (quantity.length >= 16) {
    return quantity;
  } else {
    try {
      final num parsed = parser.parse(quantity);
      final int integerDigits = parsed.round().toString().length;

      formatter = NumberFormat(
          '0.${'0' * decimalDigits!}'
          '${'#' * (15 - integerDigits - decimalDigits)}',
          locale);
      final String result = formatter.format(parsed);
      if (parser.parse(quantity) == parser.parse(result)) {
        return result;
      } else {
        return quantity;
      }
    } on FormatException catch (_) {}
    return quantity;
  }
}
