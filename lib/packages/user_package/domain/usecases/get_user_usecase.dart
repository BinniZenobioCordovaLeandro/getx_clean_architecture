import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/repositories/abstract_user_repository.dart';

class GetUserUsecase {
  final AbstractUserRepository _abstractUserRepository;

  GetUserUsecase({
    required AbstractUserRepository? abstractUserRepository,
  })  : assert(abstractUserRepository != null),
        _abstractUserRepository = abstractUserRepository!;

  Future<AbstractUserEntity>? call({
    required int userId,
  }) =>
      _abstractUserRepository.getUser(
        userId: userId,
      );
}
