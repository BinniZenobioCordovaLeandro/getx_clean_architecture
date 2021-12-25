import 'dart:convert';

import '../../domain/entities/abstract_user_entity.dart';

class UserModel implements AbstractUserEntity {
  @override
  final String? id;
  @override
  final String? name;

  const UserModel({this.id, this.name});

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        id: data['id'] as String?,
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  UserModel copyWith({
    String? id,
    String? name,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}
