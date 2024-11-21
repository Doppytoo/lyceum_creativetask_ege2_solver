import 'package:fluent_ui/fluent_ui.dart';

class TableInput extends StatefulWidget {
  const TableInput(
      {required this.table, required this.numberOfVariables, super.key});

  final int numberOfVariables;
  final List<List<bool?>> table;

  @override
  State<TableInput> createState() => _TableInputState();
}

class _TableInputState extends State<TableInput> {
  late final List<List<bool?>> _table;

  @override
  void initState() {
    _table = widget.table;
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InfoLabel(
        label:
            'Введите данный в задаче фрагмент таблицы истинности\n(* означает неизвестное значение)\nЗначение самой функции не может быть неизвестным',
        child: ListView(
          children: [
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    for (int i = 0; i < widget.numberOfVariables; ++i)
                      const Center(child: Text('?')),
                    const Center(child: Text('F')),
                    const SizedBox.shrink()
                  ],
                ),
                for (int i = 0; i < _table.length; ++i)
                  TableRow(
                    children: [
                      for (int j = 0; j < _table[i].length; ++j)
                        BooleanValueSelector(
                          value: _table[i][j],
                          onChanged: (value) =>
                              setState(() => _table[i][j] = value),
                          key: Key('rowInputSelectorN$i/$j'),
                        ),
                      IconButton(
                          icon: const Icon(FluentIcons.remove),
                          onPressed: () => setState(() => _table.removeAt(i))),
                    ],
                  )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(FluentIcons.add),
                onPressed: () => setState(() => _table
                    .add(List.filled(widget.numberOfVariables + 1, null))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BooleanValueSelector extends StatelessWidget {
  const BooleanValueSelector({required this.onChanged, this.value, super.key});

  final bool? value;
  final void Function(bool? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ComboBox<bool?>(
        onChanged: (value) {
          onChanged(value);
        },
        value: value,
        placeholder: const Text('*'),
        items: const [
          ComboBoxItem(
            value: null,
            child: Text('*'),
          ),
          ComboBoxItem(
            value: false,
            child: Text('0'),
          ),
          ComboBoxItem(
            value: true,
            child: Text('1'),
          ),
        ],
      ),
    );
  }
}
