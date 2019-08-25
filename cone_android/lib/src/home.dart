import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uri_picker/uri_picker.dart';

import 'package:cone/src/settings_model.dart';
import 'package:cone/src/transaction_snackbar.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String ledgerFileUri;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future<void>.microtask(() async {
      ledgerFileUri = Provider.of<SettingsModel>(context).ledgerFileUri;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('cone'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Transactions(),
      floatingActionButton: (ledgerFileUri == null)
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.grey[400],
              child: Icon(
                Icons.add,
                color: Colors.grey[600],
              ),
            )
          : Builder(
              builder: (BuildContext context) => FloatingActionButton(
                onPressed: () async {
                  final dynamic transaction =
                      await Navigator.pushNamed<dynamic>(
                          context, '/add-transaction');
                  if (transaction != null) {
                    final SnackBar snackBar =
                        transactionSnackBar(transaction as String);
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Icon(Icons.add),
              ),
            ),
    );
  }
}

class Transactions extends StatefulWidget {
  @override
  TransactionsState createState() => TransactionsState();
}

class TransactionsState extends State<Transactions> {
  String ledgerFileUri;
  String fileContents;
  String code;
  String message;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future<void>.microtask(() async {
      ledgerFileUri = Provider.of<SettingsModel>(context).ledgerFileUri;
      if (ledgerFileUri != null) {
        try {
          fileContents = await UriPicker.readTextFromUri(ledgerFileUri);
        } on PlatformException catch (e) {
          code = e.code;
          message = e.message;
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    String body({String fileContents, String code}) {
      if (code == null) {
        if (fileContents == null) {
          return 'Please select a .txt file';
        } else if (!kReleaseMode &&
            Provider.of<SettingsModel>(context).debugMode) {
          return fileContents.replaceAll(' ', '·').replaceAll('\t', '» ');
        } else {
          return fileContents;
        }
      } else {
        return 'Error\ncode: $code\nmessage: $message';
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text.rich(
          TextSpan(
            text: body(fileContents: fileContents, code: code),
          ),
          style: const TextStyle(
            fontFamily: 'IBMPlexMono',
          ),
        ),
      ),
    );
  }
}
