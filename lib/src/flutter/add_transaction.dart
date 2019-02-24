import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:simple_permissions/simple_permissions.dart';

import 'package:cone/src/flutter/transaction.dart';
import 'package:cone/src/flutter/posting_widget.dart';
import 'package:cone/src/flutter/posting_controller.dart';

class AddTransaction extends StatefulWidget {
  AddTransactionState createState() => AddTransactionState();
}

class AddTransactionState extends State<AddTransaction> {
  var dateController = TextEditingController();
  var descriptionController = TextEditingController();

  final FocusNode dateFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();

  var _formKey = GlobalKey<FormState>();

  List<PostingController> postingControllers = [];

  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    postingControllers.add(PostingController(
      key: UniqueKey(),
      accountController: TextEditingController(text: 'expenses:'),
      amountController: TextEditingController(),
      currencyController: TextEditingController(text: 'USD'),
      accountFocus: FocusNode(),
      amountFocus: FocusNode(),
      currencyFocus: FocusNode(),
    ));
    postingControllers.add(PostingController(
      key: UniqueKey(),
      accountController: TextEditingController(text: 'assets:checking'),
      amountController: TextEditingController(),
      currencyController: TextEditingController(text: 'USD'),
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
                List<int>.generate(postingControllers.length, (i) => i)
                    .map((i) {
                  final pc = postingControllers[i];
                  return Dismissible(
                      key: pc.key,
                      onDismissed: (direction) {
                        setState(() {
                          postingControllers.removeAt(i);
                        });
                      },
                      child: PostingWidget(
                        context: context,
                        index: i,
                        accountController: pc.accountController,
                        amountController: pc.amountController,
                        currencyController: pc.currencyController,
                        accountFocus: pc.accountFocus,
                        amountFocus: pc.amountFocus,
                        currencyFocus: pc.currencyFocus,
                        nextPostingFocus: (i < postingControllers.length - 1)
                            ? postingControllers[i + 1].accountFocus
                            : null,
                        asYetOneEmptyAmount: 1 ==
                            // ignore: unnecessary-cast
                            postingControllers.sublist(0, i).fold(
                              0 as int,
                              (int previousValue, PostingController pc) {
                                if (pc.amountController.text == '') {
                                  return previousValue + 1;
                                } else {
                                  return previousValue;
                                }
                              },
                            ) as int,
                      ));
                }),
              ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => setState(() => addPosting()),
      ),
    );
  }

  void addPosting() {
    postingControllers.add(PostingController(
      key: UniqueKey(),
      accountController: TextEditingController(),
      amountController: TextEditingController(),
      currencyController: TextEditingController(text: 'USD'),
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
      postingControllers
          .map((pc) => Posting(
                account: pc.accountController.text,
                amount: pc.amountController.text,
                currency: pc.currencyController.text,
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
      textInputAction: TextInputAction.next,
      focusNode: dateFocus,
      onFieldSubmitted: (term) {
        fieldFocusChange(context, dateFocus, descriptionFocus);
      },
      onSaved: (value) {
        dateController.text = value;
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
      textInputAction: (postingControllers.length > 0)
          ? TextInputAction.next
          : TextInputAction.done,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please add a description, e.g., "Towel"';
        }
      },
      onSaved: (value) {
        descriptionController.text = value;
      },
      onFieldSubmitted: (term) {
        if (postingControllers.length > 0) {
          descriptionFocus.unfocus();
          FocusScope.of(context)
              .requestFocus(postingControllers[0].accountFocus);
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
    bool permission = await SimplePermissions.checkPermission(
        Permission.WriteExternalStorage);
    if (!permission) {
      await SimplePermissions.requestPermission(
          Permission.WriteExternalStorage);
    }
    await Directory(directory).create(recursive: true);
    final file = File(p.join(directory, '.cone.ledger.txt'));
    return file.writeAsString('$transaction', mode: FileMode.append);
  }
}
