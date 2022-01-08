import 'package:bosun/bosun.dart';
import 'package:bosun/src/did_you_mean.dart';
import 'package:test/test.dart';

class AppCmd extends Command {
  AppCmd()
      : super(
            command: 'app',
            description: 'run as an app shell',
            supportedFlags: {'--app': 'The app that you want to use'});

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    print("IN APP");
    print(args);
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
    print("IN RUN");
  }
}

void main() {
  group('DidYouMean example', () {
    test('Suggests similar text-aliases', () {
      var args = 'run app --help '.split(' ');
      var result =
          didYouMean('aft', BosunCommand('donker', subcommands: [RunCmd()]));

      expect(result, equals('app'));
    });
  });
}
