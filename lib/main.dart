import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'db/app_database.dart';
import 'db/auth_repo.dart';
import 'navigation/app_shell.dart';
import 'navigation/app_shell_controller.dart';
import 'providers/auth_provider.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
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
        ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(database)),
      ],
      child: MaterialApp(
        title: 'Retro Energy Shop',
        theme: buildRetroMaterialTheme(),
        home: const AppShell(),
      ),
    );
  }
}
