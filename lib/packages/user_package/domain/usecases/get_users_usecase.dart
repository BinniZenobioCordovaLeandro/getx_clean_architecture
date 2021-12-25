import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/repositories/abstract_user_repository.dart';

class GetUsersUsecase {
  final AbstractUserRepository _abstractUserRepository;

  GetUsersUsecase({
    required AbstractUserRepository? abstractUserRepository,
  })  : assert(abstractUserRepository != null),
        _abstractUserRepository = abstractUserRepository!;

  Future<List<AbstractUserEntity>>? call() =>
      _abstractUserRepository.getUsers();
}
