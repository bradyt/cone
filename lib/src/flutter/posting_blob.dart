import 'package:flutter/material.dart';

class PostingBlob {
  PostingBlob({
    String accountControllerText,
    String currencyControllerText,
  })  : accountController = TextEditingController(text: accountControllerText),
        currencyController =
            TextEditingController(text: currencyControllerText);

  Key key = UniqueKey();
  TextEditingController accountController;
  TextEditingController amountController = TextEditingController();
  TextEditingController currencyController;
  FocusNode accountFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  FocusNode currencyFocus = FocusNode();
}
