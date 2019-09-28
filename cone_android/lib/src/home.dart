import 'package:flutter/material.dart';

import 'package:cone/src/model.dart';
import 'package:cone/src/state_management/settings_model.dart'
    show ConeBrightness;

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
                : coneModel.chunks)
            ?.where((String chunk) => chunk.startsWith(RegExp(r'[0-9]')))
            ?.toList() ??
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
                    child: FormattedChunk(
                      chunk: chunks[index],
                      dark: coneModel.brightness == ConeBrightness.dark,
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

class FormattedChunk extends StatelessWidget {
  const FormattedChunk({@required this.chunk, @required this.dark});

  // Color choices taken from
  // https://github.com/emacs-mirror/emacs/blob/emacs-26.3/lisp/font-lock.el
  // comment: firebrick/chocolate1
  // builtin: dark slate blue/ LightSteelBlue
  // constant: dark cyan/ Aquamarine
  // function: Blue1/ LightSky
  // keyword: Purple/Cyan1
  // string: VioletRed4/LightSalmon
  // type: ForestGreen/PaleGreen
  // warning: Red1/Pink

  // Mapping transaction elements to Emacs colors follows that of ledger-mode.el

  final String chunk;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    Widget formattedChunk;
    final Color colorNewline =
        dark ? const Color(0xffa9a9a9) : const Color(0xffd3d3d3);
    final Color colorBuiltin =
        dark ? const Color(0xffb0c4de) : const Color(0xff483d8b);
    final Color colorComment =
        dark ? const Color(0xffff7f24) : const Color(0xffb22222);
    if (RegExp(r'[0-9]').hasMatch(chunk[0])) {
      final Color colorConstant =
          dark ? const Color(0xff7fffd4) : const Color(0xff008b8b);
      // final Color colorString =
      //     dark ? const Color(0xffffa07a) : const Color(0xff8b2252);
      final Color colorKeyword =
          dark ? const Color(0xff00ffff) : const Color(0xff800080);
      final Color colorWarning =
          dark ? const Color(0xffffc0cb) : const Color(0xffff6a6a);
      final List<String> lines = chunk.split('\n');
      final String date = lines[0].split(' ')[0] + ' ';
      final int splitAt = lines[0].indexOf(' ');
      final String description = lines[0].substring(splitAt).trim();
      final Widget column = Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FormatString(
                text: date,
                color: colorKeyword,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      FormatString(
                        text: description,
                        color: colorWarning,
                      ),
                      FormatString(
                        text: '\$',
                        color: colorNewline,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          for (String line in lines.sublist(1))
            if (!line.startsWith(RegExp(r'[ \t]*;')))
              Builder(
                builder: (BuildContext _) {
                  final String account = '  ' + line.trim().split('  ')[0];
                  final int splitAt2 = line.trim().indexOf('  ');
                  String amount;
                  if (splitAt2 != -1) {
                    amount = '  ' + line.trim().substring(splitAt2).trim();
                  }
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FormatString(
                            text: account,
                            color: null,
                          ),
                        ),
                      ),
                      if (splitAt2 != -1)
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: FormatString(
                            text: amount,
                            color: colorConstant,
                          ),
                        ),
                    ],
                  );
                },
              ) // else Text(line)
          ,
        ],
      );
      formattedChunk = column;
    } else if (RegExp(r'[A-Za-z]').hasMatch(chunk[0])) {
      formattedChunk = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Builder(
          builder: (BuildContext _) {
            final List<String> lines = chunk.split('\n');
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (String line in lines)
                  Row(
                    children: <Widget>[
                      FormatString(
                        text: line,
                        color: colorBuiltin,
                      ),
                      FormatString(
                        text: '\$',
                        color: colorNewline,
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      );
    } else {
      formattedChunk = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Builder(
          builder: (BuildContext _) {
            final List<String> lines = chunk.split('\n');
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (String line in lines)
                  Row(
                    children: <Widget>[
                      FormatString(
                        text: line,
                        color: colorComment,
                      ),
                      FormatString(
                        text: '\$',
                        color: colorNewline,
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      );
    }
    return formattedChunk;
  }
}

class FormatString extends StatelessWidget {
  const FormatString({@required this.text, @required this.color});

  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
      ),
      style: TextStyle(
        fontFamily: 'IBMPlexMono',
        color: color,
      ),
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
