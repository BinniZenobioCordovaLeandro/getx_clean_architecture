import 'dart:convert';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';

class UserModel implements AbstractUserEntity {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final String? avatar;
  @override
  final String? document;
  @override
  final String? carPlate;
  @override
  final String? carPhoto;
  @override
  final String? carModel;
  @override
  final String? carColor;
  @override
  final String? carDescription;
  @override
  final String? phoneNumber;
  @override
  final String? licensePhoto;
  @override
  final String? license;
  @override
  final String? rank;
  @override
  final String? observation;
  @override
  final String? isDriver;

  const UserModel({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.document,
    this.carPlate,
    this.carPhoto,
    this.carModel,
    this.carColor,
    this.carDescription,
    this.phoneNumber,
    this.licensePhoto,
    this.license,
    this.rank,
    this.observation,
    this.isDriver,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        id: data['id'] as String?,
        name: data['name'] as String?,
        email: data['email'] as String?,
        avatar: data['avatar'] as String?,
        document: data['document'] as String?,
        carPlate: data['car_plate'] as String?,
        carPhoto: data['car_photo'] as String?,
        carModel: data['car_model'] as String?,
        carColor: data['car_color'] as String?,
        carDescription: data['car_description'] as String?,
        phoneNumber: data['phone_number'] as String?,
        licensePhoto: data['license_photo'] as String?,
        license: data['license'] as String?,
        rank: data['rank'] as String?,
        observation: data['observation'] as String?,
        isDriver: data['is_driver'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar': avatar,
        'document': document,
        'car_plate': carPlate,
        'car_photo': carPhoto,
        'car_model': carModel,
        'car_color': carColor,
        'car_description': carDescription,
        'phone_number': phoneNumber,
        'license_photo': licensePhoto,
        'license': license,
        'rank': rank,
        'observation': observation,
        'is_driver': isDriver,
      };

  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? document,
    String? carPlate,
    String? carPhoto,
    String? carModel,
    String? carColor,
    String? carDescription,
    String? phoneNumber,
    String? licensePhoto,
    String? license,
    String? rank,
    String? observation,
    String? isDriver,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      document: document ?? this.document,
      carPlate: carPlate ?? this.carPlate,
      carPhoto: carPhoto ?? this.carPhoto,
      carModel: carModel ?? this.carModel,
      carColor: carColor ?? this.carColor,
      carDescription: carDescription ?? this.carDescription,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      licensePhoto: licensePhoto ?? this.licensePhoto,
      license: license ?? this.license,
      rank: rank ?? this.rank,
      observation: observation ?? this.observation,
      isDriver: isDriver ?? this.isDriver,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatar,
        document,
        carPlate,
        carPhoto,
        carModel,
        carColor,
        carDescription,
        phoneNumber,
        licensePhoto,
        license,
        rank,
        observation,
        isDriver,
      ];
}
