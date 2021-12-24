import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';

abstract class AbstractUserRepository {
  Future<List<AbstractUserEntity>>? getUsers();

  Future<List<AbstractUserEntity>>? getUsersByName({
    required String userName,
  });

  Future<AbstractUserEntity>? getUser({
    required int userId,
  });
}
