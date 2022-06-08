import 'package:bosun/bosun.dart';

class NodeHelpCmd extends Command {
  final Command context;

  NodeHelpCmd(this.context)
      : super(
            command: 'help',
            description:
                'Displays helpful information about the current project',
            subcommands: []);

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    String commands = '';
    for (var element in [...context.subcommands!]) {
      commands += '  ${element.command}\t${element.description ?? ''}\n';
    }
    print('''
${context.description}

Usage: <command|dart-file> [arguments]

Global options:
-h, --help                 Print this usage information.

Available commands:
$commands
Run "<command> help" for more information about a command.
      ''');
  }
}
