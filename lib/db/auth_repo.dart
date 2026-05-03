import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/app_user.dart';

String _hashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = base64Encode(bytes);
  return digest;
}

bool _verifyPassword(String password, String hash) {
  return _hashPassword(password) == hash;
}

class AuthResult {
  AuthResult({required this.success, this.user, this.error});
  final bool success;
  final AppUser? user;
  final String? error;
}

Future<AuthResult> registerUser(
    Database db, String email, String password, String name) async {
  if (email.trim().isEmpty || !email.contains('@')) {
    return AuthResult(success: false, error: 'Invalid email address');
  }
  if (password.length < 4) {
    return AuthResult(
        success: false, error: 'Password must be at least 4 characters');
  }
  if (name.trim().isEmpty) {
    return AuthResult(success: false, error: 'Name is required');
  }

  try {
    final hash = _hashPassword(password);
    final createdAt = DateTime.now().toUtc().toIso8601String();
    final id = await db.rawInsert(
      '''INSERT INTO users (email, passwordHash, name, createdAt)
       VALUES (?, ?, ?, ?)''',
      [email.trim().toLowerCase(), hash, name.trim(), createdAt],
    );
    return AuthResult(
      success: true,
      user: AppUser(
        id: id,
        email: email.trim().toLowerCase(),
        name: name.trim(),
        createdAt: createdAt,
      ),
    );
  } catch (e) {
    if (e.toString().contains('UNIQUE')) {
      return AuthResult(
          success: false, error: 'User with this email already exists');
    }
    return AuthResult(success: false, error: 'Registration failed: $e');
  }
}

Future<AuthResult> loginUser(
    Database db, String email, String password) async {
  final rows = await db.rawQuery(
    'SELECT id, email, passwordHash, name, createdAt FROM users WHERE email = ?',
    [email.trim().toLowerCase()],
  );
  if (rows.isEmpty) {
    return AuthResult(success: false, error: 'User not found');
  }
  final row = rows.first;
  final hash = row['passwordHash']! as String;
  if (!_verifyPassword(password, hash)) {
    return AuthResult(success: false, error: 'Wrong password');
  }
  return AuthResult(
    success: true,
    user: AppUser(
      id: (row['id'] as int?) ?? (row['id'] as num?)!.toInt(),
      email: row['email']! as String,
      name: row['name']! as String,
      createdAt: row['createdAt']! as String,
    ),
  );
}

class AuthState extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;

  void login(AppUser user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
