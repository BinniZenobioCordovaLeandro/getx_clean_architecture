import 'package:pickpointer/src/core/providers/package_info_provider.dart';

class VersionUtil {
  final String version;

  VersionUtil({
    required this.version,
  });

  Future<bool?> isUpdateRequired() {
    return PackageInfoProvider.getInstance()
        .then((PackageInfoProvider? packageInfoProvider) {
      if (packageInfoProvider != null) {
        String localVersion = packageInfoProvider.getVersion();
        int appVersionInt = versionToInt(localVersion);
        int minimalVersion = versionToInt(version);
        return minimalVersion > appVersionInt;
      }
      return false;
    });
  }

  int versionToInt(String version) {
    final List<String> vList = version.split('.');
    String vString = '';
    for (var i = 0; i < vList.length; i++) {
      vString += vList[i].padLeft(4, "0");
    }
    return int.parse(vString);
  }
}
