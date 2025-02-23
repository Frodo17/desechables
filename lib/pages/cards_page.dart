import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miscratch/controlers/scratch_controller.dart';
import 'package:miscratch/db/db_operations.dart';
import 'package:miscratch/widgets/main_drawer.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({Key? key}) : super(key: key);

  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final GlobalKey<ScaffoldState> _cardScaffold = GlobalKey<ScaffoldState>();

  var searchTxt = TextEditingController();
  var searchVisible = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScratchController>(
        init: ScratchController(),
        id: 'tarjetas',
        builder: (_) {
          return Scaffold(
            backgroundColor: const Color(0xff2d3436),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => {_cardScaffold.currentState?.openDrawer()},
                icon: const Icon(Icons.menu),
              ),
              backgroundColor: const Color(0xff1e272e),
              title: TextField(
                textInputAction: TextInputAction.done,
                onSubmitted: (text) async {
                  _.searchTarjetas(searchTxt.text);
                },
                controller: searchTxt,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(6),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: IconButton(
                      onPressed: () async {
                        searchTxt.clear();
                        _.searchTarjetas(searchTxt.text);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xff273c75),
                      )),
                  suffixIcon: IconButton(
                      onPressed: () async {
                        _.searchTarjetas(searchTxt.text);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Color(0xff273c75),
                      )),
                  hintText: "Tarjetas Guardadas",
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            key: _cardScaffold,
            drawer: const MainDrawer(),
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: const AssetImage("assets/images/abstract.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop)),
              ),
              child: ListView.builder(
                  itemCount: _.tarjetas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                        child: Card(
                          color: const Color(0xff34495e),
                          child: Column(
                            children: [
                              ListTile(

                                  //isThreeLine: true,
                                  leading: const Icon(
                                    Icons.credit_card,
                                    size: 30,
                                    color: Colors.white70,
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                            title: "Advertencia",
                                            content: Text(
                                              "${_.tarjetas[index].tarjeta + "¿Desea eliminar del listado la tarjeta "}?. Usted podrá usarla en otro momento.",
                                            ),
                                            textConfirm: "Confirmar",
                                            textCancel: "Cancelar",
                                            buttonColor:
                                                const Color(0xff05c46b),
                                            confirmTextColor: Colors.white,
                                            cancelTextColor: Colors.red,
                                            onConfirm: () {
                                              DbOperations.deleteTarjeta(
                                                  _.tarjetas[index].id);
                                              _.loadTarjetas();
                                              Get.back();
                                            });
                                      },
                                      icon: const Icon(Icons.delete_rounded,
                                          color: Colors.red)),
                                  title: Text(_.tarjetas[index].tarjeta,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70)),
                                  subtitle: const Text(
                                    "Tarjeta Desechable",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  onTap: () {
                                    _.setSerial(_.tarjetas[index].tarjeta);
                                    _.setPinCipher(_.tarjetas[index].pin64);
                                    _.setClearPin(_.tarjetas[index].pin);
                                    _.getToken();
                                    _.loginSubmit();
                                  }),
                            ],
                          ),
                        ));
                  }),
            ),
          );
        });
  }
}
