import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:cone/src/cone_localizations.dart';
import 'package:cone/src/posting_model.dart';
import 'package:cone/src/posting_widget.dart';
import 'package:cone/src/settings_model.dart';
import 'package:cone/src/transaction.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<PostingModel> postingModels = <PostingModel>[];

  @override
  void initState() {
    super.initState();
    defaultCurrency =
        Provider.of<SettingsModel>(context, listen: false).defaultCurrency;

    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    postingModels
      ..add(PostingModel(
        currencyControllerText: defaultCurrency,
      ))
      ..add(PostingModel(
        currencyControllerText: defaultCurrency,
      ));
    dateController.addListener(() => setState(() {}));
    descriptionController.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final PostingModel postingModel in postingModels) {
      postingModel
        ..accountController.addListener(() => setState(() {}))
        ..amountController.addListener(() => setState(() {}))
        ..currencyController.addListener(() => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (postingModels.every((PostingModel postingModel) =>
        postingModel.accountController.text.isNotEmpty)) {
      postingModels.add(PostingModel(currencyControllerText: defaultCurrency)
        ..accountController.addListener(() => setState(() {}))
        ..amountController.addListener(() => setState(() {}))
        ..currencyController.addListener(() => setState(() {})));
    }
    final bool moreThanOneAccountWithNoAmount = postingModels
            .where((PostingModel postingModel) =>
                postingModel.accountController.text.isNotEmpty &&
                postingModel.amountController.text.isEmpty)
            .length >
        1;
    final int firstRowWithEmptyAmount = postingModels.indexWhere(
        (PostingModel postingModel) =>
            postingModel.amountController.text.isEmpty);
    final num total = postingModels
        .map((PostingModel postingModel) =>
            num.tryParse(postingModel.amountController.text))
        .where((num x) => x != null)
        .fold(0, (num x, num y) => x + y);
    final bool allCurrenciesMatch = postingModels
            .map((PostingModel postingModel) =>
                postingModel.currencyController.text)
            .toSet()
            .length ==
        1;
    return Scaffold(
      appBar: AppBar(
        title: Text(ConeLocalizations.of(context).addTransaction),
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
                      amountHintText: ConeLocalizations.of(context)
                          .numberFormat
                          .format((i == firstRowWithEmptyAmount &&
                                  allCurrenciesMatch &&
                                  !moreThanOneAccountWithNoAmount &&
                                  firstRowWithEmptyAmount != -1)
                              ? -total
                              : 0),
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
          final bool amountWithNoAccount = postingModels.any(
              (PostingModel postingModel) =>
                  postingModel.accountController.text.isEmpty &&
                  postingModel.amountController.text.isNotEmpty);
          final int numberOfAccounts = postingModels
              .where((PostingModel postingModel) =>
                  postingModel.accountController.text.isNotEmpty)
              .length;
          final int numberOfAmounts = postingModels
              .where((PostingModel postingModel) =>
                  postingModel.amountController.text.isNotEmpty)
              .length;
          if (dateController.text.isEmpty ||
              descriptionController.text.isEmpty ||
              amountWithNoAccount ||
              numberOfAccounts < 2 ||
              (numberOfAccounts - numberOfAmounts > 1)) {
            return FloatingActionButton(
              child: Icon(
                Icons.save,
                color: Colors.grey[600],
              ),
              onPressed: () {},
              backgroundColor: Colors.grey[400],
            );
          }
          return FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () => submitTransaction(context),
          );
        },
      ),
    );
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
                currencyOnLeft:
                    Provider.of<SettingsModel>(context).currencyOnLeft,
              ))
          .toList(),
    );
    if (_formKey.currentState.validate()) {
      final String result = txn.toString();
      final SnackBar snackBar = SnackBar(
        content: RichText(
          text: TextSpan(
            text: result,
            style: const TextStyle(
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
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
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
