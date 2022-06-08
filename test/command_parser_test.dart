import 'package:bosun/bosun.dart';
import 'package:bosun/src/command.dart';
import 'package:bosun/src/commands.dart';
import 'package:bosun/src/did_you_mean.dart';
import 'package:test/test.dart';
import 'package:bosun/src/command_parser.dart';

class RootCmd extends Command {
  RootCmd() : super(command: 'bar');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    // TODO: implement run
  }
}

class NestedTestCommand extends Command {
  NestedTestCommand()
      : super(command: 'nesttest', subcommands: [NestedCommand()]);
  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    // TODO: implement run
  }
}

class NestedCommand extends Command {
  NestedCommand() : super(command: 'nested');
  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    // TODO: implement run
  }
}

void main() {
  group('Flag Parsing', () {
    test('Should handle basic tags', () {
      var outCmd = CommandParser.parse(
          RootCmd(), 'bar turkey -baz -qux=quux --quuz=corge'.split(' '));
      expect(outCmd.flags['baz'], isTrue);
      expect(outCmd.flags['qux'], equals('quux'));
      expect(outCmd.flags['quuz'], equals('corge'));
      expect(outCmd.command.command, equals('bar'));
      print(outCmd.args);
      expect(outCmd.args.length, equals(2));
      expect(outCmd.args[0], equals('bar'));
      expect(outCmd.args[1], equals('turkey'));
    });
  });

  group('Nested Commands but still being able to call the root command', () {
    test('Should call root command when only it is called', () {
      // just the first command by itself
      var outCmd = CommandParser.parse(
          BosunCommand('test', subcommands: [NestedTestCommand()]),
          'nesttest'.split(' '));
      expect(outCmd.command is NestedTestCommand, isTrue);
    });

    test('should process the first command with an argument', () {
      // the first command with an argument "junk"
      var outCmd = CommandParser.parse(
          BosunCommand('test', subcommands: [NestedTestCommand()]),
          'nesttest junk'.split(' '));
      print(outCmd);

      expect(outCmd.command is NestedTestCommand, isTrue);
      expect(outCmd.args.contains('junk'), isTrue);
    });

    test('should process the first command with many arguments', () {
      // the first command with an argument "junk"
      var outCmd = CommandParser.parse(
          BosunCommand('test', subcommands: [NestedTestCommand()]),
          'nesttest junk junk junk junk'.split(' '));
      print(outCmd);

      expect(outCmd.command is NestedTestCommand, isTrue);
      expect(outCmd.args.contains('junk'), isTrue);
    });

    test('Should process to the subcommand', () {
      // the first command and the second command
      var outCmd = CommandParser.parse(
          BosunCommand('test', subcommands: [NestedTestCommand()]),
          'nesttest nested'.split(' '));
      expect(outCmd.command is NestedTestCommand, isFalse);
      expect(outCmd.command is NestedCommand, isTrue);
    });
  });

  group('help command', () {
    test(
        'Should show help command when processing a string and the command tree is empty',
        () {
      var outCmd = CommandParser.parse(BosunCommand('test', subcommands: []),
          'run app do something'.split(' '));
      expect(outCmd.command is NodeHelpCmd, isTrue);
    });
  });

  group('did-you-mean command', () {
    test('not passing a legitimate command should prompt did you mean', () {
      var outCmd = CommandParser.parse(
          BosunCommand('test', subcommands: [NestedTestCommand()]),
          'nester'.split(' '));
      expect(outCmd.command is DidYouMeanCommand, isTrue);
    });

    test('not passing a legitimate command and junk should prompt did you mean',
        () {
      var outCmd = CommandParser.parse(
          BosunCommand('test', subcommands: [NestedTestCommand()]),
          'nester oni pizza pls pass thank you'.split(' '));
      expect(outCmd.command is DidYouMeanCommand, isTrue);
    });
  });
}
