import 'package:flutter/material.dart';

class PostingController {
  Key key;
  TextEditingController accountController;
  TextEditingController amountController;
  TextEditingController currencyController;
  FocusNode accountFocus;
  FocusNode amountFocus;
  FocusNode currencyFocus;

  PostingController({
    this.key,
    this.accountController,
    this.amountController,
    this.currencyController,
    this.accountFocus,
    this.amountFocus,
    this.currencyFocus,
  });
}
