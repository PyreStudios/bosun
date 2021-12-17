import 'package:bosun/src/command_executor.dart';
import 'package:bosun/src/command.dart';

class CommandParser {
  static ProcessableCommand parse(Command command, List<String> args) {
    Map<String, dynamic> flags = _getFlags(args);
    var subcommands =
        args.sublist(0).where((element) => !element.startsWith('-'));
    var finalCmd = command;
    var arguments = <String>[];
    var index = 0;
    for (var cmd in subcommands) {
      // If no more subcommands then the rest must be args
      if (finalCmd.subcommands == null) {
        arguments.addAll(subcommands.toList().sublist(index));
        break;
      }

      index++;

      finalCmd = finalCmd.subcommands!
          .firstWhere((element) => element.getAllLogicalNames().contains(cmd));
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
