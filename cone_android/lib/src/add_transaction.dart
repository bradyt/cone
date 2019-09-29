import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'package:cone/src/localizations.dart' show ConeLocalizations;
import 'package:cone/src/model.dart' show ConeModel;
import 'package:cone/src/state_management/posting_model.dart' show PostingModel;
import 'package:cone/src/utils.dart' show showGenericInfo;

class AddTransaction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ConeLocalizations.of(context).addTransaction),
      ),
      body: AddTransactionBody(),
      floatingActionButton: SaveButton(),
    );
  }
}

class AddTransactionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool saveInProgress = ConeModel.of(context).saveInProgress;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: saveInProgress ? 0.5 : 1.0,
          child: AddTransactionForm(),
        ),
        if (saveInProgress)
          const ModalBarrier(
            dismissible: false,
          ),
        if (saveInProgress) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class AddTransactionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConeModel coneModel = ConeModel.of(context);

    Future<void>.microtask(
      coneModel.ensurePostingsAreNotFull,
    );

    return ListView.builder(
      itemCount: coneModel.postingModels.length + 1,
      itemBuilder: (BuildContext context, int index) => (index == 0)
          ? DateAndDescriptionWidget()
          : DismissiblePostingWidget(index - 1),
    );
  }
}

class DateAndDescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Container(
            width: 156,
            child: DateField(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: DescriptionField(),
            ),
          ),
        ],
      ),
    );
  }
}

class DateField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConeModel coneModel = ConeModel.of(context);
    return TextField(
      controller: coneModel.dateController,
      focusNode: coneModel.dateFocus,
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.next,
      onSubmitted: (String _) {
        coneModel.dateFocus.unfocus();
        FocusScope.of(context).requestFocus(coneModel.descriptionFocus);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            final DateTime result = await showDatePicker(
              context: context,
              initialDate: coneModel.initialDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (result != null) {
              coneModel.dateController.text =
                  DateFormat('yyyy-MM-dd').format(result);
              coneModel.dateFocus.unfocus();
              FocusScope.of(context).requestFocus(coneModel.descriptionFocus);
            } else {
              FocusScope.of(context).requestFocus(coneModel.dateFocus);
            }
          },
        ),
      ),
    );
  }
}

class DescriptionField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConeModel coneModel = ConeModel.of(context);
    return TypeAheadFormField<String>(
      textFieldConfiguration: TextFieldConfiguration<dynamic>(
        controller: coneModel.descriptionController,
        autofocus: true,
        focusNode: coneModel.descriptionFocus,
        textInputAction: (coneModel.postingModels.isEmpty)
            ? TextInputAction.done
            : TextInputAction.next,
        onSubmitted: (dynamic _) {
          coneModel.descriptionFocus.unfocus();
          FocusScope.of(context)
              .requestFocus(coneModel.postingModels[0].accountFocus);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
      itemBuilder: (BuildContext _, String suggestion) =>
          ListTile(title: Text(suggestion)),
      onSuggestionSelected: (String suggestion) {
        coneModel.descriptionController.text = suggestion;
        coneModel.descriptionFocus.unfocus();
        FocusScope.of(context)
            .requestFocus(coneModel.postingModels[0].accountFocus);
      },
      suggestionsBoxController: coneModel.suggestionsBoxController,
      suggestionsCallback: ConeModel.of(context).descriptionSuggestions,
      transitionBuilder:
          (BuildContext _, Widget suggestionsBox, AnimationController __) =>
              suggestionsBox,
    );
  }
}

class DismissiblePostingWidget extends StatelessWidget {
  const DismissiblePostingWidget(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    final ConeModel coneModel = ConeModel.of(context);
    return Dismissible(
      key: coneModel.postingModels[index].key,
      onDismissed: (DismissDirection _) =>
          coneModel.removeAtAndNotifyListeners(index),
      child: PostingWidget(index),
    );
  }
}

class PostingWidget extends StatelessWidget {
  const PostingWidget(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    final bool currencyOnLeft = ConeModel.of(context).currencyOnLeft;
    final Widget accountWidget = Expanded(
      child: AccountField(index),
    );
    final Widget amountWidget = Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        width: 80,
        child: AmountField(index),
      ),
    );
    final Widget currencyWidget = Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        width: 40,
        child: CurrencyField(index),
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: <Widget>[
          accountWidget,
          if (currencyOnLeft) currencyWidget,
          amountWidget,
          if (!currencyOnLeft) currencyWidget,
        ],
      ),
    );
  }
}

