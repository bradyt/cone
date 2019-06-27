import 'package:flutter/material.dart';

import 'package:cone/src/flutter/cone_localizations.dart';
import 'package:cone/src/flutter/posting_blob.dart';

class PostingWidget extends StatelessWidget {
  const PostingWidget({
    this.context,
    this.index,
    this.postingBlob,
    this.nextPostingFocus,
    this.emptyAmountBools,
  });

  final BuildContext context;
  final int index;
  final PostingBlob postingBlob;
  final FocusNode nextPostingFocus;
  final List<bool> Function() emptyAmountBools;

  @override
  Widget build(BuildContext context) {
    final int j = index + 1;
    final TextEditingController accountController =
        postingBlob.accountController;
    final TextEditingController amountController = postingBlob.amountController;
    final TextEditingController currencyController =
        postingBlob.currencyController;
    final FocusNode accountFocus = postingBlob.accountFocus;
    final FocusNode amountFocus = postingBlob.amountFocus;
    final FocusNode currencyFocus = postingBlob.currencyFocus;
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
            validator: (String value) {
              if (value == '') {
                return ConeLocalizations.of(context).enterAnAccount;
              }
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
                  hintText:
                      ConeLocalizations.of(context).numberFormat.format(0),
                ),
                keyboardType: TextInputType.number,
                focusNode: amountFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (String term) {
                  amountFocus.unfocus();
                  FocusScope.of(context).requestFocus(currencyFocus);
                },
                validator: (String value) {
                  final List<bool> bools = emptyAmountBools();
                  if (j == 1 && bools.length == 1 && bools[0] == true) {
                    return ConeLocalizations.of(context).enterAnAmount;
                  } else if (<String>['', null].contains(value) &&
                      (bools.sublist(0, j).where((bool it) => it).length ==
                          2)) {
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
