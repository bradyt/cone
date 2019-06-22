import 'package:flutter/material.dart';

class PostingBlob {
  PostingBlob({
    this.key,
    this.accountController,
    this.amountController,
    this.currencyController,
    this.accountFocus,
    this.amountFocus,
    this.currencyFocus,
  });

  Key key;
  TextEditingController accountController;
  TextEditingController amountController;
  TextEditingController currencyController;
  FocusNode accountFocus;
  FocusNode amountFocus;
  FocusNode currencyFocus;
}
