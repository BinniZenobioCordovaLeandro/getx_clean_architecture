import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/repositories/abstract_user_repository.dart';

class UserRepository implements AbstractUserRepository {
  final AbstractUserRepository? _abstractUserRepository;

  UserRepository({
    required AbstractUserRepository? abstractUserRepository,
  })  : assert(abstractUserRepository != null),
        _abstractUserRepository = abstractUserRepository;

  @override
  Future<List<AbstractUserEntity>>? getUsers() {
    return _abstractUserRepository!.getUsers();
  }

  @override
  Future<List<AbstractUserEntity>>? getUsersByName({
    required String userName,
  }) {
    return _abstractUserRepository!.getUsersByName(userName: userName);
  }

  @override
  Future<AbstractUserEntity>? getUser({
    required int userId,
  }) {
    return _abstractUserRepository!.getUser(userId: userId);
  }
}
