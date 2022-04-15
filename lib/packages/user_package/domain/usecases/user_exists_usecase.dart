import 'package:pickpointer/packages/user_package/domain/repositories/abstract_user_repository.dart';

class UserExistsUsecase {
  final AbstractUserRepository _abstractUserRepository;

  UserExistsUsecase({
    required AbstractUserRepository? abstractUserRepository,
  })  : assert(abstractUserRepository != null),
        _abstractUserRepository = abstractUserRepository!;

  Future<bool>? call({
    required String userId,
  }) =>
      _abstractUserRepository.userExists(
        userId: userId,
      );
}
