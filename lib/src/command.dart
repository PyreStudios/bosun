abstract class Command {
  String command;
  String? use;
  List<String>? aliases;
  String? description;
  String? example;
  List<Command>? subcommands;

  Command(
      {required this.command,
      this.use,
      this.aliases,
      this.description,
      this.example,
      this.subcommands});

  void run(List<String> args, Map<String, dynamic> flags);
  void preRun(List<String> args, Map<String, dynamic> flags) {}
  void postRun(List<String> args, Map<String, dynamic> flags) {}

  List<String> getAllLogicalNames() {
    return [
      command,
      ...(aliases ?? []),
    ];
  }

  printHelp() {
    print('''
    $command ${use ?? ''} ${aliases?.join('|') ?? ''}

    ${description ?? ''}
    
    example:
      ${example ?? ''}
    ''');
  }
}

class BosunCommand extends Command {
  BosunCommand(String appName, {required List<Command> subcommands})
      : super(command: appName, subcommands: subcommands);

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    // Intentionally left blank
  }
}
