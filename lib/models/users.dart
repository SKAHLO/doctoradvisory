import 'package:json_annotation/json_annotation.dart';
part 'users.g.dart';

@JsonSerializable()

class AuthUser {
  final String id;
  final String username;
  final String profilepicture;

    factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  AuthUser({required this.id, required this.username, required this.profilepicture});

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);
}
