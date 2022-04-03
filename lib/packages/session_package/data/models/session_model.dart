import 'dart:convert';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';

class SessionModel extends AbstractSessionEntity {
  @override
  final bool? isSigned;
  @override
  final String? idSessions;
  @override
  final String? idUsers;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final String? avatar;

  const SessionModel({
    this.isSigned,
    this.idSessions,
    this.idUsers,
    this.name,
    this.email,
    this.avatar,
  });

  factory SessionModel.fromMap(Map<String, dynamic> data) => SessionModel(
        isSigned: data['is_signed'] as bool?,
        idSessions: data['id_sessions'] as String?,
        idUsers: data['id_users'] as String?,
        name: data['name'] as String?,
        email: data['email'] as String?,
        avatar: data['avatar'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'is_signed': isSigned,
        'id_sessions': idSessions,
        'id_users': idUsers,
        'name': name,
        'email': email,
        'avatar': avatar,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SessionModel].
  factory SessionModel.fromJson(String data) {
    return SessionModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SessionModel] to a JSON string.
  String toJson() => json.encode(toMap());

  SessionModel copyWith({
    bool? isSigned,
    String? idSessions,
    String? idUsers,
    String? name,
    String? email,
    String? avatar,
  }) {
    return SessionModel(
      isSigned: isSigned ?? this.isSigned,
      idSessions: idSessions ?? this.idSessions,
      idUsers: idUsers ?? this.idUsers,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [isSigned, idSessions, idUsers, name, email, avatar];
}
