import 'dart:convert';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';

class SessionModel extends AbstractSessionEntity {
  @override
  final bool? isSigned;
  @override
  final bool? isDriver;
  @override
  final bool? isPhoneVerified;
  @override
  final String? idSessions;
  @override
  final String? idUsers;
  @override
  final bool? onRoad;
  @override
  final String? currentOfferId;
  @override
  final String? currentOrderId;
  @override
  final String? tokenMessaging;

  const SessionModel({
    this.isSigned,
    this.isDriver,
    this.isPhoneVerified,
    this.idSessions,
    this.idUsers,
    this.onRoad,
    this.currentOfferId,
    this.currentOrderId,
    this.tokenMessaging,
  });

  factory SessionModel.fromMap(Map<String, dynamic> data) => SessionModel(
        isSigned: data['is_signed'] as bool?,
        isDriver: data['is_driver'] as bool?,
        isPhoneVerified: data['is_phone_verified'] as bool?,
        idSessions: data['id_sessions'] as String?,
        idUsers: data['id_users'] as String?,
        onRoad: data['on_road'] as bool?,
        currentOfferId: data['current_offer_id'] as String?,
        currentOrderId: data['current_order_id'] as String?,
        tokenMessaging: data['token_messaging'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'is_signed': isSigned,
        'is_driver': isDriver,
        'is_phone_verified': isPhoneVerified,
        'id_sessions': idSessions,
        'id_users': idUsers,
        'on_road': onRoad,
        'current_offer_id': currentOfferId,
        'current_order_id': currentOrderId,
        'token_messaging': tokenMessaging,
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
    bool? isPhoneVerified,
    String? idSessions,
    String? idUsers,
    bool? onRoad,
    String? currentOfferId,
    String? currentOrderId,
    String? tokenMessaging,
  }) {
    return SessionModel(
      isSigned: isSigned ?? this.isSigned,
      isDriver: isDriver ?? this.isDriver,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      idSessions: idSessions ?? this.idSessions,
      idUsers: idUsers ?? this.idUsers,
      onRoad: onRoad ?? this.onRoad,
      currentOfferId: currentOfferId ?? this.currentOfferId,
      currentOrderId: currentOrderId ?? this.currentOrderId,
      tokenMessaging: tokenMessaging ?? this.tokenMessaging,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        isSigned,
        isDriver,
        isPhoneVerified,
        idSessions,
        idUsers,
        onRoad,
        currentOfferId,
        currentOrderId,
        tokenMessaging,
      ];
}
