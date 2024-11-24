import 'package:ege_solver/ui/screens/solution_screen.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;

import 'package:ege_solver/ui/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await flutter_acrylic.Window.initialize();

  await flutter_acrylic.Window.hideWindowControls();
  const WindowOptions windowOptions = WindowOptions(
    title: 'Решатель ЕГЭ-2',
    minimumSize: Size(500, 600),
    size: Size(600, 600),
    maximumSize: Size(1000, 1000),
    // center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setMaximizable(false);
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Решатель ЕГЭ-2',
      debugShowCheckedModeBanner: true,
      themeMode: ThemeMode.system,
      theme: FluentThemeData(brightness: Brightness.light),
      darkTheme: FluentThemeData(brightness: Brightness.dark),
      routes: {
        '/solution': (context) => SolutionScreen(
              ModalRoute.of(context)!.settings.arguments as (
                String,
                Map<List<bool?>, List<bool>>
              ),
            )
      },
      home: const MainScreen(),
    );
  }
}
