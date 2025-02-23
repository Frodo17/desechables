import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:miscratch/controlers/scratch_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrDialog extends StatelessWidget {
  const QrDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScratchController>(
        init: ScratchController(),
        builder: (_) {
          return Dialog(
            child: SizedBox(
              width: 300,
              height: 600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  QrImageView(
                    backgroundColor: Colors.blue,
                    data: _.clearPin,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
