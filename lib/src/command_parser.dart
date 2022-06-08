import 'package:bosun/src/command_executor.dart';
import 'package:bosun/src/command.dart';
import 'package:bosun/src/did_you_mean.dart';
import 'package:bosun/src/commands.dart';

/// CommandParser is responsible for parsing command line arguments and a command tree.
class CommandParser {
  /// Parse command line Arguments and a command tree and return a ProcessableCommand.
  static ProcessableCommand parse(Command rootCommand, List<String> args) {
    Map<String, dynamic> flags = _getFlags(args);
    final subcommands =
        args.sublist(0).where((element) => !element.startsWith('-'));
    var finalCmd = rootCommand;
    final arguments = <String>[];
    var index = 0;

    if (subcommands.isNotEmpty &&
        rootCommand.subcommands != null &&
        rootCommand.subcommands!.isEmpty) {
      return ProcessableCommand(NodeHelpCmd(rootCommand), flags, arguments);
    }

    Command? previousCommand = rootCommand;
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

      // increment the current index to keep track of where we should sublist the arguments
      index++;
      // store this iteration of hte final command as the previous command
      previousCommand = finalCmd;

      // set finalCmd equal to the next command in the list, defaulting to one of our exception handlers
      // in case we dont find a match.
      finalCmd = finalCmd.subcommands!.firstWhere(
          (element) => element.getAllLogicalNames().contains(cmd),
          orElse: () => finalCmd == rootCommand
              ? DidYouMeanCommand(input: cmd, commandToSearch: rootCommand)
              : finalCmd);
    }

    return ProcessableCommand(finalCmd, flags, arguments);
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
