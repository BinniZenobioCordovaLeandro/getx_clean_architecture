import 'package:equatable/equatable.dart';

abstract class AbstractSessionEntity extends Equatable {
  final bool? isSigned;
  final bool? isDriver;
  final String? idSessions;
  final String? idUsers;

  const AbstractSessionEntity({
    this.isSigned,
    this.isDriver,
    this.idSessions,
    this.idUsers,
  });
}
