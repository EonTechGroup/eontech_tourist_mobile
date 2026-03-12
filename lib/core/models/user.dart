import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserRole { tourist, businessOwner }

@JsonSerializable()
class AppUser {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? avatarUrl;

  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatarUrl,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  AppUser copyWith({
    String? name,
    String? avatarUrl,
    UserRole? role,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}