import 'package:ege_solver/logic/logical_expression_parser.dart';
import 'package:trotter/trotter.dart';

class EgeTask2Solver {
  static const _variableNames = ['x', 'y', 'z', 'w'];

  final List<List<bool?>> tableFragment;
  final LogicalExpressionParser parser;
  final int numberOfVariables;

  final List<List<bool>> fullTable = [];

  EgeTask2Solver(this.parser, this.tableFragment)
      : numberOfVariables = tableFragment[0].length - 1 {
    for (bool x in [false, true]) {
      for (bool y in [false, true]) {
        if (numberOfVariables == 2) {
          fullTable.add([
            x,
            y,
            parser.evaluate([x, y])
          ]);
          continue;
        }

        for (bool z in [false, true]) {
          if (numberOfVariables == 3) {
            fullTable.add([
              x,
              y,
              z,
              parser.evaluate([x, y, z])
            ]);
            continue;
          }

          for (bool w in [false, true]) {
            fullTable.add([
              x,
              y,
              z,
              w,
              parser.evaluate([x, y, z, w])
            ]);
          }
        }
      }
    }
  }

  bool _matchRows(List<bool?> matching, List<bool> baseline) =>
      matching.indexed.every((e) => (e.$2 == null) || (e.$2 == baseline[e.$1]));

  (String, Map<List<bool?>, List<bool>>)? solve() {
    final columnPermutations = Permutations(
        numberOfVariables, List.generate(numberOfVariables, (idx) => idx));

    final fragmentPermutations =
        Permutations(tableFragment.length, tableFragment);

    List<int>? bestPermutation;
    Map<List<bool?>, List<bool>> bestMatches = {};

    for (final fragmentPermutation in fragmentPermutations()) {
      for (final columnPermutation in columnPermutations()) {
        final List<List<bool?>> permutedTableFragment = [
          for (final row in fragmentPermutation)
            [for (final i in columnPermutation) row[i]] + [row.last]
        ];

        final Map<List<bool?>, List<bool>> matches = {};

        for (final fragmentRow in permutedTableFragment) {
          for (final fullTableRow in fullTable) {
            if (_matchRows(fragmentRow, fullTableRow) &&
                !matches.values.contains(fullTableRow)) {
              matches[fragmentRow] = fullTableRow;
              break;
            }
          }
        }

        if (bestMatches.values.length < matches.values.length) {
          bestMatches = matches;
          bestPermutation = columnPermutation;
        }
      }
    }

    if (bestPermutation == null || bestPermutation.isEmpty) return null;

    if (bestMatches.values.length != tableFragment.length) return null;

    return (
      _variableNames.indexed.fold("", (prev, e) {
        final letterIndex = bestPermutation!.indexOf(e.$1);
        if (letterIndex == -1) return prev;
        return prev + _variableNames[letterIndex];
      }),
      bestMatches,
    );
  }
}
