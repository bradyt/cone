import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PostingModel {
  PostingModel({
    String accountControllerText,
    String currencyControllerText,
  })  : accountController = TextEditingController(text: accountControllerText),
        currencyController =
            TextEditingController(text: currencyControllerText);

  Key key = UniqueKey();
  TextEditingController accountController;
  TextEditingController amountController = TextEditingController();
  TextEditingController currencyController;
  SuggestionsBoxController suggestionsBoxController =
      SuggestionsBoxController();
  FocusNode accountFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  FocusNode currencyFocus = FocusNode();
}
