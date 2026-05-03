import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/auth_repo.dart';
import '../theme.dart';
import '../widgets/geocities_badges.dart';
import '../widgets/rainbow_divider.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      appBar: retroAppBar('PROFILE', automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: auth.isLoggedIn
                ? _buildLoggedIn(context, auth)
                : _buildGuest(context),
          ),
          const SizedBox(height: RetroSpacing.md),
          const RainbowDivider(height: 2),
          const SizedBox(height: RetroSpacing.sm),
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

  Widget _buildGuest(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            shape: BoxShape.circle,
            border: Border.all(color: RetroTheme.border, width: 2),
          ),
          child: const Icon(Icons.person_outline,
              size: 36, color: RetroTheme.muted),
        ),
        const SizedBox(height: 12),
        const Text(
          'Guest',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: RetroTheme.text,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Sign in to place orders and track delivery',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: RetroTheme.muted,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.login_rounded, size: 20),
            label: const Text(
              'Sign In / Register',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: RetroTheme.accentBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push<void>(
                MaterialPageRoute<void>(
                    builder: (_) => const AuthScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoggedIn(BuildContext context, AuthState auth) {
    final user = auth.user!;
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFFE3F2FD),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: RetroTheme.accentBlue,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: RetroTheme.text,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email_outlined,
                size: 14, color: RetroTheme.muted),
            const SizedBox(width: 4),
            Text(
              user.email,
              style: const TextStyle(
                fontSize: 13,
                color: RetroTheme.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Sign Out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: RetroTheme.danger,
              side: const BorderSide(color: RetroTheme.danger),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => auth.logout(),
          ),
        ),
      ],
    );
  }
}
