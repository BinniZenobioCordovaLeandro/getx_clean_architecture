import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/repositories/abstract_session_repository.dart';

class VerifySessionUsecase {
  final AbstractSessionRepository _abstractSessionRepository;

  VerifySessionUsecase({
    required AbstractSessionRepository? abstractSessionRepository,
  })  : assert(abstractSessionRepository != null),
        _abstractSessionRepository = abstractSessionRepository!;

  Future<AbstractSessionEntity> call() =>
      _abstractSessionRepository.verifySession();
}
