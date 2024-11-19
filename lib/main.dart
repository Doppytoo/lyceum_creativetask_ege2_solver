import 'package:ege_solver/ui/widgets/row_input.dart';
import 'package:fluent_ui/fluent_ui.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: true,
      themeMode: ThemeMode.light,
      theme: FluentThemeData(brightness: Brightness.light),
      darkTheme: FluentThemeData(brightness: Brightness.dark),
      home: const NavigationView(
        content: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Text('Решатель ЕГЭ-2'),
      ),
      content: Center(
        child: TableInput(
          numberOfVariables: 4,
        ),
      ),
    );
  }
}
