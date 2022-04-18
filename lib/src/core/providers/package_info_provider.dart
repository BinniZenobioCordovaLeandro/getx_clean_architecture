import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoProvider {
  static PackageInfoProvider? _instance;
  PackageInfo? _packageInfo;

  static Future<PackageInfoProvider?> getInstance() async {
    _instance ??= PackageInfoProvider();
    _instance!._packageInfo ??= await PackageInfo.fromPlatform();
    return _instance;
  }

  getAppName() {
    return _packageInfo!.appName;
  }

  getPackageName() {
    return _packageInfo!.packageName;
  }

  getVersion() {
    return _packageInfo!.version;
  }

  getBuildNumber() {
    return _packageInfo!.buildNumber;
  }
  
  getBuildSignature() {
    return _packageInfo!.buildSignature;
  }

  getFullVersion() {
    return getVersion() + '+' + getBuildNumber();
  }
}
