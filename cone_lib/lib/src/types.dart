// ignore_for_file: prefer_interpolation_to_compose_strings
// ignore_for_file: public_member_api_docs

class Transaction {
  Transaction({
    this.date,
    this.description,
    this.postings,
  });

  String date;
  String description;
  List<Posting> postings;

  @override
  String toString() {
    String result = '$date $description';
    if (postings.isNotEmpty) {
      result += '\n  ' +
          postings
              .map((Posting ps) => ps.toString())
              .where((String it) => it != null)
              .join('\n  ');
    }
    return result.trimRight();
  }
}

class Posting {
  Posting({
    this.account,
    this.amount,
    this.currency,
    this.currencyOnLeft,
  });

  String account;
  String amount;
  String currency;
  bool currencyOnLeft;

  @override
  String toString() {
    if (account == null) {
      return null;
    } else if (amount == '') {
      return '$account';
    } else if (currencyOnLeft) {
      return '$account  $currency $amount'.trimRight();
    } else {
      return '$account  $amount $currency'.trimRight();
    }
  }
}
