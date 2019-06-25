import 'package:flutter/material.dart';

class Transaction {
  Transaction(this.date, this.description, this.postings);

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
    return result;
  }
}

class Posting {
  Posting({this.key, this.account, this.amount, this.currency});

  String account;
  String amount;
  String currency;
  Key key;

  @override
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
