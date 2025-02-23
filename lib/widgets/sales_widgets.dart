import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miscratch/controlers/scratch_controller.dart';

class SalesWidget extends StatelessWidget {
  const SalesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScratchController>(
        init: ScratchController(),
        id: 'sales',
        builder: (_) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: const Color(0xff34495e),
                borderRadius: BorderRadius.circular(25)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  leading: Icon(Icons.list, color: Colors.white70),
                  title: Text(
                    "Operaciones",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  trailing: Tooltip(
                      message:
                          'Muestra ventas y devoluciones. El importe responde al valor de la operación listada.',
                      child: Icon(Icons.info_outline, color: Colors.white70)),
                ),
                const Divider(
                  thickness: 2.0,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _.operations.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: ListTile(
                            leading: _.operations[index].tipo == "sale"
                                ? Icon(
                                    Icons.arrow_circle_down,
                                    size: 32,
                                    color: Colors.red[400],
                                  )
                                : Icon(
                                    Icons.arrow_circle_up,
                                    size: 32,
                                    color: Colors.green[300],
                                  ),
                            title: Text(_.operations[index].fecha.toString(),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("No OP: ${_.operations[index].operacion}",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white70)),
                                Text("Terminal: ${_.operations[index].pos}",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white70)),
                              ],
                            ),
                            trailing: _.operations[index].tipo == "sale"
                                ? Text(
                                    "\$ ${_.operations[index].importe}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red[400],
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "\$ ${_.operations[index].importe}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green[300],
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }
}
