import 'package:image_picker/image_picker.dart';

class MediaPickerProvider {
  static MediaPickerProvider? _instance;
  ImagePicker? _picker;

  static MediaPickerProvider? getInstance() {
    _instance ??= MediaPickerProvider();
    _instance!._picker ??= ImagePicker();
    return _instance;
  }

  Future<String?> _pickImage({
    required ImageSource source,
  }) {
    Future<String?> futureString =
        _picker!.pickImage(source: source).then((XFile? xFile) {
      if (xFile?.name != null) return xFile?.path;
      return null;
    });
    return futureString;
  }

  Future<String?> _pickVideo({
    required ImageSource source,
  }) {
    Future<String?> futureString =
        _picker!.pickVideo(source: source).then((XFile? xFile) {
      if (xFile?.name != null) return xFile?.path;
      return null;
    });
    return futureString;
  }

  Future<String?> getGalleryImage() {
    return _pickImage(source: ImageSource.gallery);
  }

  Future<String?> getCameraImage() {
    return _pickImage(source: ImageSource.camera);
  }

  Future<String?> getGalleryVideo() {
    return _pickVideo(source: ImageSource.gallery);
  }

  Future<String?> getCameraVideo() {
    return _pickVideo(source: ImageSource.camera);
  }

  Future<List<String?>?> getMultiImage() {
    Future<List<String?>?> futureListString =
        _picker!.pickMultiImage().then((List<XFile>? listXFile) {
      if (listXFile != null && listXFile.isNotEmpty) {
        List<String?> listPaths = [];
        for (var xFile in listXFile) {
          listPaths.add(xFile.path);
        }
        return listPaths;
      }
      return null;
    });
    return futureListString;
  }
}
