import 'dart:convert';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';

class SessionModel extends AbstractSessionEntity {
  @override
  final bool? isSigned;
  @override
  final bool? isDriver;
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
  @override
  final String? carPlate;
  @override
  final String? carPhoto;
  @override
  final String? carModel;
  @override
  final String? carColor;
  @override
  final String? phoneNumber;
  @override
  final String? rank;

  const SessionModel({
    this.isSigned,
    this.isDriver,
    this.idSessions,
    this.idUsers,
    this.name,
    this.email,
    this.avatar,
    this.carPlate,
    this.carPhoto,
    this.carModel,
    this.carColor,
    this.phoneNumber,
    this.rank,
  });

  factory SessionModel.fromMap(Map<String, dynamic> data) => SessionModel(
        isSigned: data['is_signed'] as bool?,
        isDriver: data['is_driver'] as bool?,
        idSessions: data['id_sessions'] as String?,
        idUsers: data['id_users'] as String?,
        name: data['name'] as String?,
        email: data['email'] as String?,
        avatar: data['avatar'] as String?,
        carPlate: data['car_plate'] as String?,
        carPhoto: data['car_photo'] as String?,
        carModel: data['car_model'] as String?,
        carColor: data['car_color'] as String?,
        phoneNumber: data['phone_number'] as String?,
        rank: data['rank'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'is_signed': isSigned,
        'is_driver': isDriver,
        'id_sessions': idSessions,
        'id_users': idUsers,
        'name': name,
        'email': email,
        'avatar': avatar,
        'car_plate': carPlate,
        'car_photo': carPhoto,
        'car_model': carModel,
        'car_color': carColor,
        'phone_number': phoneNumber,
        'rank': rank,
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
    bool? isDriver,
    String? idSessions,
    String? idUsers,
    String? name,
    String? email,
    String? avatar,
    String? carPlate,
    String? carPhoto,
    String? carModel,
    String? carColor,
    String? phoneNumber,
    String? rank,
  }) {
    return SessionModel(
      isSigned: isSigned ?? this.isSigned,
      isDriver: isDriver ?? this.isDriver,
      idSessions: idSessions ?? this.idSessions,
      idUsers: idUsers ?? this.idUsers,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      carPlate: carPlate ?? this.carPlate,
      carPhoto: carPhoto ?? this.carPhoto,
      carModel: carModel ?? this.carModel,
      carColor: carColor ?? this.carColor,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      rank: rank ?? this.rank,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [isSigned, idSessions, idUsers, name, email, avatar, carPlate, carPhoto, phoneNumber, rank];
}
