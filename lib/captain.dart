/// Support for doing something awesome.
///
/// More dartdocs go here.
library captain;

import 'package:captain/src/command.dart';
import 'package:captain/src/command_executor.dart';
import 'package:captain/src/command_parser.dart';

export 'src/command.dart';

void mount(CaptainCommand command, List<String> args) {
  CommandExecutor.execute(CommandParser.parse(command, args));
}

// TODO: Export any libraries intended for clients of this package.
