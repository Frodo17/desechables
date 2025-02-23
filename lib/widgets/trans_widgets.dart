import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miscratch/controlers/scratch_controller.dart';

class TransWidget extends StatelessWidget {
  const TransWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScratchController>(
        init: ScratchController(),
        id: 'trans',
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
                    "Transferencias",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  trailing: Tooltip(
                      message:
                          'En transferencias salientes hace referencia al monto transferido. En transferencias entrantes hace referencia al saldo de la tarjeta recargada posterior a la transferencia. Puede presionar sobre el Icono de la transferencia para mayor información.',
                      child: Icon(Icons.info_outline, color: Colors.white70)),
                ),
                const Divider(
                  thickness: 2.0,
                ),
                Expanded(
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _.transfers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: ListTile(
                            isThreeLine: true,
                            leading: _.transfers[index].destino == _.serial
                                ? Tooltip(
                                    message:
                                        'El importe hace referencia al saldo de la tarjeta recargada posterior a la transferencia',
                                    child: Icon(
                                      Icons.change_circle_outlined,
                                      size: 32,
                                      color: Colors.green[300],
                                    ),
                                  )
                                : Tooltip(
                                    message:
                                        'El importe hace referencia al monto transferido a otra tarjeta.',
                                    child: Icon(
                                      Icons.change_circle_outlined,
                                      size: 32,
                                      color: Colors.red[400],
                                    ),
                                  ),
                            title: Text(_.transfers[index].fecha.toString(),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _.transfers[index].destino == _.serial
                                    ? Text(
                                        "Desde : ${_.transfers[index].origen}",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70))
                                    : Text(
                                        "Hacia : ${_.transfers[index].destino}",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70)),
                                Text("Terminal: ${_.transfers[index].telefono}",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white70)),
                              ],
                            ),
                            trailing: _.transfers[index].destino == _.serial
                                ? Text(
                                    "\$ ${_.transfers[index].importe}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green[300],
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "\$ ${_.transfers[index].importe}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red[400],
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        });
  }
}
