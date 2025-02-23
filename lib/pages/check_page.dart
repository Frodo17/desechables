import 'package:flutter/material.dart';
import 'package:miscratch/widgets/form_widget.dart';

class CheckPage extends StatelessWidget {
  const CheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var serialTxt = TextEditingController();
    // ignore: unused_local_variable
    var pinTxt = TextEditingController();

    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage("assets/images/abstract.png"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      const Color(0xff192a56).withOpacity(0.2),
                      BlendMode.dstATop)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.07),
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: const Center(
                    child: Image(
                      image: AssetImage("assets/images/pump.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormWidget(),
                        ])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
