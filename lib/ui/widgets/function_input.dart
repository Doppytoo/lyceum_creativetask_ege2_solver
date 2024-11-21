import 'package:fluent_ui/fluent_ui.dart';

// * ((x ∧ y) ∨ (y ∧ z)) ≡ ((x → w) ∧ (w → z))

class ExpressionInput extends StatelessWidget {
  ExpressionInput({
    required this.inputController,
    super.key,
  });

  final TextEditingController inputController;

  static const label = '''Введите логическое выражение, определяющее функцию.
Можно использовать:
- Символы, как на "Решу ЕГЭ" (можно просто скопировать оттуда)
- Операторы, как в Python (and, or и т.п.)
- Операторы, как в C-подобных языках (&&, || и т.п.)
- Символ "->" для импликации (кроме используемых в варианах выше)''';

  @override
  Widget build(BuildContext context) {
    return InfoLabel(
      label: label,
      child: TextBox(
        controller: inputController,
        expands: false,
      ),
    );
  }
}
