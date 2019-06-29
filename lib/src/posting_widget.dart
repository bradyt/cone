import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cone/src/posting_model.dart';
import 'package:cone/src/settings_model.dart';

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
    final TextEditingController accountController =
        postingModel.accountController;
    final FocusNode accountFocus = postingModel.accountFocus;
    final FocusNode amountFocus = postingModel.amountFocus;
    final bool currencyOnLeft =
        Provider.of<SettingsModel>(context).currencyOnLeft;

    final Widget amountWidget = AmountWidget(
      context,
      postingModel,
      nextPostingFocus,
      amountHintText,
    );
    final Widget currencyWidget = CurrencyWidget(
      context,
      postingModel,
      nextPostingFocus,
      currencyOnLeft: currencyOnLeft,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: accountController,
            focusNode: accountFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (String term) {
              accountFocus.unfocus();
              FocusScope.of(context).requestFocus(amountFocus);
            },
          ),
        ),
        if (currencyOnLeft) currencyWidget,
        amountWidget,
        if (!currencyOnLeft) currencyWidget,
      ],
    );
  }
}

class AmountWidget extends StatelessWidget {
  const AmountWidget(
    this.context,
    this.postingModel,
    this.nextPostingFocus,
    this.amountHintText,
  );

  final BuildContext context;
  final PostingModel postingModel;
  final FocusNode nextPostingFocus;
  final String amountHintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        width: 80,
        child: TextFormField(
          textAlign: TextAlign.center,
          controller: postingModel.amountController,
          decoration: InputDecoration(
            hintText: amountHintText,
          ),
          keyboardType: TextInputType.number,
          focusNode: postingModel.amountFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String term) {
            postingModel.amountFocus.unfocus();
            if (nextPostingFocus != null) {
              FocusScope.of(context).requestFocus(nextPostingFocus);
            }
          },
        ),
      ),
    );
  }
}

class CurrencyWidget extends StatelessWidget {
  const CurrencyWidget(
    this.context,
    this.postingModel,
    this.nextPostingFocus, {
    this.currencyOnLeft,
  });

  final BuildContext context;
  final PostingModel postingModel;
  final FocusNode nextPostingFocus;
  final bool currencyOnLeft;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        width: 40,
        child: TextFormField(
          textAlign: TextAlign.center,
          controller: postingModel.currencyController,
          decoration: InputDecoration(
            hintText: '',
          ),
          focusNode: postingModel.currencyFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String term) {
            postingModel.currencyFocus.unfocus();
            if (currencyOnLeft) {
              FocusScope.of(context).requestFocus(postingModel.amountFocus);
            } else if (nextPostingFocus != null) {
              FocusScope.of(context).requestFocus(nextPostingFocus);
            }
          },
        ),
      ),
    );
  }
}
