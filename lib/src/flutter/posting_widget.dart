import 'package:flutter/material.dart';

import 'package:cone/src/flutter/cone_localizations.dart';

class PostingWidget extends StatelessWidget {
  final accountController;
  final amountController;
  final currencyController;
  final int index;
  final FocusNode accountFocus;
  final FocusNode amountFocus;
  final FocusNode currencyFocus;
  final FocusNode nextPostingFocus;
  final Function emptyAmountBools;

  final BuildContext context;

  PostingWidget({
    this.context,
    this.index,
    this.accountController,
    this.amountController,
    this.currencyController,
    this.accountFocus,
    this.amountFocus,
    this.currencyFocus,
    this.nextPostingFocus,
    this.emptyAmountBools,
  });

  Widget build(BuildContext context) {
    int j = index + 1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: TextFormField(
            controller: accountController,
            decoration: InputDecoration(
              labelText: '${ConeLocalizations.of(context).account} $j',
            ),
            focusNode: accountFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              accountFocus.unfocus();
              FocusScope.of(context).requestFocus(amountFocus);
            },
            validator: (value) {
              if (value == '') {
                return ConeLocalizations.of(context).enterAnAccount;
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 80,
            child: TextFormField(
                textAlign: TextAlign.right,
                controller: amountController,
                decoration: InputDecoration(
                  hintText:
                      ConeLocalizations.of(context).numberFormat.format(0),
                ),
                keyboardType: TextInputType.number,
                focusNode: amountFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  amountFocus.unfocus();
                  FocusScope.of(context).requestFocus(currencyFocus);
                },
                validator: (value) {
                  List<bool> bools = emptyAmountBools();
                  if (j == 1 && bools.length == 1 && bools[0] == true) {
                    return ConeLocalizations.of(context).enterAnAmount;
                  } else if (['', null].contains(value) &&
                      (bools.sublist(0, j).where((it) => it).length == 2)) {
                    return ConeLocalizations.of(context).secondEmptyAmount;
                  }
                }),
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
            onFieldSubmitted: (term) {
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
