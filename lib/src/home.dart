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
          : Builder(
              builder: (BuildContext context) => FloatingActionButton(
                    onPressed: () async {
                      final dynamic transaction =
                          await Navigator.pushNamed<dynamic>(
                              context, '/add-transaction');
                      if (transaction != null) {
                        final SnackBar snackBar = SnackBar(
                          content: RichText(
                            text: TextSpan(
                              text: transaction as String,
                              style: const TextStyle(
                                fontFamily: 'IBMPlexMono',
                              ),
                            ),
                          ),
                        );
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
    String body({String fileContents, String code}) {
      if (code == null) {
        if (fileContents == null) {
          return 'Please select a .txt file';
        } else {
          return fileContents.replaceAll(' ', '·').replaceAll('\t', '» ');
        }
      } else {
        return 'Error\ncode: $code\nmessage: $message';
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: body(fileContents: fileContents, code: code),
                style: const TextStyle(fontFamily: 'IBMPlexMono'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
