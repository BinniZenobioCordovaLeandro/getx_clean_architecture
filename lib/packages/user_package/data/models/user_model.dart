import 'dart:convert';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';

class UserModel implements AbstractUserEntity {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? avatar;
  @override
  final String? carPlate;
  @override
  final String? carPhoto;
  @override
  final String? phoneNumber;
  @override
  final String? rank;
  @override
  final String? role;

  const UserModel({
    this.id,
    this.name,
    this.avatar,
    this.carPlate,
    this.carPhoto,
    this.phoneNumber,
    this.rank,
    this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        id: data['id'] as String?,
        name: data['name'] as String?,
        avatar: data['avatar'] as String?,
        carPlate: data['car_plate'] as String?,
        carPhoto: data['car_photo'] as String?,
        phoneNumber: data['phone_number'] as String?,
        rank: data['rank'] as String?,
        role: data['role'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'car_plate': carPlate,
        'car_photo': carPhoto,
        'phone_number': phoneNumber,
        'rank': rank,
        'role': role,
      };

  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  UserModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? carPlate,
    String? carPhoto,
    String? phoneNumber,
    String? rank,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      carPlate: carPlate ?? this.carPlate,
      carPhoto: carPhoto ?? this.carPhoto,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      rank: rank ?? this.rank,
      role: role ?? this.role,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        name,
        avatar,
        carPlate,
        carPhoto,
        phoneNumber,
        rank,
        role,
      ];
}
