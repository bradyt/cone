import 'package:flutter/material.dart' hide Actions;
import 'package:flutter_redux/flutter_redux.dart' show StoreBuilder;
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
        title: Text(ConeLocalizations.of(context)!.settings!),
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
                      child: Text(choice.title!),
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

  final String? title;
  final IconData? icon;
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
              title: Text(ConeLocalizations.of(context)!.ledgerFile!),
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
