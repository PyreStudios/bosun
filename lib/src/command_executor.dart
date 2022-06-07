import 'command.dart';

/// The CommandExecutor is responsible for executing commands.
class CommandExecutor {
  /// Execute a given ProcessableCommand.
  /// Will run printHelp on the command if the help flag is provided.
  static void execute(ProcessableCommand pCmd) {
    if (pCmd.flags['help'] == true) {
      pCmd.command.printHelp();
    } else {
      pCmd.command.run(pCmd.args, pCmd.flags);
    }
  }
}

class ProcessableCommand {
  Command command;
  Map<String, dynamic> flags;
  List<String> args;

  ProcessableCommand(this.command, this.flags, this.args);

  @override
  String toString() {
    return '''
  Command:
  ${command.toString()}

  Flags:
  ${flags.toString()}

  Args:
  ${args.toString()}
  ''';
  }
}
