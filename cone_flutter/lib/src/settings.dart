import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Actions;
import 'package:flutter_redux/flutter_redux.dart'
    show StoreBuilder, StoreConnector;
import 'package:intl/intl.dart' show NumberFormat;
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;
import 'package:redux/redux.dart' show Store;

import 'package:cone/src/localizations.dart';
import 'package:cone/src/redux/actions.dart';
import 'package:cone/src/redux/state.dart';
import 'package:cone/src/reselect.dart' show formattedExample;
import 'package:cone/src/types.dart';
import 'package:cone/src/utils.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ConeLocalizations.of(context).settings),
      ),
      body: SettingsBody(),
    );
  }
}

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
            if (!kReleaseMode)
              ListTile(
                leading: const Icon(Icons.developer_mode),
                title: const Text('Debug mode'),
                subtitle: StoreConnector<ConeState, String>(
                  converter: (Store<ConeState> store) =>
                      '${store.state.debugMode}',
                  builder: (_, String debugMode) => Text(debugMode),
                  distinct: true,
                ),
                onTap: () => store.dispatch(
                  UpdateSettingsAction(
                      'debug_mode', !(store.state.debugMode ?? true)),
                ),
              ),
            ExpansionTile(
              key: const Key('Formatting'),
              leading: const Icon(
                Icons.text_format,
              ),
              title: Text(
                formattedExample(state),
              ),
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: Text(ConeLocalizations.of(context).defaultCurrency),
                  subtitle: Text(state.defaultCurrency),
                  onTap: () async {
                    final String defaultCurrency =
                        await _asyncDefaultCurrencyDialog(context);
                    store.dispatch(
                      UpdateSettingsAction(
                          'default_currency', defaultCurrency ?? ''),
                    );
                  },
                ),
                ListTile(
                  key: const Key('Locale'),
                  leading: const Icon(Icons.language),
                  title: Text(ConeLocalizations.of(context).numberLocale),
                  subtitle: Text(state.numberLocale),
                  onTap: () async {
                    final String numberLocale = await showSearch<String>(
                      context: context,
                      delegate: NumberLocaleSearchDelegate(),
                    );
                    if (numberLocale != null) {
                      store.dispatch(
                        UpdateSettingsAction('number_locale', numberLocale),
                      );
                    }
                  },
                ),
                SwitchListTile(
                  key: const Key('Currency on left'),
                  secondary: const Icon(Icons.compare_arrows),
                  title: Text(ConeLocalizations.of(context).currencyOnLeft),
                  value: state.currencyOnLeft,
                  onChanged: (bool _) => store.dispatch(
                    UpdateSettingsAction(
                        'currency_on_left', !state.currencyOnLeft),
                  ),
                ),
                SwitchListTile(
                    key: const Key('Spacing'),
                    secondary: const Icon(Icons.space_bar),
                    title: Text(ConeLocalizations.of(context).spacing),
                    value: state.spacing.index == 1,
                    onChanged: (bool _) {
                      store.dispatch(
                        UpdateSettingsAction(
                            'spacing',
                            (state.spacing == Spacing.one)
                                ? Spacing.zero
                                : Spacing.one),
                      );
                    }),
              ],
            ),
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
            SwitchListTile(
              key: const Key('Toggle reverse sort'),
              secondary: const Icon(Icons.sort),
              title: Text(ConeLocalizations.of(context).reverseSort),
              value: state.reverseSort,
              onChanged: (bool _) => store.dispatch(
                UpdateSettingsAction('reverse_sort', !state.reverseSort),
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.brightness_medium),
              title: const Text('Brightness'),
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.brightness_auto),
                  title: const Text('Auto'),
                  trailing: Radio<ConeBrightness>(
                    value: ConeBrightness.auto,
                    groupValue: state.brightness,
                    onChanged: (ConeBrightness value) =>
                        store.dispatch(SetBrightness(value)),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_high),
                  title: const Text('Light'),
                  trailing: Radio<ConeBrightness>(
                    value: ConeBrightness.light,
                    groupValue: state.brightness,
                    onChanged: (ConeBrightness value) =>
                        store.dispatch(SetBrightness(value)),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_low),
                  title: const Text('Dark'),
                  trailing: Radio<ConeBrightness>(
                    value: ConeBrightness.dark,
                    groupValue: state.brightness,
                    onChanged: (ConeBrightness value) =>
                        store.dispatch(SetBrightness(value)),
                  ),
                ),
              ],
            ),
          ],
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
            defaultCurrency = value ?? '';
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

class NumberLocaleSearchDelegate extends SearchDelegate<String> {
  @override
  //ignore: missing_return
  List<Widget> buildActions(BuildContext context) {}

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
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
