/// Support for doing something awesome.
///
/// More dartdocs go here.
library bosun;

import 'package:bosun/src/command.dart';
import 'package:bosun/src/command_executor.dart';
import 'package:bosun/src/command_parser.dart';

export 'src/command.dart';

void execute(BosunCommand command, List<String> args) =>
    CommandExecutor.execute(CommandParser.parse(command, args));
