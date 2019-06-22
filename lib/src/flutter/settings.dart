import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cone/src/flutter/cone_localizations.dart';
import 'package:cone/src/flutter/settings_model.dart';

class Settings extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(ConeLocalizations.of(context).settings),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text(ConeLocalizations.of(context).defaultCurrency),
                  subtitle: Text(settings.defaultCurrency),
                  onTap: () async {
                    final String defaultCurrency =
                        await _asyncDefaultCurrencyDialog(context);
                    if (defaultCurrency != null) {
                      settings.defaultCurrency = defaultCurrency;
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.fastfood),
                  title: Text(ConeLocalizations.of(context).defaultAccountOne),
                  subtitle: Text(settings.defaultAccountOne),
                  onTap: () async {
                    final String defaultAccountOne =
                        await _asyncDefaultAccountOneDialog(context);
                    if (defaultAccountOne != null) {
                      settings.defaultAccountOne = defaultAccountOne;
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.credit_card),
                  title: Text(ConeLocalizations.of(context).defaultAccountTwo),
                  subtitle: Text(settings.defaultAccountTwo),
                  onTap: () async {
                    final String defaultAccountTwo =
                        await _asyncDefaultAccountTwoDialog(context);
                    if (defaultAccountTwo != null) {
                      settings.defaultAccountTwo = defaultAccountTwo;
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<String> _asyncDefaultCurrencyDialog(BuildContext context) async {
  String defaultCurrency;
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(ConeLocalizations.of(context).enterDefaultCurrency),
        content: TextField(
          onChanged: (value) {
            defaultCurrency = value;
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(ConeLocalizations.of(context).submit),
            onPressed: () {
              Navigator.pop(context, defaultCurrency);
            },
          ),
        ],
      );
    },
  );
}

Future<String> _asyncDefaultAccountOneDialog(BuildContext context) async {
  String defaultAccountOne;
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(ConeLocalizations.of(context).enterFirstDefaultAccount),
        content: TextField(
          onChanged: (value) {
            defaultAccountOne = value;
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(ConeLocalizations.of(context).submit),
            onPressed: () {
              Navigator.pop(context, defaultAccountOne);
            },
          ),
        ],
      );
    },
  );
}

Future<String> _asyncDefaultAccountTwoDialog(BuildContext context) async {
  String defaultAccountTwo;
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(ConeLocalizations.of(context).enterSecondDefaultAccount),
        content: TextField(
          onChanged: (value) {
            defaultAccountTwo = value;
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(ConeLocalizations.of(context).submit),
            onPressed: () {
              Navigator.pop(context, defaultAccountTwo);
            },
          ),
        ],
      );
    },
  );
}
