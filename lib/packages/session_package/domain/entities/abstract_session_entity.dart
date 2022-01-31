import 'package:equatable/equatable.dart';

abstract class AbstractSessionEntity extends Equatable {
  final bool? isSigned;
  final String? idSessions;
  final String? idUsers;

  const AbstractSessionEntity({
    this.isSigned,
    this.idSessions,
    this.idUsers,
  });
}
