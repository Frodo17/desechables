import 'package:badges/badges.dart' as badges;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:miscratch/controlers/scratch_controller.dart';

class ChargePage extends StatelessWidget {
  const ChargePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScratchController>(
        id: 'recarga',
        init: ScratchController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                        leading: Icon(Icons.input_rounded),
                        title: Text('Recargar tarjeta')),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Text(
                            'PIN de la tarjeta desechable desde la cual va a transferir su saldo.',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Por su seguridad los pines no seran visualizados en ningun momento',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Form(
                                  key: _.formKey1,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                minWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7),
                                            child: TextFormField(
                                              controller: _.pinTxt,
                                              maxLength: 16,
                                              textInputAction:
                                                  TextInputAction.done,
                                              onFieldSubmitted: (text) {
                                                _.formKey.currentState
                                                    ?.validate();
                                                if (kDebugMode) {
                                                  print(_.pinArray);
                                                }
                                              },
                                              style: const TextStyle(
                                                  color: Color(0xff192a56),
                                                  fontSize: 18),
                                              obscureText: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                counter: const Offstage(),
                                                fillColor: Colors.white,
                                                filled: true,
                                                errorStyle: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red),
                                                hintText:
                                                    'Código Personal (PIN)',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[700]),
                                                prefixIcon: const Icon(
                                                  Icons.lock,
                                                  color: Color(0xff192a56),
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: const Icon(
                                                    Icons.qr_code,
                                                    color: Color(0xff192a56),
                                                  ),
                                                  onPressed: () =>
                                                      {_.scanPin()},
                                                ),
                                                labelStyle: TextStyle(
                                                    color: Colors.grey[700]),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _.formKey.currentState
                                                  ?.validate();
                                              if (kDebugMode) {
                                                print(_.pinArray);
                                              }
                                              _.pinTxt.clear();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: const CircleBorder(),
                                                padding:
                                                    const EdgeInsets.all(12),
                                                backgroundColor:
                                                    const Color(0xff05c46b)),
                                            child:
                                                const Icon(Icons.arrow_forward),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      _.pinArray.isNotEmpty
                                          ? const Text(
                                              "Cuando termine de agregar las tarjetas que utilizara en la recarga, debe presionar el boton recargar.")
                                          : const Text(
                                              "Debe agregar al menos una tarjeta a la lista de recarga"),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                minWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6),
                                            child: Row(
                                              children: [
                                                Tooltip(
                                                  message:
                                                      "Limpiar la lista de recarga.",
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      _.pinArray.clear();
                                                      _.pinTxt.clear();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape:
                                                            const CircleBorder(),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        backgroundColor:
                                                            Colors.red),
                                                    child: const Icon(
                                                      Icons.clear,
                                                      size: 32,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Tooltip(
                                                  message:
                                                      "Limpiar la lista de recarga.",
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      if (kDebugMode) {
                                                        print('Submit Button');
                                                      }
                                                      if (kDebugMode) {
                                                        print(_.pinArray
                                                            .join(","));
                                                      }
                                                      //_.joinCard();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape:
                                                            const CircleBorder(),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        backgroundColor:
                                                            Colors.green),
                                                    child: _.pinArray.isNotEmpty
                                                        ? badges.Badge(
                                                            badgeContent: Text(
                                                              _.pinArray.length
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18),
                                                            ),
                                                            child: const Icon(
                                                              Icons
                                                                  .input_rounded,
                                                              color: Colors
                                                                  .white70,
                                                              size: 32,
                                                            ),
                                                          )
                                                        : const badges.Badge(
                                                            badgeContent: Text(
                                                              "0",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            child: Icon(
                                                              Icons
                                                                  .input_rounded,
                                                              color: Colors
                                                                  .white70,
                                                              size: 32,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )),
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
