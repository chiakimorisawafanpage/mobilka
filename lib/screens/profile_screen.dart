import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/profile_repo.dart';
import '../models/user_profile.dart';
import '../theme.dart';
import '../widgets/geocities_badges.dart';
import '../widgets/rainbow_divider.dart';
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
      appBar: retroAppBar('\u2605 PROFILE \u2605',
          automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        children: [
          RetroPanel(
            title: '\u2605 MY HOMEPAGE \u2605',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to my personal page!\nThis is not an account. Just a row in SQLite.',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    color: RetroTheme.text,
                    height: 1.5,
                  ),
                ),
                const RainbowDivider(height: 2),
                RetroInput(
                    label: 'NAME',
                    value: _name,
                    onChanged: (t) => setState(() => _name = t)),
                RetroInput(
                  label: 'PHONE',
                  value: _phone,
                  onChanged: (t) => setState(() => _phone = t),
                  keyboardType: TextInputType.phone,
                ),
                RetroButton(
                  title: 'SAVE',
                  onPressed: () async {
                    await upsertProfile(
                        db, UserProfile(name: _name, phone: _phone));
                    if (!context.mounted) return;
                    await showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('OK'),
                        content: const Text('Saved!'),
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
                  title: 'RELOAD',
                  variant: RetroButtonVariant.link,
                  onPressed: _reload,
                ),
              ],
            ),
          ),
          const SizedBox(height: RetroSpacing.md),
          const Center(child: GeocitiesGuestbook()),
          const SizedBox(height: RetroSpacing.sm),
          const Center(child: GeocitiesHitCounter()),
          const SizedBox(height: RetroSpacing.sm),
          const Center(child: GeocitiesBestViewed()),
          const SizedBox(height: RetroSpacing.sm),
          const Center(child: GeocitiesWebring()),
          const SizedBox(height: RetroSpacing.lg),
        ],
      ),
    );
  }
}
