import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:miscratch/controlers/scratch_controller.dart';
import 'package:miscratch/pages/cards_page.dart';

import 'check_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> paginas = [const CheckPage(), const CardsPage()];

    return GetBuilder<ScratchController>(
        init: ScratchController(),
        id: 'tabs',
        builder: (_) {
          return Scaffold(
            backgroundColor: const Color(0xff2d3436),
            body: paginas[_.tabCurrentIndex],
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: const Color(0xff1e272e),
                currentIndex: _.tabCurrentIndex,
                elevation: 8.0,
                items: const [
                  BottomNavigationBarItem(
                    label: "Consultar",
                    icon: Icon(Icons.check_box),
                  ),
                  BottomNavigationBarItem(
                      label: "Guardados", icon: Icon(Icons.list)),
                ],
                onTap: (index) {
                  _.setTabCurrentIntex(index);
                  if (kDebugMode) {
                    print(index);
                  }
                },
                type: BottomNavigationBarType.fixed,
                fixedColor: const Color(0xff05c46b),
                unselectedItemColor: Colors.blueGrey),
          );
        });
  }
}
