import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

import '../models/app_user.dart';

String _hashPassword(String password) {
  final bytes = utf8.encode(password);
  return sha256.convert(bytes).toString();
}

Future<AppUser> registerUser(
  Database db, {
  required String email,
  required String password,
  required String name,
}) async {
  final trimmedEmail = email.trim().toLowerCase();
  final existing = await db.rawQuery(
    'SELECT id FROM users WHERE email = ?',
    [trimmedEmail],
  );
  if (existing.isNotEmpty) {
    throw StateError('Пользователь с таким email уже существует');
  }

  final hash = _hashPassword(password);
  final id = await db.rawInsert(
    '''INSERT INTO users (email, passwordHash, name, createdAt)
       VALUES (?, ?, ?, ?)''',
    [trimmedEmail, hash, name.trim(), DateTime.now().toUtc().toIso8601String()],
  );
  return AppUser(id: id, email: trimmedEmail, name: name.trim());
}

Future<AppUser?> loginUser(
  Database db, {
  required String email,
  required String password,
}) async {
  final hash = _hashPassword(password);
  final rows = await db.rawQuery(
    'SELECT id, email, name, googleId FROM users WHERE email = ? AND passwordHash = ?',
    [email.trim().toLowerCase(), hash],
  );
  if (rows.isEmpty) return null;
  return AppUser.fromMap(rows.first);
}

Future<AppUser> upsertGoogleUser(
  Database db, {
  required String googleId,
  required String email,
  required String name,
}) async {
  final existing = await db.rawQuery(
    'SELECT id, email, name, googleId FROM users WHERE googleId = ?',
    [googleId],
  );
  if (existing.isNotEmpty) {
    return AppUser.fromMap(existing.first);
  }

  final byEmail = await db.rawQuery(
    'SELECT id, email, name, googleId FROM users WHERE email = ?',
    [email.trim().toLowerCase()],
  );
  if (byEmail.isNotEmpty) {
    await db.rawUpdate(
      'UPDATE users SET googleId = ?, name = ? WHERE id = ?',
      [googleId, name, (byEmail.first['id'] as int)],
    );
    return AppUser(
      id: (byEmail.first['id'] as int),
      email: email.trim().toLowerCase(),
      name: name,
      googleId: googleId,
    );
  }

  final id = await db.rawInsert(
    '''INSERT INTO users (email, passwordHash, name, googleId, createdAt)
       VALUES (?, ?, ?, ?, ?)''',
    [
      email.trim().toLowerCase(),
      '',
      name.trim(),
      googleId,
      DateTime.now().toUtc().toIso8601String(),
    ],
  );
  return AppUser(
    id: id,
    email: email.trim().toLowerCase(),
    name: name.trim(),
    googleId: googleId,
  );
}

Future<AppUser?> getUserById(Database db, int id) async {
  final rows = await db.rawQuery(
    'SELECT id, email, name, googleId FROM users WHERE id = ?',
    [id],
  );
  if (rows.isEmpty) return null;
  return AppUser.fromMap(rows.first);
}
