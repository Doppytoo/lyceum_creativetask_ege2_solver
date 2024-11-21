import 'package:ege_solver/ui/widgets/gap.dart';
import 'package:fluent_ui/fluent_ui.dart';

class SolutionScreen extends StatelessWidget {
  const SolutionScreen(this.solution, {super.key});

  final (String, Map<List<bool?>, List<bool>>) solution;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: IconButton(
            icon: const Icon(FluentIcons.back),
            onPressed: () => Navigator.of(context).pop(key),
          ),
        ),
        title: const Text('Решение'),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Ответ: ${solution.$1}',
                style: FluentTheme.of(context).typography.title),
            const Gap(12.0),
            Card(
              child: InfoLabel(
                label: 'Заполненный и распутанный фрагмент таблицы истинности:',
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(4.0),
                        child: const Text('x'),
                      ),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(4.0),
                          child: Text('y')),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(4.0),
                          child: Text('z')),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(4.0),
                          child: Text('w')),
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