class AccountField extends StatelessWidget {
  const AccountField(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    final PostingModel pm = ConeModel.of(context).postingModels[index];
    return TypeAheadField<String>(
      getImmediateSuggestions: true,
      textFieldConfiguration: TextFieldConfiguration<dynamic>(
        controller: pm.accountController,
        focusNode: pm.accountFocus,
        textInputAction: TextInputAction.next,
        onSubmitted: (dynamic _) {
          pm.accountFocus.unfocus();
          FocusScope.of(context).requestFocus(pm.amountFocus);
        },
      ),
      itemBuilder: (BuildContext _, String suggestion) =>
          ListTile(title: Text(suggestion)),
      onSuggestionSelected: (String suggestion) {
        pm.accountController.text = suggestion;
        pm.accountFocus.unfocus();
        FocusScope.of(context).requestFocus(pm.amountFocus);
      },
      suggestionsBoxController: pm.suggestionsBoxController,
      suggestionsCallback: ConeModel.of(context).accountSuggestions,
      transitionBuilder:
          (BuildContext _, Widget suggestionsBox, AnimationController __) =>
              suggestionsBox,
    );
  }
}

class AmountField extends StatelessWidget {
  const AmountField(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    final List<PostingModel> pms = ConeModel.of(context).postingModels;
    final FocusNode nextPostingFocus =
        (index < pms.length - 1) ? pms[index + 1].accountFocus : null;
    final PostingModel pm = pms[index];
    return TextField(
      textAlign: TextAlign.center,
      controller: pm.amountController,
      decoration: InputDecoration(
        hintText: ConeModel.of(context).formattedAmountHint(index),
      ),
      keyboardType: TextInputType.number,
      focusNode: pm.amountFocus,
      textInputAction: TextInputAction.next,
      onSubmitted: (String term) {
        pm.amountFocus.unfocus();
        if (nextPostingFocus != null) {
          FocusScope.of(context).requestFocus(nextPostingFocus);
        }
      },
    );
  }
}

class CurrencyField extends StatelessWidget {
  const CurrencyField(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    final bool currencyOnLeft = ConeModel.of(context).currencyOnLeft;
    final List<PostingModel> pms = ConeModel.of(context).postingModels;
    final FocusNode nextPostingFocus =
        (index < pms.length - 1) ? pms[index + 1].accountFocus : null;
    final PostingModel pm = pms[index];
    return TextField(
      textAlign: TextAlign.center,
      controller: pm.currencyController,
      decoration: InputDecoration(
        hintText: '¤',
      ),
      focusNode: pm.currencyFocus,
      textInputAction: TextInputAction.next,
      onSubmitted: (String term) {
        pm.currencyFocus.unfocus();
        if (currencyOnLeft) {
          FocusScope.of(context).requestFocus(pm.amountFocus);
        } else if (nextPostingFocus != null) {
          FocusScope.of(context).requestFocus(nextPostingFocus);
        }
      },
    );
  }
}

class SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool readyForSave = ConeModel.of(context).makeSaveButtonAvailable;
    return FloatingActionButton(
      child: readyForSave
          ? const Icon(Icons.save)
          : Icon(Icons.save, color: Colors.grey[600]),
      onPressed: readyForSave ? () => submitTransaction(context) : null,
      backgroundColor: readyForSave ? null : Colors.grey[400],
    );
  }
}

Future<void> submitTransaction(BuildContext context) async {
  final ConeModel coneModel = ConeModel.of(context);
  final String transaction = coneModel.formattedTransaction();
  try {
    await coneModel.appendTransaction(transaction);
    if (coneModel.debugMode) {
      Scaffold.of(context).showSnackBar(coneModel.snackBar(transaction));
    } else {
      Navigator.of(context).pop(transaction);
    }
  } on PlatformException catch (e) {
    final String ledgerFileUri = coneModel.ledgerFileUri;
    await showGenericInfo(
      context: context,
      info: <String, String>{
        'Code': e.code,
        'Message': e.message,
        'Uri authority component': Uri.tryParse(ledgerFileUri).authority,
        'Uri path component': Uri.tryParse(Uri.decodeFull(ledgerFileUri)).path,
        'Uri': Uri.decodeFull(ledgerFileUri),
      },
    );
  }
}
