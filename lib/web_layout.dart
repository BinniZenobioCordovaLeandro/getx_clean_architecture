import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickpointer/src/app.dart';
import 'package:pickpointer/src/core/helpers/launcher_link_helper.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_widget.dart';
import 'package:pickpointer/src/core/widgets/single_child_scroll_view_widget.dart';
import 'package:pickpointer/src/core/widgets/svg_or_image_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/video_player_widget.dart';
import 'package:pickpointer/src/features/user_feature/views/sign_in_user_page.dart';

class WebLayout extends StatelessWidget {
  const WebLayout({Key? key}) : super(key: key);

  Widget rowPresentation({
    Widget? child,
    String? urlSvgOrImage,
    String? idYoutuveVideo,
    double? verticalPadding = 100.0,
    String? background,
  }) {
    return Container(
      width: double.infinity,
      decoration: background != null
          ? BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  background,
                ),
              ),
            )
          : null,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding!,
            horizontal: 32,
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 15.0,
                      sigmaY: 15.0,
                    ),
                    blendMode: BlendMode.color,
                    child: Center(
                      child: child,
                    ),
                  ),
                ),
              ),
              if (urlSvgOrImage != null || idYoutuveVideo != null)
                const VerticalDivider(
                  width: 16,
                ),
              if (urlSvgOrImage != null)
                Flexible(
                  flex: 3,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 400,
                        minHeight: 200,
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: SvgOrImageWidget(
                            urlSvgOrImage: urlSvgOrImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (idYoutuveVideo != null)
                Flexible(
                  flex: 3,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 400,
                        minHeight: 200,
                      ),
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: VideoPlayerWidget(
                            initialVideoId: idYoutuveVideo,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget footer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      color: Theme.of(context).primaryColor,
      child: Center(
        child: TextWidget(
          'Hecho con inteligencia 🧠 por PickPointer',
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ScaffoldWidget(
            body: SingleChildScrollViewWidget(
              child: Column(
                children: [
                  rowPresentation(
                    background:
                        "https://img.freepik.com/fotos-premium/taxi-ciudad-nueva-york-color-amarillo-semaforo_42667-507.jpg?w=2040",
                    verticalPadding: 300,
                    child: Column(
                      children: [
                        const Divider(),
                        TextWidget(
                          'Para verdaderos conductores',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                        TextWidget(
                          'PICKPOINTER',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                        const Divider(),
                        SizedBox(
                          width: 300,
                          child: ElevatedButtonWidget(
                            title: 'Unete a nosotros',
                            onPressed: () {
                              Get.to(
                                () => const SignInUserPage(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  rowPresentation(
                    child: Column(
                      children: [
                        TextWidget(
                          'Sobre Nosotros',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const Divider(),
                        TextWidget(
                          'PickPointer,\nEs la aplicación inovadora en el mercado de rutas realizadas por autos.\nCon viajes rastreados geográficamente y conductores identificados.',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    urlSvgOrImage:
                        'https://img.freepik.com/fotos-premium/joven-taxista-macho-feliz-sienta-al-volante-taxi-muestra-como_170532-3255.jpg',
                  ),
                  rowPresentation(
                    background:
                        'https://img.freepik.com/fotos-premium/autos-estacionados-carretera_10541-812.jpg?w=1060',
                    child: Column(
                      children: [
                        TextWidget(
                          'Nuestros objetivos',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                        const Divider(),
                        TextWidget(
                          'PickPointer\nFue creado debido a la necesidad de una app\nque busca mejorar el servicio colaborativo.',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const Divider(),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Flexible(
                                child: CardWidget(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: TextWidget(
                                        'PROSPERIDAD SOCIAL',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const VerticalDivider(),
                              Flexible(
                                child: CardWidget(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: TextWidget(
                                        'CALIDAD DE VIDA',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const VerticalDivider(),
                              Flexible(
                                child: CardWidget(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: TextWidget(
                                        'CAPACITACION CONSTANTE',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const VerticalDivider(),
                              Flexible(
                                child: CardWidget(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: TextWidget(
                                        'OFERTA EQUILIBRADA',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  rowPresentation(
                    verticalPadding: 30,
                    child: Column(
                      children: [
                        TextWidget(
                          'Descarga PICKPOINTER APP',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const Divider(),
                        SizedBox(
                          width: double.infinity,
                          child: Flex(
                            direction: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => LauncherLinkHelper(
                                  url:
                                      "https://play.google.com/store/apps/details?id=com.pickpointer.app",
                                ).launchInBrowser(),
                                child: const SvgOrImageWidget(
                                  height: 90,
                                  width: 200,
                                  urlSvgOrImage:
                                      "https://d13xymm0hzzbsd.cloudfront.net/1/20200520/15900085160480.svg",
                                ),
                              ),
                              const VerticalDivider(),
                              InkWell(
                                onTap: () => LauncherLinkHelper(
                                  url: "https://apps.apple.com/app/id109315351",
                                ).launchInBrowser(),
                                child: const SvgOrImageWidget(
                                  height: 90,
                                  width: 200,
                                  urlSvgOrImage:
                                      "https://d13xymm0hzzbsd.cloudfront.net/1/20200520/15900085241838.svg",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  rowPresentation(
                    background:
                        'https://img.freepik.com/foto-gratis/elegante-taxista-cliente-coche-mascaras-medicas_23-2149149622.jpg',
                    child: Column(
                      children: [
                        TextWidget(
                          '¿Como funciona la APP?',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  rowPresentation(
                    verticalPadding: 20,
                    idYoutuveVideo: 'w_Qn07zg-Kk',
                    child: Column(
                      children: [
                        TextWidget(
                          'Conductor PICKPOINTER',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                  rowPresentation(
                    verticalPadding: 20,
                    idYoutuveVideo: 'b6F7M6Puxdg',
                    child: Column(
                      children: [
                        TextWidget(
                          'Pasajero PICKPOINTER',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                  rowPresentation(
                    verticalPadding: 10,
                    background:
                        'https://img.freepik.com/foto-gratis/borrosa-trafico-luz-senderos-camino-noche_1359-413.jpg',
                    child: Column(
                      children: [
                        TextWidget(
                          'Comienza a usar PICKPOINTER!',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxHeight: 500,
                          ),
                          child: const AspectRatio(
                            aspectRatio: 9 / 16,
                            child: App(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  rowPresentation(
                    verticalPadding: 20,
                    child: Column(
                      children: [
                        TextWidget(
                          'Siguenos en',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const Divider(),
                        Flex(
                          direction: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => LauncherLinkHelper(
                                url:
                                    "https://www.facebook.com/profile.php?id=100085260664181",
                              ).launchInBrowser(),
                              child: const SvgOrImageWidget(
                                height: 50,
                                width: 50,
                                urlSvgOrImage:
                                    "https://d13xymm0hzzbsd.cloudfront.net/1/20220816/16606907003177.webp",
                              ),
                            ),
                            const VerticalDivider(),
                            InkWell(
                              onTap: () => LauncherLinkHelper(
                                url:
                                    "https://www.youtube.com/channel/UCNhVUpNu3gOuhyG7R-sjxNw",
                              ).launchInBrowser(),
                              child: const SvgOrImageWidget(
                                height: 50,
                                width: 50,
                                urlSvgOrImage:
                                    "https://d13xymm0hzzbsd.cloudfront.net/1/20220816/16606907006301.webp",
                              ),
                            ),
                            const VerticalDivider(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  footer(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
