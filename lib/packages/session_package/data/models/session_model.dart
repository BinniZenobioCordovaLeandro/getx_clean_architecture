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
  final bool? onRoad;
  @override
  final String? currentOfferId;

  const SessionModel({
    this.isSigned,
    this.isDriver,
    this.idSessions,
    this.idUsers,
    this.onRoad,
    this.currentOfferId,
  });

  factory SessionModel.fromMap(Map<String, dynamic> data) => SessionModel(
        isSigned: data['is_signed'] as bool?,
        isDriver: data['is_driver'] as bool?,
        idSessions: data['id_sessions'] as String?,
        idUsers: data['id_users'] as String?,
        onRoad: data['on_road'] as bool?,
        currentOfferId: data['current_offer_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'is_signed': isSigned,
        'is_driver': isDriver,
        'id_sessions': idSessions,
        'id_users': idUsers,
        'on_road': onRoad,
        'current_offer_id': currentOfferId,
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
    bool? onRoad,
    String? currentOfferId,
  }) {
    return SessionModel(
      isSigned: isSigned ?? this.isSigned,
      isDriver: isDriver ?? this.isDriver,
      idSessions: idSessions ?? this.idSessions,
      idUsers: idUsers ?? this.idUsers,
      onRoad: onRoad ?? this.onRoad,
      currentOfferId: currentOfferId ?? this.currentOfferId,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props =>
      [isSigned, isDriver, idSessions, idUsers, currentOfferId, onRoad];
}
