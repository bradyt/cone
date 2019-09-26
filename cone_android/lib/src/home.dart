import 'package:flutter/material.dart';

import 'package:cone/src/model.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('cone'),
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
    final ConeModel coneModel = ConeModel.of(context);

    final List<String> chunks = ((coneModel.reverseSort)
            ? coneModel.chunks?.reversed?.toList()
            : coneModel.chunks) ??
        <String>[];

    final bool loading = coneModel.isRefreshingFileContents;

    return Stack(
      children: <Widget>[
        if (loading) const Center(child: CircularProgressIndicator()),
        Opacity(
          opacity: loading ? 0.5 : 1.0,
          child: RefreshIndicator(
            onRefresh: coneModel.refreshFileContents,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: chunks.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: EdgeInsets.fromLTRB(4, (index == 0) ? 8 : 0, 4,
                    (index == chunks.length - 1) ? 8 : 0),
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text.rich(
                        TextSpan(
                          text: chunks[index].replaceAll('\n', '⏎\n') + '⏎',
                        ),
                        style: TextStyle(
                          fontFamily: 'IBMPlexMono',
                          color: (RegExp(r'[A-Za-z[0-9]')
                                  .hasMatch(chunks[index][0]))
                              ? null
                              : ((MediaQuery.of(context).platformBrightness ==
                                      Brightness.dark)
                                  ? const Color(0xffff7f24)
                                  : const Color(0xffb22222)),
                        ),
                      ),
                    ),
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
