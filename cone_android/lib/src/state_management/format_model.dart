import 'package:cone_lib/cone_lib.dart' show Transaction, transactionToString;

class FormatModel {
  String formattedTransaction({
    String locale,
    Transaction transaction,
    bool currencyOnLeft,
    bool spacing,
  }) =>
      transactionToString(
        locale: locale,
        transaction: transaction,
        currencyOnLeft: currencyOnLeft,
        spacing: spacing,
      );
}
