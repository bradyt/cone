import 'package:flutter/material.dart';

import 'package:cone/src/model.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('cone.dev'),
        actions: <Widget>[SettingsButton()],
      ),
      body: Transactions(),
      floatingActionButton: ConeModel.of(context).hideAddTransactionButton
          ? null
          : AddTransactionButton(),
    );
  }
}

class Transactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String fileContents = ConeModel.of(context).fileContents;

    String body(String fileContents) {
      if (fileContents == null) {
        return 'Please select a .txt file';
      } else if (ConeModel.of(context).debugMode) {
        return fileContents.replaceAll(' ', '·').replaceAll('\t', '» ');
      } else {
        return fileContents;
      }
    }

    final List<String> lines = body(fileContents).split('\n');

    final bool loading = ConeModel.of(context).isRefreshingFileContents;

    return Stack(
      children: <Widget>[
        if (loading) const Center(child: CircularProgressIndicator()),
        Opacity(
          opacity: loading ? 0.5 : 1.0,
          child: RefreshIndicator(
            onRefresh: () => ConeModel.of(context).refreshFileContents(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: lines.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: EdgeInsets.fromLTRB(8, (index == 0) ? 8 : 0, 8,
                    (index == lines.length - 1) ? 8 : 0),
                child: Text.rich(
                  TextSpan(
                    text: lines[index],
                  ),
                  style: const TextStyle(
                    fontFamily: 'IBMPlexMono',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        ConeModel.of(context).closeSuggestionBoxControllers();
        Navigator.pushNamed(context, '/settings');
      },
    );
  }
}

class AddTransactionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        heroTag: '''the only floating action button here \
${DateTime.now().millisecondsSinceEpoch}''',
        onPressed: () async {
          ConeModel.of(context).resetTransaction();
          final dynamic transaction =
              await Navigator.pushNamed<dynamic>(context, '/add-transaction');
          if (transaction != null) {
            Scaffold.of(context).showSnackBar(
                ConeModel.of(context).snackBar(transaction as String));
            await ConeModel.of(context).refreshFileContents();
          }
        },
        child: const Icon(Icons.add));
  }
}
