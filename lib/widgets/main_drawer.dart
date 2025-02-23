import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:miscratch/controlers/scratch_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> aboutBoxChildren = <Widget>[
      const SizedBox(height: 24),
      RichText(
        text: const TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: 'Esta aplicación es un verificador de Saldo '
                    'para las tarjetas desechables de combustible. '
                    'Adicionalmente usted podrá comprobar también el '
                    'listado de operaciones realizado con una tarjeta. ',
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    ];

    return GetBuilder<ScratchController>(
        init: ScratchController(),
        builder: (_) {
          return Drawer(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xff2d3436),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: null,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            const Color(0xffe74c3c).withOpacity(0.4),
                            BlendMode.dstATop),
                        image: const AssetImage("assets/images/pump.jpg"),
                        fit: BoxFit.cover,
                      ),
                      color: const Color(0xff3498db),
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.elliptical(90, 70)),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.chrome_reader_mode,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Sitio Web CIMEX',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => {Get.back(), ("http://www.cimex.cu")},
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Número Único',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () =>
                        {Get.back(), launchUrl("tel://80000724" as Uri)},
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Atención al Cliente',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => {
                      Get.back(),
                      launchUrl(
                          "mailto:atencionalcliente@cimex.com.cu?subject=Tarjeta Desechable"
                              as Uri)
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Soporte a la Aplicación',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => {
                      Get.back(),
                      launchUrl(
                          "mailto:soporte.datacimex@cimex.com.cu?subject=Tarjeta Desechable"
                              as Uri)
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Acerca de Aplicación',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => {
                      Get.back(),
                      showAboutDialog(
                        context: context,
                        applicationIcon: const Image(
                            width: 50,
                            height: 50,
                            image: AssetImage("assets/icon/icon.jpg")),
                        applicationName: _.appName,
                        applicationVersion: _.version,
                        applicationLegalese: '\u{a9} 2021 Datacimex',
                        children: aboutBoxChildren,
                      ),
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Salir',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => {Get.back(), SystemNavigator.pop()},
                  ),
                ],
              ),
            ),
          );
        });
  }
}
