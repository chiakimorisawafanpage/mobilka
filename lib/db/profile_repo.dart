import 'package:sqflite/sqflite.dart';

import '../models/user_profile.dart';

Future<UserProfile> getProfile(Database db) async {
  final rows =
      await db.rawQuery('SELECT name, phone FROM user_profile WHERE id = 1');
  if (rows.isEmpty) {
    return const UserProfile(name: 'Гость', phone: '');
  }
  final m = rows.first;
  return UserProfile(name: m['name']! as String, phone: m['phone']! as String);
}

Future<void> upsertProfile(Database db, UserProfile profile) async {
  await db.rawInsert(
    '''INSERT INTO user_profile (id, name, phone) VALUES (1, ?, ?)
     ON CONFLICT(id) DO UPDATE SET name = excluded.name, phone = excluded.phone''',
    [profile.name.trim(), profile.phone.trim()],
  );
}
