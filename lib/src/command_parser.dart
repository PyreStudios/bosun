import 'package:bosun/src/command_executor.dart';
import 'package:bosun/src/command.dart';
import 'package:bosun/src/did_you_mean.dart';
import 'package:bosun/src/commands.dart';

class CommandParser {
  static ProcessableCommand parse(Command command, List<String> args) {
    Map<String, dynamic> flags = _getFlags(args);
    var subcommands =
        args.sublist(0).where((element) => !element.startsWith('-'));
    var finalCmd = command;
    var arguments = <String>[];
    var index = 0;

    Command? previousCommand = command;
    for (var cmd in subcommands) {
      // If no more subcommands then the rest must be args
      // alternatively, if the previous commands are not the same AND
      // the subcommands exist but with no matches, those are args.
      if (finalCmd.subcommands == null ||
          finalCmd.subcommands!.isEmpty ||
          (!finalCmd.subcommands!
                  .map((e) => e.getAllLogicalNames())
                  .expand((e) => e)
                  .contains(cmd) &&
              previousCommand != finalCmd)) {
        arguments.addAll(subcommands.toList().sublist(index));
        break;
      }

      index++;

      previousCommand = finalCmd;

      finalCmd = finalCmd.subcommands!.firstWhere(
          (element) => element.getAllLogicalNames().contains(cmd),
          orElse: () => finalCmd == command
              ? _exceptionHandler(command, finalCmd, cmd)
              : finalCmd);
    }

    return ProcessableCommand(finalCmd, flags, arguments);
  }

  static Command _exceptionHandler(
      Command root, Command context, String subcommand) {
    var bosunCommand = BosunCmd(root, context);

    if (context.subcommands != null && context.subcommands!.isNotEmpty) {
      return DidYouMeanCommand(input: subcommand, commandToSearch: root);
    }

    // TODO: I believe the auto-generated "help" command is unreachable
    // subcommands are null or empty
    return bosunCommand.subcommands!.firstWhere(
        (element) => element.getAllLogicalNames().contains(subcommand),
        orElse: () => HelpCmd(root, context));
  }

  static Map<String, dynamic> _getFlags(List<String> args) {
    var flags = <String, dynamic>{};

    args = args.where((arg) => arg.startsWith('-')).toList();
    for (var element in args) {
      if (element.startsWith('--')) {
        var key = element.substring(2);
        dynamic value = true;
        if (key.contains('=')) {
          var split = key.split('=');
          key = split[0].replaceAll('-', '');
          value = split[1];
        }
        flags[key] = value;
      } else if (element.startsWith('-')) {
        var key = element.substring(1);
        dynamic value = true;
        if (key.contains('=')) {
          var split = key.split('=');
          key = split[0].replaceAll('-', '');
          value = split[1];
        }
        flags[key] = value;
      }
    }

    return flags;
  }
}
