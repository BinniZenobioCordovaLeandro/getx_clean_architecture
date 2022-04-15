import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickpointer/packages/user_package/data/models/user_model.dart';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/repositories/abstract_user_repository.dart';

class FirebaseUserDatasource implements AbstractUserRepository {
  CollectionReference? users;

  FirebaseUserDatasource() {
    users = FirebaseFirestore.instance.collection('c_users');
  }

  @override
  Future<List<AbstractUserEntity>>? getUsers() {
    return users?.get().then((snapshot) {
      List<AbstractUserEntity> users = [];
      for (DocumentSnapshot user in snapshot.docs) {
        users.add(UserModel.fromMap(user.data() as Map<String, dynamic>));
      }
      return users;
    });
  }

  @override
  Future<List<AbstractUserEntity>>? getUsersByName({
    required String userName,
  }) {
    return users
        ?.where('name', isEqualTo: userName)
        .orderBy('created_at')
        .get()
        .then((snapshot) {
      List<AbstractUserEntity> users = [];
      for (DocumentSnapshot user in snapshot.docs) {
        users.add(UserModel.fromMap(user.data() as Map<String, dynamic>));
      }
      return users;
    });
  }

  @override
  Future<AbstractUserEntity>? getUser({
    required String userId,
  }) {
    return users?.doc(userId).get().then((snapshot) {
      return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  @override
  Future<bool>? userExists({
    required String userId,
  }) {
    return users?.doc(userId).get().then((snapshot) {
      return snapshot.exists;
    });
  }

  @override
  Future<AbstractUserEntity>? setUser({
    required AbstractUserEntity abstractUserEntity,
  }) {
    final UserModel userModel = abstractUserEntity as UserModel;
    return users
        ?.doc(abstractUserEntity.id)
        .set(userModel.toMap(), SetOptions(merge: true))
        .then((value) => abstractUserEntity);
  }

  @override
  Future<AbstractUserEntity>? updateUser({
    required AbstractUserEntity abstractUserEntity,
  }) {
    final UserModel userModel = abstractUserEntity as UserModel;
    return users
        ?.doc(abstractUserEntity.id)
        .update(userModel.toMap())
        .then((value) {
      return userModel;
    });
  }
}
