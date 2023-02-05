import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickpointer/src/core/helpers/launcher_link_helper.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/expandable_fab_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/features/consolidate_position_feature/views/consolidate_position_page.dart';
import 'package:pickpointer/src/features/home_controller.dart';
import 'package:pickpointer/src/features/route_feature/views/routes_page.dart';
import 'package:pickpointer/src/features/user_feature/views/sign_in_user_page.dart';
import 'package:pickpointer/src/features/user_feature/views/user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = HomeController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: ScaffoldWidget(
          appBar: AppBarWidget(
            title: 'PickPointer',
            actions: [
              Center(
                child: TextWidget(
                  'v${homeController.version.value}',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 100,
                child: TextButton.icon(
                  onPressed: () async {
                    if (homeController.isSigned.value == false) {
                      await homeController.verifySession();
                    }
                    if (homeController.isSigned.value == true) {
                      Get.to(
                        () => const UserPage(),
                        arguments: {},
                      );
                    } else {
                      Get.to(
                        () => const SignInUserPage(),
                      );
                    }
                  },
                  icon: Icon(
                    homeController.isSigned.value == false
                        ? Icons.login_outlined
                        : Icons.co_present_outlined,
                    color:
                        Theme.of(context).appBarTheme.actionsIconTheme?.color,
                  ),
                  label: Center(
                    child: TextWidget(
                      homeController.isSigned.value == false
                          ? 'Login'
                          : 'Perfil',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              )
            ],
            bottom: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(
                  text: 'Resumen',
                ),
                Tab(
                  text: 'Mapa',
                ),
              ],
            ),
          ),
          floatingActionButton: ExpandableFab(
            distance: 80.0,
            children: [
              ActionButton(
                icon: const Icon(
                  Icons.mail_outline_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  LauncherLinkHelper launcherLinkHelper = LauncherLinkHelper(
                    url: 'pickpointer@gmail.com',
                    isMail: true,
                  );
                  launcherLinkHelper.sendEmail();
                },
              ),
              ActionButton(
                icon: const Icon(
                  Icons.facebook_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  LauncherLinkHelper launcherLinkHelper = LauncherLinkHelper(
                    url: 'https://m.me/100085260664181',
                  );
                  launcherLinkHelper.launchInBrowser();
                },
              ),
              ActionButton(
                icon: const Icon(
                  Icons.tiktok_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  LauncherLinkHelper launcherLinkHelper = LauncherLinkHelper(
                    url: 'https://tiktok.com/@pickpointer',
                  );
                  launcherLinkHelper.launchInBrowser();
                },
              ),
            ],
          ),
          body: const TabBarView(
            children: [
              ConsolidatePositionPage(),
              RoutesPage(),
            ],
          ),
        ),
      );
    });
  }
}
