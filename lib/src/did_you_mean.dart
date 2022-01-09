import 'dart:math';

import 'package:bosun/bosun.dart';
import 'package:tree_iterator/tree_iterator.dart';

class _WordSimilarity {
  final String text;
  final double similarity;

  const _WordSimilarity(this.text, this.similarity);
}

class DidYouMeanCommand extends Command {
  String input;
  Command commandToSearch;

  DidYouMeanCommand({required this.input, required this.commandToSearch})
      : super(command: 'did-you-mean');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    var suggested = _didYouMean(input, commandToSearch);
    print(''''
    No command found that matches $input. Did you mean:
    $suggested?
''');
  }
}

/// didYouMean is a function that takes a BosunCommand and a string and returns
/// the word in the command tree that is most similar to the string.
/// We factor in all logical names for any given command so aliases and shorthands
/// are considered, too!
String _didYouMean(String text, Command command) {
  var suggestions = [];
  traverseTree(command, (Command cmd) => cmd.subcommands ?? <Command>[],
      (Command node) {
    suggestions.addAll(node.getAllLogicalNames());
    return true;
  });

  var similarities = suggestions
      .map((e) => _WordSimilarity(e, _calcSimilarity(text, e)))
      .toList();
  similarities.sort((a, b) => b.similarity.compareTo(a.similarity));
  return similarities.first.text;
}

/// Find the levenshtein distance between two strings.
/// https://en.wikipedia.org/wiki/Levenshtein_distance
int _distanceBetweenStrings(String a, String b) {
  int i, j, cost, min1, min2, min3;
  int levenshtein;
  List<List<int>> d =
      List.generate(a.length + 1, (int i) => List.filled(b.length + 1, 0));
  if (a.isEmpty) {
    levenshtein = b.length;
    return (levenshtein);
  }
  if (b.isEmpty) {
    levenshtein = a.length;
    return (levenshtein);
  }
  for (i = 0; i <= a.length; i++) {
    d[i][0] = i;
  }
  for (j = 0; j <= b.length; j++) {
    d[0][j] = j;
  }
  for (i = 1; i <= a.length; i++) {
    for (j = 1; j <= b.length; j++) {
      if (a[i - 1] == b[j - 1]) {
        cost = 0;
      } else {
        cost = 1;
      }
      min1 = (d[i - 1][j] + 1);
      min2 = (d[i][j - 1] + 1);
      min3 = (d[i - 1][j - 1] + cost);
      d[i][j] = min(min1, min(min2, min3));
    }
  }
  levenshtein = d[a.length][b.length];
  return (levenshtein);
}

/// helper function to prep data for levenshtein distance calculation
double _calcSimilarity(String a, String b) {
  double _similarity;
  a = a.toUpperCase();
  b = b.toUpperCase();
  _similarity = 1 - _distanceBetweenStrings(a, b) / (max(a.length, b.length));
  return (_similarity);
}
