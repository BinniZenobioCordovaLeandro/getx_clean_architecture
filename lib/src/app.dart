import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/helpers/launcher_link_helper.dart';
import 'package:pickpointer/src/core/helpers/modal_bottom_sheet_helper.dart';
import 'package:pickpointer/src/core/providers/firebase_config_provider.dart';
import 'package:pickpointer/src/core/providers/firebase_notification_provider.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:pickpointer/src/core/providers/platform_provider.dart';
import 'package:pickpointer/src/core/util/version_util.dart';
import 'package:pickpointer/src/core/enums/platform_enum.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/routes_page.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final PlatformProvider? platformProvider = PlatformProvider.getInstance();

  final FirebaseConfigProvider? firebaseConfigProvider =
      FirebaseConfigProvider.getInstance();

  final FirebaseNotificationProvider? firebaseNotificationProvider =
      FirebaseNotificationProvider.getInstance();

  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();

  bool validateVersion = false;

  @override
  void initState() {
    super.initState();
    firebaseNotificationProvider?.initialize();
    notificationProvider?.initialize();
    validateVersion = false;
  }

  verifyMinimalVersion(BuildContext context) {
    PlatformEnum? platformEnum =
        platformProvider?.getPlatformEnum(context: context);
    if (platformEnum == PlatformEnum.android ||
        platformEnum == PlatformEnum.iOS) {
      String? version =
          firebaseConfigProvider!.getMinimalVersion(platformEnum!);
      VersionUtil(version: version)
          .isUpdateRequired()
          .then((bool? isUpdateRequired) {
        if (isUpdateRequired == true) {
          ModalBottomSheetHelper(
            context: context,
            isDismissible: false,
            child: SizedBox(
              child: FractionallySizedBoxWidget(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: WrapWidget(
                    children: [
                      SizedBox(
                        child: TextWidget(
                          'Nueva version disponible',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const SizedBox(
                        child: TextWidget(
                            "Hemos mejorado para tí, es por ello que ahora tenemos una nueva version de la app.\n\nPor favor actualiza"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            childFooter: SizedBox(
                child: FractionallySizedBoxWidget(
              child: ElevatedButtonWidget(
                title: 'Ir a actualizar',
                onPressed: () {
                  LauncherLinkHelper launcherLinkHelper =
                      LauncherLinkHelper(url: platformEnum.link!);
                  if (platformEnum == PlatformEnum.android) {
                    launcherLinkHelper.launchInBrowser();
                  } else if (platformEnum == PlatformEnum.iOS) {
                    launcherLinkHelper.launchUniversalLinkIos();
                  }
                },
              ),
            )),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!validateVersion) {
      verifyMinimalVersion(context);
      setState(() {
        validateVersion = true;
      });
    }
    return const RoutesPage();
  }
}
