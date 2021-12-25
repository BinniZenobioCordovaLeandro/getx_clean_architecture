import 'package:equatable/equatable.dart';

abstract class AbstractUserEntity extends Equatable {
  final String? id;
  final String? name;

  const AbstractUserEntity({
    this.id,
    this.name,
  });
}
