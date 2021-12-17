/// Support for doing something awesome.
///
/// More dartdocs go here.
library bosun;

import 'package:bosun/src/command.dart';
import 'package:bosun/src/command_executor.dart';
import 'package:bosun/src/command_parser.dart';

export 'src/command.dart';

void execute(BosunCommand command, List<String> args) {
  // We dont really care what the app's name is
  final argsWithoutRoot = args.sublist(1);
  CommandExecutor.execute(CommandParser.parse(command, argsWithoutRoot));
}
