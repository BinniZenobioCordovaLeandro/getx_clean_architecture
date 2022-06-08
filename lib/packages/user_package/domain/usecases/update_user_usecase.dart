import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/repositories/abstract_user_repository.dart';

class UpdateUserUsecase {
  final AbstractUserRepository _abstractUserRepository;

  UpdateUserUsecase({
    required AbstractUserRepository? abstractUserRepository,
  })  : assert(abstractUserRepository != null),
        _abstractUserRepository = abstractUserRepository!;

  Future<AbstractUserEntity>? call({
    required AbstractUserEntity abstractUserEntity,
  }) =>
      _abstractUserRepository.updateUser(
          abstractUserEntity: abstractUserEntity);
}
