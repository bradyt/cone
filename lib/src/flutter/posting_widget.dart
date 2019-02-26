import 'package:flutter/material.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormField(
            controller: accountController,
            decoration: InputDecoration(
              labelText: 'Account $j',
              border: OutlineInputBorder(),
            ),
            focusNode: accountFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              accountFocus.unfocus();
              FocusScope.of(context).requestFocus(amountFocus);
            },
            validator: (value) {
              if (value == '') {
                return 'Enter an account.';
              }
            },
          ),
        ),
        Expanded(
          child: TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount $j',
                border: OutlineInputBorder(),
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
                  return 'Enter an amount.';
                } else if (['', null].contains(value) &&
                    (bools.sublist(0, j).where((it) => it).length == 2)) {
                  return 'Second empty amount.';
                }
              }),
        ),
        Flexible(
          child: TextFormField(
            controller: currencyController,
            decoration: InputDecoration(
              labelText: 'Currency $j',
              border: OutlineInputBorder(),
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
