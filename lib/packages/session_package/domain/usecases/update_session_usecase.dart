import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/repositories/abstract_session_repository.dart';

class UpdateSessionUsecase {
  final AbstractSessionRepository _abstractSessionRepository;
  UpdateSessionUsecase({
    required AbstractSessionRepository? abstractSessionRepository,
  })  : assert(abstractSessionRepository != null),
        _abstractSessionRepository = abstractSessionRepository!;

  Future<AbstractSessionEntity> call({
    required AbstractSessionEntity abstractSessionEntity,
  }) =>
      _abstractSessionRepository.updateSession(
        abstractSessionEntity: abstractSessionEntity,
      );
}
