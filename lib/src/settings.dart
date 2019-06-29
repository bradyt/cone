import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cone/src/cone_localizations.dart';
import 'package:cone/src/settings_model.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (BuildContext context, SettingsModel settings, Widget child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(ConeLocalizations.of(context).settings),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.attach_money),
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
                  leading: const Icon(Icons.compare_arrows),
                  title: Text(ConeLocalizations.of(context).currencyOnLeft),
                  subtitle: Text(settings.currencyOnLeft
                      ? '${settings.defaultCurrency} 5.00'
                      : '5.00 ${settings.defaultCurrency}'),
                  onTap: () async {
                    settings.currencyOnLeft = !settings.currencyOnLeft;
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
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(ConeLocalizations.of(context).enterDefaultCurrency),
        content: TextField(
          onChanged: (String value) {
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
