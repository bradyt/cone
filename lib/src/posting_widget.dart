import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import 'package:cone/src/posting_model.dart';
import 'package:cone/src/settings_model.dart';
import 'package:cone/src/utils.dart';

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
    final String ledgerFileUri =
        Provider.of<SettingsModel>(context).ledgerFileUri;

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
          child: TypeAheadFormField<String>(
            getImmediateSuggestions: true,
            textFieldConfiguration: TextFieldConfiguration<dynamic>(
              controller: accountController,
              focusNode: accountFocus,
              textInputAction: TextInputAction.next,
              onSubmitted: (dynamic _) {
                accountFocus.unfocus();
                FocusScope.of(context).requestFocus(amountFocus);
              },
            ),
            itemBuilder: (BuildContext context, String suggestion) =>
                ListTile(title: Text(suggestion)),
            onSuggestionSelected: (String suggestion) {
              accountController.text = suggestion;
              accountFocus.unfocus();
              FocusScope.of(context).requestFocus(amountFocus);
            },
            suggestionsBoxController: postingModel.suggestionsBoxController,
            suggestionsCallback: (String text) {
              return GetLines.getLines(ledgerFileUri).then(
                (List<String> lines) {
                  Set<String> accountNames =
                      lines.map(getAccountNameFromLine).toSet()..remove(null);
                  final Set<String> subAccounts = <String>{};
                  for (String accountName in accountNames) {
                    while (accountName.lastIndexOf(':') != -1) {
                      accountName = accountName.substring(
                          0, accountName.lastIndexOf(':'));
                      subAccounts.add(accountName);
                    }
                  }
                  accountNames = accountNames.union(subAccounts);
                  final List<String> fuzzyText = text.split(' ');
                  return accountNames
                      .where((String accountName) => fuzzyText.every(
                          (String subtext) => accountName.contains(subtext)))
                      .toList()
                        ..sort();
                },
              );
            },
            transitionBuilder: (BuildContext context, Widget suggestionsBox,
                AnimationController controller) {
              return suggestionsBox;
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

class GetLines {
  static Future<List<String>> getLines(String ledgerFileUri) async {
    final String fileContents = await readFile(ledgerFileUri);
    return fileContents.split('\n');
  }
}
