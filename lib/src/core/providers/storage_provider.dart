import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageProvider {
  // TODO: CREATE A STORAGE_PACKAGE to use BUCKET FOR SAVE THE RESOURCES. (AWS S3/ FStorage)
  static StorageProvider? _instance;

  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static StorageProvider? getInstance() {
    _instance ??= StorageProvider();
    return _instance;
  }

  String getExtensionFromPath(String path) {
    final regExp = RegExp(r'(?<=\.).{1,5}$');
    final match = regExp.firstMatch(path)!;
    return match[0]!;
  }

  String getNameFromPath(String path) {
    final regExpName = RegExp(r'(?<=/).{1,}\..{1,}$');
    final match = regExpName.firstMatch(path)!;
    return match[0] ?? 'pending';
  }

  Future<String> putFile(
    File file, {
    String? path = '',
    String? name,
    String? ext,
  }) async {
    String? fullReference = "$path/$name.$ext";
    print('fullReference: $fullReference');
    Reference reference = firebaseStorage.ref().child(fullReference);
    UploadTask uploadTask = reference.putFile(file);

    await uploadTask.whenComplete(() => null);

    return reference.getDownloadURL();
  }

  Future<String> putFileFromPath(
    String string, {
    String? directory = '',
    String? name,
  }) {
    print('string: $string');
    File file = File(string);
    return putFile(
      file,
      path: '/c_users/$directory',
      name: name,
      ext: getExtensionFromPath(string),
    );
  }
}
