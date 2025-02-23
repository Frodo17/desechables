import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controlers/scratch_controller.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScratchController>(
      init: ScratchController(),
      id: 'balance',
      builder: (_) {
        final apiresponse = _.apiresponse;
        final saldoVisible = _.saldoVisible;
        final clearPin = _.clearPin;
        final percent = (double.parse(apiresponse['importe']) * 100) /
            double.parse(apiresponse['valor']);

        return Container(
          decoration: BoxDecoration(
            color: apiresponse['estado'] == 2
                ? const Color(0xffe74c3c)
                : const Color(0xff0097e6),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.account_balance_wallet_outlined),
                          Text(
                            ' Saldo',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Flexible(
                        child: saldoVisible
                            ? Text(
                                '\$ ${apiresponse['importe']}',
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                                maxLines: 2,
                              )
                            : const Text(
                                '\$ ****.**',
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Valor: \$ ${apiresponse['valor']}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Vence: ${apiresponse['vencimiento']}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const Divider(thickness: 2),
                      Wrap(
                        spacing: 10,
                        children: [
                          Tooltip(
                            message: 'Oculta o muestra el Saldo',
                            child: IconButton(
                              onPressed: () {
                                _.setSaldoVisible();
                                if (kDebugMode) {
                                  print(saldoVisible);
                                }
                              },
                              icon: const Icon(Icons.remove_red_eye),
                            ),
                          ),
                          Tooltip(
                            message: 'Muestra QR para ser Consumido',
                            child: IconButton(
                              onPressed: () {
                                if (saldoVisible) {
                                  _.setSaldoVisible();
                                }
                                Get.dialog(
                                  SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        QrImageView(
                                          data: clearPin,
                                          version: QrVersions.auto,
                                          size: 200.0,
                                          backgroundColor: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.qr_code),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: CircularPercentIndicator(
                  radius: MediaQuery.of(context).size.width * 0.2,
                  lineWidth: 10.0,
                  percent: percent,
                  center: apiresponse['estado'] == 2
                      ? const Text(
                          'Consumida',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      : Text(
                          '${percent.toStringAsFixed(2)} %',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                  progressColor: Colors.pink,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
