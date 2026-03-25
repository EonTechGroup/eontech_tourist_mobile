// lib/core/models/user.dart

// ── UserRole enum ─────────────────────────────────────────────
// Single source of truth — imported by both AppProvider and AuthNotifier.
// DO NOT redefine UserRole in auth_provider.dart — import from here instead.
enum UserRole { tourist, businessOwner }

// ── AppUser model ─────────────────────────────────────────────
class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? avatarUrl;
  final String? nationality;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.tourist,
    this.avatarUrl,
    this.nationality,
  });

  bool get isOwner => role == UserRole.businessOwner;
  bool get isTourist => role == UserRole.tourist;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? avatarUrl,
    String? nationality,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      nationality: nationality ?? this.nationality,
    );
  }
}