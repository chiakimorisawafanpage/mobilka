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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final db = context.read<Database>();
    final p = await getProfile(db);
    if (!mounted) return;
    setState(() {
      _name = p.name;
      _phone = p.phone;
    });
  }

  Future<void> _save() async {
    final db = context.read<Database>();
    await upsertProfile(db, UserProfile(name: _name, phone: _phone));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved.'),
        duration: Duration(milliseconds: 1200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: retroAppBar('PROFILE', automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        children: [
          RetroPanel(
            title: 'MY DARK HOMEPAGE',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome, wanderer, to your profile.\nFeel free to visit all my cave then\ntell me what you like and what not.',
                  style: TextStyle(
                    color: RetroTheme.text,
                    fontFamily: 'monospace',
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const RainbowDivider(height: 2),
                RetroInput(
                  label: 'NAME',
                  value: _name,
                  onChanged: (t) => setState(() => _name = t),
                  placeholder: 'Your name...',
                ),
                RetroInput(
                  label: 'PHONE',
                  value: _phone,
                  onChanged: (t) => setState(() => _phone = t),
                  keyboardType: TextInputType.phone,
                  placeholder: '+7...',
                ),
                Wrap(
                  spacing: RetroSpacing.sm,
                  runSpacing: RetroSpacing.sm,
                  children: [
                    RetroButton(title: 'SAVE', onPressed: _save),
                    RetroButton(
                      title: 'RELOAD',
                      variant: RetroButtonVariant.link,
                      onPressed: _load,
                    ),
                  ],
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
