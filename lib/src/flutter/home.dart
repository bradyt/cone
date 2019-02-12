import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cone'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share('check out my website https://example.com');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.body1,
        child: RichWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-transaction');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class RichWidget extends StatelessWidget {
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
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch(
                    'https://plaintextaccounting.org/',
                  );
                }),
          TextSpan(
            text: '''.

Press the + button to add a new transaction.

cone will add the transaction to your ledger file, in the following format.

''',
          ),
          TextSpan(
            text: '''2016-01-05 Farmer's Market
  expenses:groceries  50 USD
  assets:checking''',
            style: TextStyle(fontFamily: "RobotoMono"),
          ),
          TextSpan(text: '\n\nThe cone icon is copyright Ryan Spiering, '),
          TextSpan(
              text:
                  'https://thenounproject.com/Ryan-Spiering/collection/3d-shapes/',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              // style: Theme.of(context)
              //     .textTheme
              //     .body1
              //     .copyWith(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch(
                    'https://thenounproject.com/Ryan-Spiering/collection/3d-shapes/',
                  );
                }),
          TextSpan(text: '.'),
        ],
      ),
    );
  }
}
