import 'package:flutter/material.dart';

import 'package:cone/src/flutter/cone_localizations.dart';
import 'package:cone/src/flutter/posting_model.dart';

class PostingWidget extends StatelessWidget {
  const PostingWidget({
    this.context,
    this.index,
    this.postingModel,
    this.nextPostingFocus,
    this.amountHintText,
  });

  final BuildContext context;
  final int index;
  final PostingModel postingModel;
  final FocusNode nextPostingFocus;
  final String amountHintText;

  @override
  Widget build(BuildContext context) {
    final int j = index + 1;
    final TextEditingController accountController =
        postingModel.accountController;
    final TextEditingController amountController =
        postingModel.amountController;
    final TextEditingController currencyController =
        postingModel.currencyController;
    final FocusNode accountFocus = postingModel.accountFocus;
    final FocusNode amountFocus = postingModel.amountFocus;
    final FocusNode currencyFocus = postingModel.currencyFocus;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: accountController,
            decoration: InputDecoration(
              labelText: '${ConeLocalizations.of(context).account} $j',
            ),
            focusNode: accountFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (String term) {
              accountFocus.unfocus();
              FocusScope.of(context).requestFocus(amountFocus);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 80,
            child: TextFormField(
              textAlign: TextAlign.right,
              controller: amountController,
              decoration: InputDecoration(
                hintText: amountHintText,
              ),
              keyboardType: TextInputType.number,
              focusNode: amountFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String term) {
                amountFocus.unfocus();
                FocusScope.of(context).requestFocus(currencyFocus);
              },
            ),
          ),
        ),
        Container(
          width: 40,
          child: TextFormField(
            textAlign: TextAlign.right,
            controller: currencyController,
            decoration: InputDecoration(
              hintText: '¤',
            ),
            focusNode: currencyFocus,
            textInputAction: (nextPostingFocus != null)
                ? TextInputAction.next
                : TextInputAction.done,
            onFieldSubmitted: (String term) {
              currencyFocus.unfocus();
              if (nextPostingFocus != null) {
                FocusScope.of(context).requestFocus(nextPostingFocus);
              }
            },
          ),
        ),
      ],
    );
  }
}
