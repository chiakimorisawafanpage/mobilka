import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_input.dart';
import '../widgets/retro_panel.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  bool _busy = false;

  Future<void> _submit() async {
    if (_email.trim().isEmpty || _password.isEmpty) return;
    setState(() => _busy = true);
    final auth = context.read<AuthProvider>();
    final err = await auth.login(email: _email, password: _password);
    if (!mounted) return;
    setState(() => _busy = false);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
    } else {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: retroAppBar('LOGIN'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RetroSpacing.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: RetroPanel(
              title: 'SIGN IN',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter your credentials to continue.',
                    style: TextStyle(
                      color: RetroTheme.muted,
                      fontFamily: 'monospace',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  RetroInput(
                    label: 'EMAIL',
                    value: _email,
                    onChanged: (t) => setState(() => _email = t),
                    placeholder: 'user@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  RetroInput(
                    label: 'PASSWORD',
                    value: _password,
                    onChanged: (t) => setState(() => _password = t),
                    placeholder: '********',
                    obscureText: true,
                  ),
                  const SizedBox(height: RetroSpacing.sm),
                  RetroButton(
                    title: _busy ? 'SIGNING IN...' : 'SIGN IN',
                    disabled: _busy,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      color: RetroTheme.muted,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: RetroSpacing.xs),
                  RetroButton(
                    title: 'CREATE ACCOUNT',
                    variant: RetroButtonVariant.link,
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      final result = await nav.push<bool>(
                        MaterialPageRoute<bool>(
                            builder: (_) => const RegisterScreen()),
                      );
                      if (result == true && mounted) {
                        nav.pop(true);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
