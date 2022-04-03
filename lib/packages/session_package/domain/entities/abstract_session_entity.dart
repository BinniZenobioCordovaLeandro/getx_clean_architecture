import 'package:equatable/equatable.dart';

abstract class AbstractSessionEntity extends Equatable {
  final bool? isSigned;
  final String? idSessions;
  final String? idUsers;
  final String? name;
  final String? email;
  final String? avatar;

  const AbstractSessionEntity({
    this.isSigned,
    this.idSessions,
    this.idUsers,
    this.name,
    this.email,
    this.avatar,
  });
}
