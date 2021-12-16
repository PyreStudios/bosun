import 'package:captain/captain.dart';
import 'package:captain/src/command.dart';
import 'package:test/test.dart';
import 'package:captain/src/command_parser.dart';

class RootCmd extends Command {
  RootCmd() : super(command: 'bar');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    // TODO: implement run
  }
}

void main() {
  group('Flag Parsing', () {
    test('Should handle basic tags', () {
      var outCmd = CommandParser.parse(
          RootCmd(), 'foo bar turkey -baz -qux=quux --quuz=corge'.split(' '));
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
}
