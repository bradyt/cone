import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Consumer;

import 'package:cone/src/localizations.dart';
import 'package:cone/src/model.dart';
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
                    ListTile(
                      leading: const Icon(Icons.attach_money),
                      title:
                          Text(ConeLocalizations.of(context).defaultCurrency),
                      subtitle: Text(coneModel.defaultCurrency),
                      onTap: () async {
                        final String defaultCurrency =
                            await _asyncDefaultCurrencyDialog(context);
                        coneModel.setDefaultCurrency(defaultCurrency);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.compare_arrows),
                      title: Text(ConeLocalizations.of(context).currencyOnLeft),
                      subtitle: Text(coneModel.formattedExample),
                      onTap: coneModel.toggleCurrencyOnLeft,
                    ),
                    ListTile(
                      leading: const Icon(Icons.link),
                      title: Text(ConeLocalizations.of(context).ledgerFile),
                      subtitle: Text(coneModel.ledgerFileAlias),
                      onTap: coneModel.pickLedgerFileUri,
                      trailing: LedgerFileInfoButton(),
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
