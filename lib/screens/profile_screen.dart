import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/orders_repo.dart';
import '../db/profile_repo.dart';
import '../models/user_profile.dart';
import '../navigation/app_shell_controller.dart';
import '../providers/auth_provider.dart';
import '../theme.dart';
import '../widgets/geocities_badges.dart';
import '../widgets/rainbow_divider.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_input.dart';
import '../widgets/retro_panel.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _phone = '';
  int _orderCount = 0;
  AppShellController? _shell;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shell = context.read<AppShellController>();
    if (!identical(shell, _shell)) {
      _shell?.removeListener(_onShellChanged);
      _shell = shell;
      _shell!.addListener(_onShellChanged);
    }
  }

  void _onShellChanged() {
    if (_shell?.tab == 3) _load();
  }

  @override
  void dispose() {
    _shell?.removeListener(_onShellChanged);
    super.dispose();
  }

  Future<void> _load() async {
    final db = context.read<Database>();
    final auth = context.read<AuthProvider>();
    final p = await getProfile(db);
    int orders = 0;
    if (auth.isLoggedIn) {
      orders = await countOrdersForUser(db, auth.user!.id);
    }
    if (!mounted) return;
    setState(() {
      _name = p.name;
      _phone = p.phone;
      _orderCount = orders;
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
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: retroAppBar('PROFILE', automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        children: [
          if (auth.isLoggedIn) ...[
            RetroPanel(
              title: 'ACCOUNT',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: RetroTheme.accentBlue,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: RetroTheme.win98Light, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            auth.user!.name.isNotEmpty
                                ? auth.user!.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: RetroSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.user!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                                color: RetroTheme.text,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              auth.user!.email,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                color: RetroTheme.muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  const RainbowDivider(height: 2),
                  Row(
                    children: [
                      _StatTile(
                          label: 'ORDERS', value: _orderCount.toString()),
                      const SizedBox(width: RetroSpacing.md),
                      _StatTile(
                        label: 'STATUS',
                        value: auth.user!.googleId != null
                            ? 'GOOGLE'
                            : 'EMAIL',
                      ),
                    ],
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  RetroButton(
                    title: 'LOGOUT',
                    variant: RetroButtonVariant.danger,
                    onPressed: () {
                      auth.logout();
                    },
                  ),
                ],
              ),
            ),
          ] else ...[
            RetroPanel(
              title: 'ACCOUNT',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'You are browsing as a guest.\nSign in to track your orders.',
                    style: TextStyle(
                      color: RetroTheme.muted,
                      fontFamily: 'monospace',
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: RetroButton(
                      title: 'SIGN IN / REGISTER',
                      onPressed: () async {
                        final result = await Navigator.of(context,
                                rootNavigator: true)
                            .push<bool>(MaterialPageRoute<bool>(
                                builder: (_) => const LoginScreen()));
                        if (result == true && mounted) _load();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: RetroSpacing.sm),
          RetroPanel(
            title: 'DELIVERY INFO',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Row(
                  children: [
                    RetroButton(title: 'SAVE', onPressed: _save),
                    const SizedBox(width: RetroSpacing.sm),
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

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            color: RetroTheme.accentBlue,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            color: RetroTheme.muted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
