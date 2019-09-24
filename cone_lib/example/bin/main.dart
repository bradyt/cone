import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'package:cone_lib/cone_lib.dart';

import 'package:cone_cli/src/version.dart';

void main(List<String> arguments) {
  var runner = ConeCommandRunner();

  runner.run(arguments).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64); // Exit code 64 indicates a usage error.
  });
}

class ConeCommandRunner extends CommandRunner {
  ConeCommandRunner() : super('cone', 'Prototype cli for flutter functions.') {
    argParser.addOption(
      'file',
      abbr: 'f',
      help: 'Specify the file for input.',
      valueHelp: 'FILE',
    );
    argParser.addFlag(
      'version',
      abbr: 'v',
      help: 'Show version.',
      negatable: false,
    );
    addCommand(AccountsCommand());
    addCommand(PayeesCommand());
  }

  String get invocation => '$executableName [arguments] <command>';

  run(Iterable<String> args) async {
    ArgResults results = super.parse(args);
    if (results['version']) {
      print('cone $packageVersion');
    } else {
      await super.run(args);
    }
  }
}

String getFileContentsForCommands(res) {
  String filename = res['file'] ?? Platform.environment['CONE_LEDGER_FILE'];
  if (filename == null) {
    print(
        'Error: No journal file was specified (please use -f or CONE_LEDGER_FILE)');
    exit(64);
  }
  return File(filename).readAsStringSync();
}

class AccountsCommand extends Command {
  final name = 'accounts';
  final description = 'List accounts.';
  final List<String> aliases = ['a'];
  void run() {
    String fileContents = getFileContentsForCommands(globalResults);
    for (String account in accounts(fileContents)) {
      print(account);
    }
  }
}

class PayeesCommand extends Command {
  final name = 'payees';
  final description = 'List payees.';
  final List<String> aliases = ['p'];
  void run() {
    String fileContents = getFileContentsForCommands(globalResults);
    for (String payee in payees(fileContents)) {
      print(payee);
    }
  }
}
