import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:miscratch/controlers/scratch_controller.dart';
import 'package:miscratch/widgets/balance_widget.dart';
import 'package:miscratch/widgets/main_drawer.dart';
import 'package:miscratch/widgets/sales_widgets.dart';
import 'package:miscratch/widgets/trans_widgets.dart';

class SaldoPage extends StatefulWidget {
  const SaldoPage({super.key});

  @override
  State<SaldoPage> createState() => _SaldoPageState();
}

class _SaldoPageState extends State<SaldoPage> {
  final GlobalKey<ScaffoldState> _mainScaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScratchController>(
        id: 'operations',
        init: ScratchController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => {_mainScaffold.currentState?.openDrawer()},
                icon: const Icon(Icons.menu),
              ),
              title: const Text("Desechables"),
              actions: const [],
              backgroundColor: const Color(0xff1e272e),
            ),
            key: _mainScaffold,
            drawer: const MainDrawer(),
            backgroundColor: const Color(0xff2d3436),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      //height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                const AssetImage("assets/images/abstract.png"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                const Color(0xff192a56).withOpacity(0.2),
                                BlendMode.dstATop)),
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: const BalanceWidget()),
                          Column(
                            children: [
                              const Divider(
                                thickness: 2.0,
                              ),
                              const SizedBox(
                                height: 0.1,
                              ),
                              _.operations.isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(10),
                                      height: (_.operations.length.toDouble() *
                                              65) +
                                          100,
                                      child: const SalesWidget(),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(10),
                                      child: const ListTile(
                                        //tileColor: const Color(0xff0097e6),
                                        leading: Icon(
                                          Icons.info_outline,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          "Su tarjeta no posee operaciones.",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                              const Divider(
                                thickness: 2,
                              ),
                              //Transferencias
                              _.transfers.isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(10),
                                      height: (_.transfers.length.toDouble() *
                                              105) +
                                          100,
                                      child: const TransWidget(),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(10),
                                      child: const ListTile(
                                        //tileColor: const Color(0xff0067e6),
                                        leading: Icon(
                                          Icons.info_outline,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          "Su tarjeta no posee transferencias.",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
