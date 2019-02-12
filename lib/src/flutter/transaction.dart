import 'package:flutter/material.dart';

class Transaction {
  String date;
  String description;
  List<Posting> postings;

  Transaction(this.date, this.description, this.postings);

  String toString() {
    String result = '$date $description';
    if (postings.length > 0) {
      result += '\n  ' +
          postings
              .map((ps) => ps.toString())
              .where((it) => it != null)
              .join('\n  ');
    }
    return result;
  }
}

class Posting {
  String account;
  String amount;
  String currency;
  Key key;

  Posting({this.key, this.account, this.amount, this.currency});

  String toString() {
    if (account == null) {
      return null;
    } else if (amount == '') {
      return '$account';
    } else {
      return '$account  $amount $currency';
    }
  }
}
