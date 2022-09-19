import 'package:permission_handler/permission_handler.dart';

class PermissionProvider {
  List<Permission> listPermission = [];
  Map<Permission, PermissionStatus> mapPermissionPermissionStatus = {};

  PermissionProvider({
    calendar = false,
    camera = false,
    contacts = false,
    location = false,
    locationAlways = false,
    locationWhenInUse = false,
    mediaLibrary = false,
    microphone = false,
    phone = false,
    photos = false,
    photosAddOnly = false,
    reminders = false,
    sensors = false,
    sms = false,
    speech = false,
    storage = false,
    ignoreBatteryOptimizations = false,
    notification = false,
    accessMediaLocation = false,
    activityRecognition = false,
    unknown = false,
    bluetooth = false,
    manageExternalStorage = false,
    systemAlertWindow = false,
    requestInstallPackages = false,
    appTrackingTransparency = false,
    criticalAlerts = false,
    accessNotificationPolicy = false,
  }) {
    List<Permission> listPermission = [];
    if (calendar == true) listPermission.add(Permission.calendar);
    if (camera == true) listPermission.add(Permission.camera);
    if (contacts == true) listPermission.add(Permission.contacts);
    if (location == true) listPermission.add(Permission.location);
    if (locationAlways == true) listPermission.add(Permission.locationAlways);
    if (locationWhenInUse == true) {
      listPermission.add(Permission.locationWhenInUse);
    }
    if (mediaLibrary == true) listPermission.add(Permission.mediaLibrary);
    if (microphone == true) listPermission.add(Permission.microphone);
    if (phone == true) listPermission.add(Permission.phone);
    if (photos == true) listPermission.add(Permission.photos);
    if (photosAddOnly == true) listPermission.add(Permission.photosAddOnly);
    if (reminders == true) listPermission.add(Permission.reminders);
    if (sensors == true) listPermission.add(Permission.sensors);
    if (sms == true) listPermission.add(Permission.sms);
    if (speech == true) listPermission.add(Permission.speech);
    if (storage == true) listPermission.add(Permission.storage);
    if (ignoreBatteryOptimizations == true) {
      listPermission.add(Permission.ignoreBatteryOptimizations);
    }
    if (notification == true) listPermission.add(Permission.notification);
    if (accessMediaLocation == true) {
      listPermission.add(Permission.accessMediaLocation);
    }
    if (activityRecognition == true) {
      listPermission.add(Permission.activityRecognition);
    }
    if (unknown == true) listPermission.add(Permission.unknown);
    if (bluetooth == true) listPermission.add(Permission.bluetooth);
    if (manageExternalStorage == true) {
      listPermission.add(Permission.manageExternalStorage);
    }
    if (systemAlertWindow == true) {
      listPermission.add(Permission.systemAlertWindow);
    }
    if (requestInstallPackages == true) {
      listPermission.add(Permission.requestInstallPackages);
    }
    if (appTrackingTransparency == true) {
      listPermission.add(Permission.appTrackingTransparency);
    }
    if (criticalAlerts == true) listPermission.add(Permission.criticalAlerts);
    if (accessNotificationPolicy == true) {
      listPermission.add(Permission.accessNotificationPolicy);
    }
    this.listPermission = listPermission;
  }

  Future<Map<Permission, PermissionStatus>> request({
    List<Permission>? listPermission,
  }) {
    listPermission ??= this.listPermission;
    Future<Map<Permission, PermissionStatus>> mapPermissionPermissionStatus =
        listPermission.request().then(
      (Map<Permission, PermissionStatus> mapPermissionPermissionStatus) {
        this.mapPermissionPermissionStatus = mapPermissionPermissionStatus;
        return mapPermissionPermissionStatus;
      },
    );
    return mapPermissionPermissionStatus;
  }

  PermissionStatus validate({
    Map<Permission, PermissionStatus>? mapPermissionPermissionStatus,
  }) {
    mapPermissionPermissionStatus ??= this.mapPermissionPermissionStatus;
    int counter = 0;
    for (var i = 0; i < listPermission.length; i++) {
      print(mapPermissionPermissionStatus[listPermission[i]]);
      if (mapPermissionPermissionStatus[listPermission[i]]?.isGranted == true) {
        counter = counter + 1;
        if (counter >= listPermission.length) {
          return PermissionStatus.granted;
        }
      } else if (mapPermissionPermissionStatus[listPermission[i]]
              ?.isPermanentlyDenied ==
          true) {
        return PermissionStatus.permanentlyDenied;
      } else {
        return PermissionStatus.denied;
      }
    }
    return PermissionStatus.denied;
  }
}
