import 'package:bosun/bosun.dart';

class HelpCmd extends Command {
  final Command root;
  final Command context;

  HelpCmd(this.root, this.context)
      : super(
            command: 'help',
            description: 'Displays helpful information about the current project',
            subcommands: []);

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    String commands = '';
    for (var element in [...context.subcommands!, ...BosunCmd(root, context).subcommands!]) {
      commands += '  ${element.command}\t${element.description ?? ''}\n';
    }
    print('''
${root.description}

Usage: <command|dart-file> [arguments]

Global options:
-h, --help                 Print this usage information.

Available commands:
$commands
Run "<command|dart-file> help" for more information about a command.
      ''');
  }
}

class BosunCmd extends Command {
  final Command root;
  final Command context;

  BosunCmd(this.root, this.context)
      : super(
            command: 'bosun',
            description: 'Run a command in a shell',
            subcommands: [HelpCmd(root, context)]);

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    // Intentionally left blank
  }
}