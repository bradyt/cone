import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'package:cone_lib/cone_lib.dart';

import 'package:cone_cli/src/version.dart';

void main(List<String> arguments) {
  final CommandRunner<dynamic> runner = ConeCommandRunner();

  runner.run(arguments).catchError((Error error) {
    if (error is! UsageException) {
      throw error;
    }
    print(error);
    exit(64); // Exit code 64 indicates a usage error.
  });
}

class ConeCommandRunner extends CommandRunner<dynamic> {
  ConeCommandRunner() : super('cone', 'Prototype cli for flutter functions.') {
    argParser
      ..addOption(
        'file',
        abbr: 'f',
        help: 'Specify the file for input.',
        valueHelp: 'FILE',
      )
      ..addFlag(
        'version',
        abbr: 'v',
        help: 'Show version.',
        negatable: false,
      );
    addCommand(AccountsCommand());
    addCommand(PayeesCommand());
    // addCommand(TestingCommand());
  }

  @override
  String get invocation => '$executableName [arguments] <command>';

  @override
  Future<void> run(Iterable<String> args) async {
    final ArgResults results = super.parse(args);
    if (results['version'] != null) {
      print('cone $packageVersion');
    } else {
      await super.run(args);
    }
  }
}

String getFileContentsForCommands(ArgResults res) {
  // ignore: avoid_as
  final String filename =
      // ignore: avoid_as
      res['file'] as String ?? Platform.environment['CONE_LEDGER_FILE'];
  if (filename == null) {
    print('Error: No journal file was specified'
        ' (please use -f or CONE_LEDGER_FILE)');
    exit(64);
  }
  return File(filename).readAsStringSync();
}

class AccountsCommand extends Command<dynamic> {
  @override
  final String name = 'accounts';

  @override
  final String description = 'List accounts.';

  @override
  final List<String> aliases = <String>['a'];

  @override
  void run() {
    final String fileContents = getFileContentsForCommands(globalResults);
    // ignore: prefer_foreach
    for (final String account in getAccounts(fileContents)) {
      print(account);
    }
  }
}

class PayeesCommand extends Command<dynamic> {
  @override
  final String name = 'payees';

  @override
  final String description = 'List payees.';

  @override
  final List<String> aliases = <String>['p'];

  @override
  void run() {
    final String fileContents = getFileContentsForCommands(globalResults);
    // ignore: prefer_foreach
    for (final String payee in getPayees(fileContents)) {
      print(payee);
    }
  }
}

// class TestingCommand extends Command {
//   @override
//   final String name = 'testing';

//   @override
//   final String description = 'Debugging';

//   @override
//   final List<String> aliases = ['t'];

//   @override
//   void run() {
//     String fileContents = getFileContentsForCommands(globalResults);
//     for (var it in parser.parse(fileContents).value) {
//       print('-');
//       print('Line ${it.line}');
//       print(it.input);
//     }
//     for (String chunk in getChunks(fileContents)) {
//       print('-' * 80);
//       print(chunk);
//     }
//   }
// }
