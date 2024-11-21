// * ((x ∧ y) ∨ (y ∧ z)) ≡ ((x → w) ∧ (w → z))

import 'package:expressions/expressions.dart';

// extension AdvancedOperators on bool {
//   operator <=(bool other) {
//     if (!other) return true;
//     if (this && other) return true;
//     return false;
//   }
// }

class MyExpressionEvaluator extends ExpressionEvaluator {
  @override
  evalBinaryExpression(
      BinaryExpression expression, Map<String, dynamic> context) {
    var left = eval(expression.left, context);
    right() => eval(expression.right, context);

    if (expression.operator == '<=') {
      return !left || (left && right());
    }

    return super.evalBinaryExpression(expression, context);
  }

  const MyExpressionEvaluator({super.memberAccessors = const []});
}

class LogicalExpressionParser {
  static const _variableNames = ['x', 'y', 'z', 'w'];

  static const _operatorMapping = {
    '¬': '!',
    'not': '!',
    '∧': '&&',
    'and': '&&',
    '∨': '||',
    'or': '||',
    '≡': '==',
    '→': '<=',
    '->': '<='
  };

  final String statement;
  final int numberOfVariables;

  late String _normalizedStatement;
  late final Expression _expression;
  final evaluator = const MyExpressionEvaluator();

  static String normalizeStatement(String statement) {
    String normalizedStatement = statement;

    for (final e in _operatorMapping.entries) {
      normalizedStatement = normalizedStatement.replaceAll(e.key, e.value);
    }

    normalizedStatement = normalizedStatement.replaceAll(' ', '');

    return normalizedStatement;
  }

  static bool validateStatement(String statement) {
    statement = normalizeStatement(statement);

    final expr = Expression.tryParse(statement);

    if (expr == null) return false;

    final context = {
      'x': false,
      'y': false,
      'z': false,
      'w': false,
    };

    const evaluator = MyExpressionEvaluator();

    try {
      evaluator.eval(expr, context);
      return true;
    } on NoSuchMethodError {
      return false;
    }
  }

  LogicalExpressionParser(this.statement, {required this.numberOfVariables}) {
    if (numberOfVariables < 2 || numberOfVariables > 4) {
      throw RangeError.range(numberOfVariables, 2, 4);
    }

    _normalizedStatement = normalizeStatement(statement);

    if (!validateStatement(_normalizedStatement)) {
      throw const FormatException("Invalid statement");
    }

    _expression = Expression.parse(_normalizedStatement);
  }

  bool evaluate(List<bool> arguments) {
    if (arguments.length != numberOfVariables) {
      throw Exception("Argument count does not match statement");
    }

    final context = {
      for (int i = 0; i < numberOfVariables; ++i)
        _variableNames[i]: arguments[i]
    };

    return evaluator.eval(_expression, context);
  }
}
