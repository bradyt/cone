import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:cone/src/flutter/cone_localizations.dart';
import 'package:cone/src/flutter/posting_model.dart';
import 'package:cone/src/flutter/posting_widget.dart';
import 'package:cone/src/flutter/settings_model.dart';
import 'package:cone/src/flutter/transaction.dart';

class AddTransaction extends StatefulWidget {
  @override
  AddTransactionState createState() => AddTransactionState();
}

class AddTransactionState extends State<AddTransaction> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final FocusNode dateFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();

  String defaultCurrency;
  String defaultAccountOne;
  String defaultAccountTwo;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<PostingModel> postingModels = <PostingModel>[];

  List<bool> emptyAmountBools() => postingModels
      .map((PostingModel pb) =>
          <String>['', null].contains(pb.amountController.text))
      .toList();

  @override
  void initState() {
    super.initState();
    final SettingsModel sm = Provider.of<SettingsModel>(context, listen: false);
    defaultCurrency = sm.defaultCurrency;
    defaultAccountOne = sm.defaultAccountOne;
    defaultAccountTwo = sm.defaultAccountTwo;

    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    postingModels
      ..add(PostingModel(
        accountControllerText: defaultAccountOne,
        currencyControllerText: defaultCurrency,
      ))
      ..add(PostingModel(
        accountControllerText: defaultAccountTwo,
        currencyControllerText: defaultCurrency,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ConeLocalizations.of(context).addTransaction),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() => addPosting(defaultCurrency)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              dateAndDescriptionWidget(context),
              ...List<int>.generate(postingModels.length, (int i) => i).map(
                (int i) {
                  return Dismissible(
                    key: postingModels[i].key,
                    onDismissed: (DismissDirection direction) {
                      setState(
                        () => postingModels.removeAt(i),
                      );
                    },
                    child: PostingWidget(
                      context: context,
                      index: i,
                      postingModel: postingModels[i],
                      nextPostingFocus: (i < postingModels.length - 1)
                          ? postingModels[i + 1].accountFocus
                          : null,
                      emptyAmountBools: emptyAmountBools,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () => submitTransaction(context),
          );
        },
      ),
    );
  }

  void addPosting(String defaultCurrency) {
    postingModels.add(PostingModel(
      currencyControllerText: defaultCurrency,
    ));
  }

  void submitTransaction(BuildContext context) {
    _formKey.currentState.save();
    final Transaction txn = Transaction(
      dateController.text,
      descriptionController.text,
      postingModels
          .map((PostingModel pb) => Posting(
                account: pb.accountController.text,
                amount: pb.amountController.text,
                currency: pb.currencyController.text,
              ))
          .toList(),
    );
    if (_formKey.currentState.validate()) {
      final String result = txn.toString();
      final SnackBar snackBar = SnackBar(
        content: RichText(
          text: TextSpan(
            text: result,
            style: TextStyle(
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
      );
      TransactionStorage.writeTransaction('\n\n' + result);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Row dateAndDescriptionWidget(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 156,
            child: dateFormField(context),
          ),
        ),
        Expanded(
          child: descriptionFormField(context),
        ),
      ],
    );
  }

  TextFormField dateFormField(BuildContext context) {
    return TextFormField(
      controller: dateController,
      focusNode: dateFocus,
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (String term) {
        fieldFocusChange(context, dateFocus, descriptionFocus);
      },
      onSaved: (String value) {
        dateController.text = value;
      },
      validator: (String value) {
        if (value == '') {
          return ConeLocalizations.of(context).enterADate;
        }
        try {
          DateTime.parse(value);
        } catch (e) {
          return ConeLocalizations.of(context).tryRFC3339;
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        labelText: ConeLocalizations.of(context).date,
        suffixIcon: IconButton(
          onPressed: () {
            chooseDate(context, dateController.text);
          },
          icon: const Icon(
            Icons.calendar_today,
          ),
        ),
      ),
    );
  }

  Future<void> chooseDate(
      BuildContext context, String initialDateString) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = convertToDate(initialDateString) ?? now;
    final DateTime result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (result != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(result);
      });
      fieldFocusChange(context, dateFocus, descriptionFocus);
    }
  }

  DateTime convertToDate(String input) {
    try {
      final DateTime d = DateFormat('yyyy-MM-dd').parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  TextFormField descriptionFormField(BuildContext context) {
    return TextFormField(
      controller: descriptionController,
      autofocus: true,
      focusNode: descriptionFocus,
      textInputAction: postingModels.isNotEmpty
          ? TextInputAction.next
          : TextInputAction.done,
      validator: (String value) {
        if (value.isEmpty) {
          return ConeLocalizations.of(context).enterADescription;
        }
      },
      onSaved: (String value) {
        descriptionController.text = value;
      },
      onFieldSubmitted: (String term) {
        if (postingModels.isNotEmpty) {
          descriptionFocus.unfocus();
          FocusScope.of(context).requestFocus(postingModels[0].accountFocus);
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        labelText: ConeLocalizations.of(context).description,
      ),
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

class TransactionStorage {
  static Future<void> writeTransaction(String transaction) async {
    const String directory = '/storage/emulated/0/Documents/cone/';
    final PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      await PermissionHandler()
          .requestPermissions(<PermissionGroup>[PermissionGroup.storage]);
    }
    await Directory(directory).create(recursive: true);
    final File file = File(p.join(directory, '.cone.ledger.txt'));
    return file.writeAsString('$transaction', mode: FileMode.append);
  }
}
