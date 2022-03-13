import 'package:pickpointer/packages/user_package/data/models/user_model.dart';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/repositories/abstract_user_repository.dart';

class FirebaseUserDatasource implements AbstractUserRepository {
  FirebaseUserDatasource();

  @override
  Future<List<AbstractUserEntity>>? getUsers() {
    return Future.value(<AbstractUserEntity>[
      const UserModel(
        id: '1',
        name: 'John Doe',
        avatar: 'https://www.niemanlab.org/images/Greg-Emerson-edit-2.jpg',
        carPlate: 'K069-CWD',
        carPhoto:
            'https://www.motorshow.me/uploadImages/GalleryPics/295000/B295521-2021-Peugeot-2008-GT--5-.jpg',
        phoneNumber: '987654321',
        rank: '4',
        role: '0',
      ),
      const UserModel(
        id: '2',
        name: 'billy',
      ),
    ]);
  }

  @override
  Future<List<AbstractUserEntity>>? getUsersByName({
    required String userName,
  }) {
    return null;
  }

  @override
  Future<AbstractUserEntity>? getUser({
    required int userId,
  }) {
    return null;
  }
}
