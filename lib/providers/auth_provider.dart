import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../db/auth_repo.dart';
import '../models/app_user.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._db);

  final Database _db;
  AppUser? _user;

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<String?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _user = await registerUser(
        _db,
        email: email,
        password: password,
        name: name,
      );
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Bad state: ', '');
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final u = await loginUser(_db, email: email, password: password);
    if (u == null) return 'Неверный email или пароль';
    _user = u;
    notifyListeners();
    return null;
  }

  Future<String?> signInWithGoogle({
    required String googleId,
    required String email,
    required String name,
  }) async {
    try {
      _user = await upsertGoogleUser(
        _db,
        googleId: googleId,
        email: email,
        name: name,
      );
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
