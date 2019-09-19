import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uri_picker/uri_picker.dart';

import 'package:cone/src/localizations.dart';
import 'package:cone/src/settings_model.dart';

const MethodChannel channel = MethodChannel('cone.tangential.info/uri');

Map<String, String> providerMap = <String, String>{
  'com.android.providers.downloads.documents': 'Downloads',
  'com.box.android.documents': 'Box.com',
  'com.google.android.apps.docs.storage': 'Google Drive',
  'com.microsoft.skydrive.content.storageaccessprovider': 'OneDrive',
  'org.nextcloud.documents': 'Nextcloud',
};

String generateAlias(String uri, String displayName) {
  final String authority = Uri.parse(uri).authority;
  final String path = Uri.parse(Uri.decodeFull(uri)).path;
  if (authority == 'com.android.externalstorage.documents') {
    if (path.startsWith('/document/home:')) {
      return '/Documents/${path.split(':')[1]}';
    } else if (path.startsWith('/document/primary:')) {
      return '/${path.split(':')[1]}';
    }
  } else if (providerMap.keys.contains(authority)) {
    return '${providerMap[authority]} - $displayName';
  }
  return '$displayName\n$authority';
}

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
                if (!kReleaseMode)
                  ListTile(
                    leading: const Icon(Icons.developer_mode),
                    title: const Text('Debug mode'),
                    subtitle: Text(settings.debugMode.toString()),
                    onTap: () async {
                      settings.debugMode = !settings.debugMode;
                    },
                  ),
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
                ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text('Ledger file'),
                  subtitle: Text((settings.ledgerFileDisplayName == null)
                      ? null.toString()
                      : generateAlias(settings.ledgerFileUri,
                          settings.ledgerFileDisplayName)),
                  onTap: () async {
                    final String ledgerFileUri = await UriPicker.pickUri();
                    final String ledgerFileDisplayName =
                        await UriPicker.getDisplayName(ledgerFileUri);
                    try {
                      if (ledgerFileUri != null) {
                        await UriPicker.isUriOpenable(ledgerFileUri);
                        await UriPicker.takePersistablePermission(
                            ledgerFileUri);
                        settings
                          ..ledgerFileUri = ledgerFileUri
                          ..ledgerFileDisplayName = ledgerFileDisplayName;
                      }
                    } on PlatformException catch (e) {
                      await showDialog<int>(
                        context: context,
                        builder: (BuildContext context) {
                          final RegExp pascalWords =
                              RegExp(r'(?:[A-Z]+|^)[a-z]*');
                          List<String> getPascalWords(String input) =>
                              pascalWords
                                  .allMatches(input)
                                  .map((Match m) => m[0])
                                  .toList();
                          final List<String> keyWords =
                              getPascalWords(e.code.split('.').last)
                                ..removeLast();
                          final String sentence = keyWords.join(' ');
                          final String title =
                              (sentence == null || sentence.isEmpty)
                                  ? null
                                  : sentence[0].toUpperCase() +
                                      sentence.substring(1).toLowerCase();
                          return AlertDialog(
                            title: (title != null) ? Text(title) : null,
                            content: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: const Text('Code'),
                                    subtitle: Text(e.code),
                                  ),
                                  ListTile(
                                    title: const Text('Message'),
                                    subtitle: Text(e.message),
                                  ),
                                  ListTile(
                                    title: const Text('Display name'),
                                    subtitle: Text(ledgerFileDisplayName),
                                  ),
                                  ListTile(
                                    title:
                                        const Text('Uri authority component'),
                                    subtitle: Text(
                                        Uri.tryParse(ledgerFileUri).authority),
                                  ),
                                  ListTile(
                                    title: const Text('Uri path component'),
                                    subtitle: Text(Uri.tryParse(
                                            Uri.decodeFull(ledgerFileUri))
                                        .path),
                                  ),
                                  ListTile(
                                    title: const Text('Uri'),
                                    subtitle:
                                        Text(Uri.decodeFull(ledgerFileUri)),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: (settings.ledgerFileDisplayName == null)
                        ? null
                        : () {
                            showDialog<int>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          title: const Text('Display name'),
                                          subtitle: Text(
                                              settings.ledgerFileDisplayName),
                                        ),
                                        ListTile(
                                          title: const Text(
                                              'Uri authority component'),
                                          subtitle: Text(Uri.tryParse(
                                                  settings.ledgerFileUri)
                                              .authority),
                                        ),
                                        ListTile(
                                          title:
                                              const Text('Uri path component'),
                                          subtitle: Text(Uri.tryParse(
                                                  Uri.decodeFull(
                                                      settings.ledgerFileUri))
                                              .path),
                                        ),
                                        ListTile(
                                          title: const Text('Uri'),
                                          subtitle: Text(Uri.decodeFull(
                                              settings.ledgerFileUri)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    RaisedButton(
                                      child: const Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
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
