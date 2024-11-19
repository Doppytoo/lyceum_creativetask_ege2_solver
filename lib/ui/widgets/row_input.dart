import 'package:fluent_ui/fluent_ui.dart';

class TableInput extends StatefulWidget {
  const TableInput({required this.numberOfVariables, super.key});

  final int numberOfVariables;

  @override
  State<TableInput> createState() => _TableInputState();
}

class _TableInputState extends State<TableInput> {
  static const _variableNames = ['x', 'y', 'z', 'w'];
  List<List<bool?>> _rows = [];

  @override
  void initState() {
    _rows.add(List.filled(widget.numberOfVariables, null));
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    print(_rows);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                for (String name
                    in _variableNames.sublist(0, widget.numberOfVariables))
                  Center(child: Text(name)),
                SizedBox.shrink()
              ],
            ),
            for (int i = 0; i < _rows.length; ++i)
              TableRow(
                children: [
                  for (int j = 0; j < _rows[i].length; ++j)
                    BooleanValueSelector(
                      value: _rows[i][j],
                      onChanged: (value) => setState(() => _rows[i][j] = value),
                      key: Key('rowInputSelectorN$i/$j'),
                    ),
                  IconButton(
                      icon: const Icon(FluentIcons.remove),
                      onPressed: () => setState(() => _rows.removeAt(i))),
                ],
              )
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: IconButton(
            icon: const Icon(FluentIcons.add),
            onPressed: () => setState(
                () => _rows.add(List.filled(widget.numberOfVariables, null))),
          ),
        )
      ],
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
            value: true,
            child: Text('1'),
          ),
          ComboBoxItem(
            value: false,
            child: Text('0'),
          ),
          ComboBoxItem(
            value: null,
            child: Text('*'),
          ),
        ],
      ),
    );
  }
}
