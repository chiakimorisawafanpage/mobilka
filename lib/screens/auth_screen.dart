import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/auth_repo.dart';
import '../theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.onSuccess});

  final VoidCallback? onSuccess;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _name = '';
  bool _isLoading = false;
  String? _error;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final db = context.read<Database>();
    final auth = context.read<AuthState>();

    AuthResult result;
    if (_isLogin) {
      result = await loginUser(db, _email, _password);
    } else {
      result = await registerUser(db, _email, _password, _name);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success && result.user != null) {
      auth.login(result.user!);
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      } else {
        Navigator.of(context).pop();
      }
    } else {
      setState(() => _error = result.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: retroAppBar(_isLogin ? 'LOGIN' : 'REGISTER'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  _isLogin ? Icons.login_rounded : Icons.person_add_rounded,
                  size: 48,
                  color: RetroTheme.accentBlue,
                ),
                const SizedBox(height: 12),
                Text(
                  _isLogin ? 'Welcome back!' : 'Create account',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: RetroTheme.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isLogin
                      ? 'Sign in to place orders'
                      : 'Register to start shopping',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: RetroTheme.muted,
                  ),
                ),
                const SizedBox(height: 24),
                if (!_isLogin) ...[
                  _buildTextField(
                    label: 'Name',
                    icon: Icons.person_outline,
                    onChanged: (v) => setState(() => _name = v),
                  ),
                  const SizedBox(height: 14),
                ],
                _buildTextField(
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => setState(() => _email = v),
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscure: true,
                  onChanged: (v) => setState(() => _password = v),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: RetroTheme.danger, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_error!,
                              style: const TextStyle(
                                color: RetroTheme.danger,
                                fontSize: 13,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RetroTheme.accentBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _isLogin ? 'Sign In' : 'Register',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _error = null;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Register"
                        : 'Already have an account? Sign in',
                    style: const TextStyle(
                      color: RetroTheme.accentBlue,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: RetroTheme.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: RetroTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: RetroTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: RetroTheme.accentBlue, width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF8F8F6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
