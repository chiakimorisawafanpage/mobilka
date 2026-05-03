import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/profile_repo.dart';
import '../models/user_profile.dart';
import '../theme.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_input.dart';
import '../widgets/retro_panel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _phone = '';

  Future<void> _reload() async {
    final db = context.read<Database>();
    final p = await getProfile(db);
    if (!mounted) return;
    setState(() {
      _name = p.name;
      _phone = p.phone;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<Database>();

    return Scaffold(
      appBar: retroAppBar('ПРОФИЛЬ', automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(RetroSpacing.md),
        child: RetroPanel(
          title: 'ПРОФИЛЬ (локально)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Это не аккаунт в интернете. Это просто строка в SQLite.',
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: RetroTheme.text),
              ),
              const SizedBox(height: RetroSpacing.sm),
              RetroInput(
                  label: 'ИМЯ',
                  value: _name,
                  onChanged: (t) => setState(() => _name = t)),
              RetroInput(
                label: 'ТЕЛЕФОН',
                value: _phone,
                onChanged: (t) => setState(() => _phone = t),
                keyboardType: TextInputType.phone,
              ),
              RetroButton(
                title: 'СОХРАНИТЬ',
                onPressed: () async {
                  await upsertProfile(
                      db, UserProfile(name: _name, phone: _phone));
                  if (!context.mounted) return;
                  await showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('OK'),
                      content: const Text('Сохранено'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('OK')),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: RetroSpacing.sm),
              RetroButton(
                title: 'ПЕРЕЗАГРУЗИТЬ',
                variant: RetroButtonVariant.link,
                onPressed: _reload,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
