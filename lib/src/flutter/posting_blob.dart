import 'package:flutter/material.dart';

class PostingBlob {
  Key key;
  TextEditingController accountController;
  TextEditingController amountController;
  TextEditingController currencyController;
  FocusNode accountFocus;
  FocusNode amountFocus;
  FocusNode currencyFocus;

  PostingBlob({
    this.key,
    this.accountController,
    this.amountController,
    this.currencyController,
    this.accountFocus,
    this.amountFocus,
    this.currencyFocus,
  });
}
