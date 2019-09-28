import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;
import 'package:provider/provider.dart' show Consumer;

import 'package:cone/src/localizations.dart';
import 'package:cone/src/model.dart';
import 'package:cone/src/state_management/settings_model.dart' show ConeBrightness;
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
    return Consumer<ConeModel>(
      builder: (BuildContext _, ConeModel coneModel, Widget __) {
        final bool loading = coneModel.isRefreshingFileContents;
        return Stack(
          children: <Widget>[
            if (loading) const Center(child: CircularProgressIndicator()),
            Opacity(
              opacity: loading ? 0.5 : 1.0,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    if (!kReleaseMode)
                      ListTile(
                        leading: const Icon(Icons.developer_mode),
                        title: const Text('Debug mode'),
                        subtitle: Text(coneModel.debugMode.toString()),
                        onTap: coneModel.toggleDebugMode,
                      ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.text_format,
                      ),
                      title: Text(
                        coneModel.formattedExample,
                      ),
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.attach_money),
                          title: Text(
                              ConeLocalizations.of(context).defaultCurrency),
                          subtitle: Text(coneModel.defaultCurrency),
                          onTap: () async {
                            final String defaultCurrency =
                                await _asyncDefaultCurrencyDialog(context);
                            coneModel.setDefaultCurrency(defaultCurrency);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.language),
                          title:
                              Text(ConeLocalizations.of(context).numberLocale),
                          subtitle: Text(coneModel.numberLocale),
                          onTap: () async {
                            final String result = await showSearch<String>(
                              context: context,
                              delegate: NumberLocaleSearchDelegate(),
                            );
                            if (result != null) {
                              coneModel.setNumberLocale(result);
                            }
                          },
                        ),
                        SwitchListTile(
                          secondary: const Icon(Icons.compare_arrows),
                          title: Text(
                              ConeLocalizations.of(context).currencyOnLeft),
                          value: coneModel.currencyOnLeft,
                          onChanged: (bool _) =>
                              coneModel.toggleCurrencyOnLeft(),
                        ),
                        SwitchListTile(
                          secondary: const Icon(Icons.space_bar),
                          title: Text(ConeLocalizations.of(context).spacing),
                          value: coneModel.spacing.index == 1,
                          onChanged: (bool _) => coneModel.toggleSpacing(),
                        ),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.link),
                      title: Text(ConeLocalizations.of(context).ledgerFile),
                      subtitle: Text(coneModel.ledgerFileAlias),
                      onTap: coneModel.pickLedgerFileUri,
                      trailing: LedgerFileInfoButton(),
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.sort),
                      title: Text(ConeLocalizations.of(context).reverseSort),
                      value: coneModel.reverseSort,
                      onChanged: (bool _) => coneModel.toggleSort(),
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.brightness_medium),
                      title: const Text('Brightness'),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.brightness_auto),
                          title: const Text('Auto'),
                          trailing: Radio<ConeBrightness>(
                            value: ConeBrightness.auto,
                            groupValue: coneModel.brightness,
                            onChanged: (ConeBrightness value) =>
                                coneModel.setBrightness(value),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.brightness_high),
                          title: const Text('Light'),
                          trailing: Radio<ConeBrightness>(
                            value: ConeBrightness.light,
                            groupValue: coneModel.brightness,
                            onChanged: (ConeBrightness value) =>
                                coneModel.setBrightness(value),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.brightness_low),
                          title: const Text('Dark'),
                          trailing: Radio<ConeBrightness>(
                            value: ConeBrightness.dark,
                            groupValue: coneModel.brightness,
                            onChanged: (ConeBrightness value) =>
                                coneModel.setBrightness(value),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class LedgerFileInfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConeModel coneModel = ConeModel.of(context);
    return IconButton(
      icon: const Icon(Icons.info),
      onPressed: (coneModel.ledgerFileDisplayName == null)
          ? null
          : () => showLedgerFileInfo(
                context: context,
                ledgerFileUri: coneModel.ledgerFileUri,
                ledgerFileDisplayName: coneModel.ledgerFileDisplayName,
              ),
    );
  }
}

Future<int> showLedgerFileInfo({
  BuildContext context,
  String ledgerFileUri,
  String ledgerFileDisplayName,
  bool ledgerFilePersistablePermission,
}) {
  final Map<String, String> info = <String, String>{
    'Display name': ledgerFileDisplayName,
    'Persistable permission': ledgerFilePersistablePermission.toString(),
    'Uri authority component': Uri.tryParse(ledgerFileUri).authority,
    'Uri path component': Uri.tryParse(Uri.decodeFull(ledgerFileUri)).path,
    'Uri': Uri.decodeFull(ledgerFileUri),
  };
  return showGenericInfo(context: context, info: info);
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
