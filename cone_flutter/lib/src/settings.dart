import 'package:flutter/material.dart' hide Actions;
import 'package:flutter_redux/flutter_redux.dart' show StoreBuilder;
import 'package:intl/intl.dart' show NumberFormat;
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;
import 'package:redux/redux.dart' show Store;

import 'package:cone/src/localizations.dart';
import 'package:cone/src/redux/actions.dart';
import 'package:cone/src/redux/state.dart';
import 'package:cone/src/utils.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ConeLocalizations.of(context).settings),
        actions: <Widget>[
          StoreBuilder<ConeState>(
            rebuildOnChange: false,
            builder: (BuildContext context, Store<ConeState> store) {
              return PopupMenuButton<void>(
                icon: const Icon(Icons.more_vert),
                offset: const Offset(0, 50),
                onSelected: (_) {
                  store.dispatch(Actions.putEmptyFile);
                },
                itemBuilder: (BuildContext context) {
                  return choices.map((Choice choice) {
                    return PopupMenuItem<Choice>(
                      value: choice,
                      child: Text(choice.title),
                    );
                  }).toList();
                },
              );
            },
          ),
        ],
      ),
      body: SettingsBody(),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

List<Choice> choices = const <Choice>[
  Choice(title: 'Put empty file', icon: Icons.create),
];

class SettingsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: SettingsColumn(),
    );
  }
}

class SettingsColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<ConeState>(
      rebuildOnChange: false,
      builder: (BuildContext context, Store<ConeState> store) {
        final ConeState state = store.state;
        return Column(
          children: <Widget>[
            ListTile(
              key: const Key('Pick ledger file'),
              leading: const Icon(Icons.link),
              title: Text(ConeLocalizations.of(context).ledgerFile),
              subtitle: Text(
                generateAlias(
                  state.ledgerFileUri,
                  state.ledgerFileDisplayName,
                ),
              ),
              onTap: () => store.dispatch(Actions.pickLedgerFileUri),
            ),
          ],
        );
      },
    );
  }
}

class NumberLocaleSearchDelegate extends SearchDelegate<String> {
  // Workaround because of https://github.com/flutter/flutter/issues/32180
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (theme.brightness == Brightness.dark) {
      return theme.copyWith(
        primaryColor: Colors.black,
        primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        primaryColorBrightness: Brightness.dark,
        primaryTextTheme: theme.textTheme,
      );
    } else {
      return theme.copyWith(
        primaryColor: Colors.white,
        primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        primaryColorBrightness: Brightness.light,
        primaryTextTheme: theme.textTheme,
      );
    }
  }

  @override
  //ignore: missing_return
  List<Widget> buildActions(BuildContext context) {}

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  //ignore: missing_return
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> matchedLocales = numberFormatSymbols.keys.where(
      (dynamic locale) {
        return (locale as String).toLowerCase().contains(query.toLowerCase());
      },
    ).toList() as List<String>;
    String currentLocale;
    return ListView.builder(
      itemCount: matchedLocales.length,
      itemBuilder: (BuildContext _, int index) {
        currentLocale = matchedLocales[index];
        return InkWell(
          onTap: () => close(context, query = matchedLocales[index]),
          child: Card(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(currentLocale),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ListTile(
                      title: Text(
                        NumberFormat.decimalPattern(currentLocale).format(
                          1234.56,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
