import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/repositories/abstract_session_repository.dart';

class SessionRepository implements AbstractSessionRepository {
  final AbstractSessionRepository _abstractSessionRepository;

  SessionRepository({
    required AbstractSessionRepository? abstractSessionRepository,
  })  : assert(abstractSessionRepository != null),
        _abstractSessionRepository = abstractSessionRepository!;

  @override
  Future<AbstractSessionEntity> verifySession() {
    return _abstractSessionRepository.verifySession();
  }

  @override
  AbstractSessionEntity createSession() {
    return _abstractSessionRepository.createSession();
  }

  @override
  Future<AbstractSessionEntity?> getSession() {
    return _abstractSessionRepository.getSession();
  }

  @override
  Future<AbstractSessionEntity> setSession({
    required AbstractSessionEntity abstractSessionEntity,
  }) {
    return _abstractSessionRepository.setSession(
      abstractSessionEntity: abstractSessionEntity,
    );
  }

  @override
  Future<AbstractSessionEntity> deleteSession() {
    return _abstractSessionRepository.deleteSession();
  }

  @override
  Future<AbstractSessionEntity> updateSession({
    required AbstractSessionEntity abstractSessionEntity,
  }) {
    return _abstractSessionRepository.updateSession(
      abstractSessionEntity: abstractSessionEntity,
    );
  }
}
