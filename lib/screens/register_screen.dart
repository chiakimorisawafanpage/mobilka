import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_input.dart';
import '../widgets/retro_panel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _name = '';
  String _email = '';
  String _password = '';
  String _passwordConfirm = '';
  bool _busy = false;

  Future<void> _submit() async {
    if (_name.trim().isEmpty) {
      _showError('Введите имя');
      return;
    }
    if (_email.trim().isEmpty || !_email.contains('@')) {
      _showError('Введите корректный email');
      return;
    }
    if (_password.length < 4) {
      _showError('Пароль минимум 4 символа');
      return;
    }
    if (_password != _passwordConfirm) {
      _showError('Пароли не совпадают');
      return;
    }

    setState(() => _busy = true);
    final auth = context.read<AuthProvider>();
    final err = await auth.register(
      email: _email,
      password: _password,
      name: _name,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (err != null) {
      _showError(err);
    } else {
      Navigator.of(context).pop(true);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: retroAppBar('REGISTER'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RetroSpacing.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: RetroPanel(
              title: 'CREATE ACCOUNT',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Fill in the form to create your account.',
                    style: TextStyle(
                      color: RetroTheme.muted,
                      fontFamily: 'monospace',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  RetroInput(
                    label: 'NAME',
                    value: _name,
                    onChanged: (t) => setState(() => _name = t),
                    placeholder: 'Your name',
                  ),
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
                  RetroInput(
                    label: 'CONFIRM PASSWORD',
                    value: _passwordConfirm,
                    onChanged: (t) => setState(() => _passwordConfirm = t),
                    placeholder: '********',
                    obscureText: true,
                  ),
                  const SizedBox(height: RetroSpacing.sm),
                  RetroButton(
                    title: _busy ? 'CREATING...' : 'REGISTER',
                    disabled: _busy,
                    onPressed: _submit,
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
