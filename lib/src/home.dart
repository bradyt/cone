import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:cone/src/settings_model.dart';
import 'package:cone/src/utils.dart';

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
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.body1,
        child: SingleChildScrollView(
          child: Transactions(),
        ),
      ),
      floatingActionButton: (ledgerFileUri == null)
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.grey[400],
              child: Icon(
                Icons.add,
                color: Colors.grey[600],
              ),
            )
          : FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-transaction');
              },
              child: const Icon(Icons.add),
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
          fileContents = await readFile(ledgerFileUri);
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: (code == null)
                    ? (fileContents ?? 'Please select a file')
                    : 'Error\ncode: $code\nmessage: $message',
                style: const TextStyle(fontFamily: 'RobotoMono'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
