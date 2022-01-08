import 'dart:math';

import 'package:bosun/bosun.dart';
import 'package:tree_iterator/tree_iterator.dart';

class _WordSimilarity {
  final String text;
  final double similarity;

  const _WordSimilarity(this.text, this.similarity);
}

String didYouMean(String text, BosunCommand command) {
  var suggestions = [];
  traverseTree(command, (Command cmd) => cmd.subcommands ?? <Command>[],
      (Command node) {
    suggestions.addAll(node.getAllLogicalNames());
    return true;
  });

  print(suggestions);
  var similarities =
      suggestions.map((e) => _WordSimilarity(e, similarity(text, e))).toList();
  similarities.sort((a, b) => b.similarity.compareTo(a.similarity));
  return similarities.first.text;
}

int levenshtein(String a, String b) {
  a = a.toUpperCase();
  b = b.toUpperCase();
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

double similarity(String a, String b) {
  double _similarity;
  a = a.toUpperCase();
  b = b.toUpperCase();
  _similarity = 1 - levenshtein(a, b) / (max(a.length, b.length));
  return (_similarity);
}
