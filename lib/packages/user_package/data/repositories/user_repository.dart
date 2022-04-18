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
    required String userId,
  }) {
    return _abstractUserRepository!.getUser(userId: userId);
  }

  @override
  Future<bool>? userExists({
    required String userId,
  }) {
    return _abstractUserRepository!.userExists(userId: userId);
  }

  @override
  Future<AbstractUserEntity>? setUser({
    required AbstractUserEntity abstractUserEntity,
  }) {
    return _abstractUserRepository!
        .setUser(abstractUserEntity: abstractUserEntity);
  }

  @override
  Future<AbstractUserEntity>? updateUser({
    required AbstractUserEntity abstractUserEntity,
  }) {
    return _abstractUserRepository!
        .updateUser(abstractUserEntity: abstractUserEntity);
  }
}
