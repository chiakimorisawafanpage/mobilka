import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'db/app_database.dart';
import 'navigation/app_shell.dart';
import 'navigation/app_shell_controller.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await openAppDatabase();
  runApp(RetroEnergyApp(database: db));
}

class RetroEnergyApp extends StatelessWidget {
  const RetroEnergyApp({super.key, required this.database});

  final Database database;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Database>.value(value: database),
        ChangeNotifierProvider<AppShellController>(
            create: (_) => AppShellController()),
      ],
      child: MaterialApp(
        title: 'Retro Energy Shop',
        theme: buildRetroMaterialTheme(),
        home: const AppShell(),
      ),
    );
  }
}
