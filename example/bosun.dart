import 'package:bosun/bosun.dart';

class AppCmd extends Command {
  AppCmd() : super(command: 'app', description: 'run as an app shell');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    print("in the app command callback");
  }
}

class RunCmd extends Command {
  RunCmd()
      : super(
            command: 'run',
            description: 'Run a command in a shell',
            subcommands: [AppCmd()]);

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    print("in the run command callback");
  }
}

void main(List<String> args) {
  execute(BosunCommand('donker', description: 'The donker CLI tool', subcommands: [RunCmd()]), args);
}
