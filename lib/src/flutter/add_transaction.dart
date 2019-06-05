import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:cone/src/flutter/transaction.dart';
import 'package:cone/src/flutter/posting_widget.dart';
import 'package:cone/src/flutter/posting_blob.dart';
import 'package:cone/src/flutter/settings_model.dart';

class AddTransaction extends StatefulWidget {
  AddTransactionState createState() => AddTransactionState();
}

class AddTransactionState extends State<AddTransaction> {
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();

  final FocusNode dateFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();

  String defaultCurrency;
  String defaultAccountOne;
  String defaultAccountTwo;

  var _formKey = GlobalKey<FormState>();

  List<PostingBlob> postingBlobs = [];

  List<bool> emptyAmountBools() => postingBlobs
      .map((pb) => ['', null].contains(pb.amountController.text))
      .toList();

  void initState() {
    super.initState();
    defaultCurrency =
        Provider.of<SettingsModel>(context, listen: false).defaultCurrency;
    defaultAccountOne =
        Provider.of<SettingsModel>(context, listen: false).defaultAccountOne;
    defaultAccountTwo =
        Provider.of<SettingsModel>(context, listen: false).defaultAccountTwo;

    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    postingBlobs.add(PostingBlob(
      key: UniqueKey(),
      accountController: TextEditingController(text: defaultAccountOne),
      amountController: TextEditingController(),
      currencyController: TextEditingController(text: defaultCurrency),
      accountFocus: FocusNode(),
      amountFocus: FocusNode(),
      currencyFocus: FocusNode(),
    ));
    postingBlobs.add(PostingBlob(
      key: UniqueKey(),
      accountController: TextEditingController(text: defaultAccountTwo),
      amountController: TextEditingController(),
      currencyController: TextEditingController(text: defaultCurrency),
      accountFocus: FocusNode(),
      amountFocus: FocusNode(),
      currencyFocus: FocusNode(),
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cone'),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () => submitTransaction(context),
                ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              dateAndDescriptionWidget(context),
            ]..addAll(
                List<int>.generate(postingBlobs.length, (i) => i).map(
                  (i) {
                    final pb = postingBlobs[i];
                    return Dismissible(
                      key: pb.key,
                      onDismissed: (direction) {
                        setState(
                          () => postingBlobs.removeAt(i),
                        );
                      },
                      child: PostingWidget(
                        context: context,
                        index: i,
                        accountController: pb.accountController,
                        amountController: pb.amountController,
                        currencyController: pb.currencyController,
                        accountFocus: pb.accountFocus,
                        amountFocus: pb.amountFocus,
                        currencyFocus: pb.currencyFocus,
                        nextPostingFocus: (i < postingBlobs.length - 1)
                            ? postingBlobs[i + 1].accountFocus
                            : null,
                        emptyAmountBools: emptyAmountBools,
                      ),
                    );
                  },
                ),
              ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => setState(() => addPosting(defaultCurrency)),
      ),
    );
  }

  void addPosting(String defaultCurrency) {
    postingBlobs.add(PostingBlob(
      key: UniqueKey(),
      accountController: TextEditingController(),
      amountController: TextEditingController(),
      currencyController: TextEditingController(text: defaultCurrency),
      accountFocus: FocusNode(),
      amountFocus: FocusNode(),
      currencyFocus: FocusNode(),
    ));
  }

  void submitTransaction(BuildContext context) {
    _formKey.currentState.save();
    Transaction txn = Transaction(
      dateController.text,
      descriptionController.text,
      postingBlobs
          .map((pb) => Posting(
                account: pb.accountController.text,
                amount: pb.amountController.text,
                currency: pb.currencyController.text,
              ))
          .toList(),
    );
    print(txn);
    if (_formKey.currentState.validate()) {
      String result = txn.toString();
      final snackBar = SnackBar(
        content: RichText(
          text: TextSpan(
            text: result,
            style: TextStyle(
              fontFamily: "RobotoMono",
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: dateFormField(context),
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
      onFieldSubmitted: (term) {
        print('onSubmitted $term');
        fieldFocusChange(context, dateFocus, descriptionFocus);
      },
      onSaved: (value) {
        print('onSaved $value');
        dateController.text = value;
      },
      validator: (value) {
        if (value == '') {
          return 'Enter a date.';
        }
        try {
          DateTime.parse(value);
        } catch (e) {
          return 'Try RFC 3339.';
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        // filled: true,
        labelText: 'Date',
        suffixIcon: IconButton(
          onPressed: () {
            chooseDate(context, dateController.text);
          },
          icon: Icon(
            Icons.calendar_today,
          ),
        ),
      ),
    );
  }

  Future chooseDate(BuildContext context, String initialDateString) async {
    DateTime now = DateTime.now();
    DateTime initialDate = convertToDate(initialDateString) ?? now;
    DateTime result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (result == null) return;

    setState(() {
      dateController.text = DateFormat('yyyy-MM-dd').format(result);
    });
    fieldFocusChange(context, dateFocus, descriptionFocus);
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat('yyyy-MM-dd').parseStrict(input);
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
      textInputAction: (postingBlobs.length > 0)
          ? TextInputAction.next
          : TextInputAction.done,
      validator: (value) {
        print('validating $value');
        if (value.isEmpty) {
          return 'Enter a description.';
        }
      },
      onSaved: (value) {
        print('onSaved $value');
        descriptionController.text = value;
      },
      onFieldSubmitted: (term) {
        print('onSubmitted $term');
        if (postingBlobs.length > 0) {
          descriptionFocus.unfocus();
          FocusScope.of(context).requestFocus(postingBlobs[0].accountFocus);
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        // filled: true,
        labelText: 'Description',
      ),
    );
  }

  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

class TransactionStorage {
  static Future<void> writeTransaction(String transaction) async {
    final directory = '/storage/emulated/0/Documents/cone/';
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }
    await Directory(directory).create(recursive: true);
    final file = File(p.join(directory, '.cone.ledger.txt'));
    return file.writeAsString('$transaction', mode: FileMode.append);
  }
}
