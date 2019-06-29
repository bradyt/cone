import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cone/src/cone_localizations.dart';
import 'package:cone/src/settings_model.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () {
        Provider.of<SettingsModel>(context).defaultAccountOne ??=
            ConeLocalizations.of(context).expensesMiscellaneous;
        Provider.of<SettingsModel>(context).defaultAccountTwo ??=
            ConeLocalizations.of(context).assetsChecking;
      },
    );
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
          child: RichWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-transaction');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RichWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '''
Welcome to cone, a mobile plain-text double-entry ledger app.

You can read about plain-text accounting at ''',
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
              text: 'https://plaintextaccounting.org/',
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch(
                    'https://plaintextaccounting.org/',
                  );
                }),
          const TextSpan(
            text: '''.

Press the + button to add a new transaction.

cone will add the transaction to your ledger file, in the following format.

''',
          ),
          const TextSpan(
            text: '''  2016-01-05 Farmer's Market
    expenses:groceries  50 USD
    assets:checking''',
            style: TextStyle(fontFamily: 'RobotoMono'),
          ),
          const TextSpan(
            text: '''


For now, the app writes to the following location:

''',
          ),
          const TextSpan(
            text: '  ~/Documents/cone/.cone.ledger.txt',
            style: TextStyle(fontFamily: 'RobotoMono'),
          ),
          const TextSpan(
            text: '''


We hope to make the location increasingly configurable as the app develops. One might use Syncthing to sync that directory to their PC, VPS, etc.

The cone icon is copyright Ryan Spiering, ''',
          ),
          TextSpan(
              text:
                  'https://thenounproject.com/Ryan-Spiering/collection/3d-shapes/',
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch(
                    'https://thenounproject.com/Ryan-Spiering/collection/3d-shapes/',
                  );
                }),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
