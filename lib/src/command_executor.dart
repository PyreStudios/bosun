import 'command.dart';

class CommandExecutor {
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
}
