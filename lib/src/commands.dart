import 'package:bosun/bosun.dart';

class HelpCmd extends Command {
  final Command context;

  HelpCmd(this.context)
      : super(
            command: 'help',
            description: 'Displays helpful information about the current project',
            subcommands: []);

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    String commands = '';
    for (var element in [...context.subcommands!, ...BosunCmd(context).subcommands!]) {
      commands += '  ${element.command}\t${element.description ?? ''}\n';
    }
    print('''
A command-line utility for Dart CLI development.

Usage: <command|dart-file> [arguments]

Global options:
-h, --help                 Print this usage information.

Available commands:
$commands
Run "<command|dart-file> help" for more information about a command.
See https://github.com/PyreStudios/bosun for detailed documentation.
      ''');
  }
}

class BosunCmd extends Command {
  final Command context;

  BosunCmd(this.context)
      : super(
            command: 'bosun',
            description: 'Run a command in a shell',
            subcommands: [HelpCmd(context)]);

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    // Intentionally left blank
  }
}