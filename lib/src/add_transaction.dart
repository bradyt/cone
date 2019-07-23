import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:cone/src/cone_localizations.dart';
import 'package:cone/src/posting_model.dart';
import 'package:cone/src/posting_widget.dart';
import 'package:cone/src/settings_model.dart';
import 'package:cone/src/transaction.dart';
import 'package:cone/src/utils.dart';

class AddTransaction extends StatefulWidget {
  @override
  AddTransactionState createState() => AddTransactionState();
}

class AddTransactionState extends State<AddTransaction> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  SuggestionsBoxController suggestionsBoxController =
      SuggestionsBoxController();
  final FocusNode dateFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();

  String ledgerFileUri;
  String defaultCurrency;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<PostingModel> postingModels = <PostingModel>[];

  @override
  void initState() {
    super.initState();
    ledgerFileUri =
        Provider.of<SettingsModel>(context, listen: false).ledgerFileUri;
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
  void dispose() {
    suggestionsBoxController.close();
    for (final PostingModel postingModel in postingModels) {
      postingModel.suggestionsBoxController.close();
    }
    super.dispose();
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

  Future<void> submitTransaction(BuildContext context) async {
    _formKey.currentState.save();
    final String transaction = Transaction(
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
    ).toString();
    try {
      await isUriOpenable(ledgerFileUri);
      await appendFile(ledgerFileUri, transaction);
      Navigator.of(context).pop(transaction);
    } on PlatformException catch (e) {
      await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Code'),
                    subtitle: Text(e.code),
                  ),
                  ListTile(
                    title: const Text('Message'),
                    subtitle: Text(e.message),
                  ),
                  ListTile(
                    title: const Text('Uri authority component'),
                    subtitle: Text(Uri.tryParse(ledgerFileUri).authority),
                  ),
                  ListTile(
                    title: const Text('Uri path component'),
                    subtitle:
                        Text(Uri.tryParse(Uri.decodeFull(ledgerFileUri)).path),
                  ),
                  ListTile(
                    title: const Text('Uri'),
                    subtitle: Text(Uri.decodeFull(ledgerFileUri)),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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

  TypeAheadFormField<String> descriptionFormField(BuildContext context) {
    return TypeAheadFormField<String>(
      textFieldConfiguration: TextFieldConfiguration<dynamic>(
        controller: descriptionController,
        autofocus: true,
        focusNode: descriptionFocus,
        textInputAction: postingModels.isNotEmpty
            ? TextInputAction.next
            : TextInputAction.done,
        onSubmitted: (dynamic _) {
          descriptionFocus.unfocus();
          FocusScope.of(context).requestFocus(postingModels[0].accountFocus);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
      itemBuilder: (BuildContext context, String suggestion) =>
          ListTile(title: Text(suggestion)),
      onSuggestionSelected: (String suggestion) {
        descriptionController.text = suggestion;
        descriptionFocus.unfocus();
        FocusScope.of(context).requestFocus(postingModels[0].accountFocus);
      },
      suggestionsBoxController: suggestionsBoxController,
      suggestionsCallback: (String text) {
        return GetLines.getLines(ledgerFileUri).then(
          (List<String> lines) {
            final Set<String> descriptionNames = <String>{
              for (final String line in lines)
                getTransactionDescriptionFromLine(line)
            }..remove(null);
            final List<String> fuzzyText = text.split(' ');
            return descriptionNames
                .where((String descriptionName) => fuzzyText.every(
                    (String subtext) => descriptionName.contains(subtext)))
                .toList()
                  ..sort();
          },
        );
      },
      transitionBuilder: (BuildContext context, Widget suggestionsBox,
          AnimationController controller) {
        return suggestionsBox;
      },
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

class GetLines {
  static Future<List<String>> getLines(String ledgerFileUri) async {
    final String fileContents = await readFile(ledgerFileUri);
    return fileContents.split('\n');
  }
}
