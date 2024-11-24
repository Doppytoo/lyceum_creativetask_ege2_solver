import 'package:ege_solver/ui/utils/window_header.dart';
import 'package:ege_solver/ui/widgets/gap.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

class SolutionScreen extends StatelessWidget {
  const SolutionScreen(this.solution, {super.key});

  final (String, Map<List<bool?>, List<bool>>) solution;

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
        actions: WindowButtons(),
      ),
      content: ScaffoldPage(
        // header: PageHeader(
        //   leading: Padding(
        //     padding: const EdgeInsets.all(4.0),
        //     child: IconButton(
        //       icon: const Icon(FluentIcons.back),
        //       onPressed: () => Navigator.of(context).pop(key),
        //     ),
        //   ),
        //   title: const Text('Решение'),
        // ),
        content: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Ответ: ${solution.$1}',
                  style: FluentTheme.of(context).typography.title),
              const Gap(12.0),
              Card(
                child: InfoLabel(
                  label:
                      'Заполненный и распутанный фрагмент таблицы истинности:',
                  child: ResultsTable(solution: solution),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ResultsTable extends StatelessWidget {
  const ResultsTable({
    super.key,
    required this.solution,
  });

  static const _variableNames = ['x', 'y', 'z', 'w'];

  final (String, Map<List<bool?>, List<bool>>) solution;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          ..._variableNames.sublist(0, solution.$2.values.first.length - 1).map(
                (name) => Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4.0),
                    child: Text(name)),
              ),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4.0),
              child: Text('F')),
        ]),
        for (final row in solution.$2.values)
          TableRow(
              children: row
                  .map((value) => Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(4.0),
                      child: Text(value ? '1' : '0')))
                  .toList())
      ],
    );
  }
}
