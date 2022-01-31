import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';

abstract class AbstractSessionRepository {
  Future<AbstractSessionEntity> verifySession();

  AbstractSessionEntity createSession();

  Future<AbstractSessionEntity?> getSession();

  Future<AbstractSessionEntity> setSession({
    required AbstractSessionEntity abstractSessionEntity,
  });

  Future<AbstractSessionEntity> deleteSession();

  Future<AbstractSessionEntity> updateSession({
    required AbstractSessionEntity abstractSessionEntity,
  });
}
