import 'package:ege_solver/ui/utils/window_header.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:ege_solver/logic/logical_expression_parser.dart';
import 'package:ege_solver/logic/solver.dart';
import 'package:ege_solver/ui/widgets/function_input.dart';
import 'package:ege_solver/ui/widgets/gap.dart';
import 'package:ege_solver/ui/widgets/table_input.dart';
import 'package:window_manager/window_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<List<bool?>> _table = [
    [null, null, null, null, null]
  ];
  int _numberOfVariables = 4;
  final _expressionInputController = TextEditingController();

  bool _validateInput() {
    final isTableValid =
        _table.fold<bool>(true, (prev, row) => prev && row.last != null);

    final isExpressionValid = LogicalExpressionParser.validateStatement(
        _expressionInputController.text);

    return isTableValid && isExpressionValid;
  }

  void _solve() async {
    if (!_validateInput()) {
      await _displayInvalidInputInfoBar();
      return;
    }

    try {
      final solver = EgeTask2Solver(
          LogicalExpressionParser(
            _expressionInputController.text,
            numberOfVariables: _numberOfVariables,
          ),
          _table);

      final solution = solver.solve();

      if (mounted) {
        await _showSolution(solution);
      }
    } catch (e) {
      await _displayInvalidInputInfoBar();
    }
  }

  Future<void> _displayInvalidInputInfoBar() =>
      displayInfoBar(context, builder: (context, close) {
        return InfoBar(
          title: const Text('Данные введены некорректно'),
          // content: const Text('Проверьте, всё ли вы ввели правильно'),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.warning,
        );
      });

  Future<void> _showSolution(
      (String, Map<List<bool?>, List<bool>>)? solution) async {
    if (solution == null) {
      await displayInfoBar(context, builder: (context, close) {
        return InfoBar(
          title: const Text('Решение не найдено'),
          // content: solution == null ? null :
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.error,
        );
      });
      return;
    }

    if (mounted) {
      Navigator.of(context, rootNavigator: true)
          .pushNamed('/solution', arguments: solution);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
        title: DragToMoveArea(
            child: SizedBox.expand(
                child: Align(
          alignment: Alignment.centerLeft,
          child: Text("Решатель ЕГЭ-2"),
        ))),
        leading: Icon(FluentIcons.calculated_table),
        actions: WindowButtons(),
      ),
      content: ScaffoldPage(
        header: PageHeader(title: Text('Условие задачи')),
        content: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Выберите количество аргументов функции"),
                  ComboBox<int>(
                    value: _numberOfVariables,
                    items: const [
                      ComboBoxItem(value: 2, child: Text('2 (x, y)')),
                      ComboBoxItem(value: 3, child: Text('3 (x, y, z)')),
                      ComboBoxItem(value: 4, child: Text('4 (x, y, z, w)')),
                    ],
                    onChanged: (value) => setState(() {
                      _table.clear();

                      _numberOfVariables = value!;
                      _table.add(List.filled(_numberOfVariables + 1, null));
                    }),
                  ),
                ],
              ),
              const Gap(8),
              ExpressionInput(inputController: _expressionInputController),
              const Gap(8),
              TableInput(
                table: _table,
                numberOfVariables: _numberOfVariables,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(child: Text("Решить"), onPressed: _solve),
              )
            ],
          ),
        ),
      ),
    );
  }
}
