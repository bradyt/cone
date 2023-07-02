import 'package:collection/collection.dart' show IterableNullableExtension;
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
              .whereNotNull()
              .join('\n  ');
    }
    return result.trimRight();
  }
}

class Posting {
  Posting({
    this.key,
    this.account,
    this.amount,
    this.currency,
    this.currencyOnLeft,
  });

  String? account;
  String? amount;
  String? currency;
  bool? currencyOnLeft;
  Key? key;

  @override
  String toString() {
    if (account == null) {
      return '';
    } else if (amount == '') {
      return '$account';
    } else if (currencyOnLeft!) {
      return '$account  $currency $amount'.trimRight();
    } else {
      return '$account  $amount $currency'.trimRight();
    }
  }
}
