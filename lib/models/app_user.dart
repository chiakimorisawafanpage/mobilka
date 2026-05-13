class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.googleId,
    required this.createdAt,
  });

  final int id;
  final String email;
  final String name;
  final String? googleId;

  factory AppUser.fromMap(Map<String, Object?> map) {
    return AppUser(
      id: (map['id'] as int?) ?? (map['id'] as num?)!.toInt(),
      email: map['email']! as String,
      name: map['name']! as String,
      googleId: map['googleId'] as String?,
    );
  }
  final String createdAt;
}
