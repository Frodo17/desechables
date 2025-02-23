import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miscratch/controlers/scratch_controller.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final FocusNode _serialFocus = FocusNode();

  final FocusNode _pinFocus = FocusNode();

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScratchController>(
        init: ScratchController(),
        builder: (_) {
          return Form(
              key: _.formKey,
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                        minWidth: MediaQuery.of(context).size.width * 0.8),
                    child: TextFormField(
                      controller: _.serialTxt,
                      focusNode: _serialFocus,
                      maxLength: 13,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (text) {
                        _serialFocus.unfocus();
                        FocusScope.of(context).requestFocus(_pinFocus);
                      },
                      validator: (text) {
                        if (text!.isNotEmpty && text.length == 13) {
                          _.setSerial(text);
                          return null;
                        }
                        return "Inserte un número de serie válido.";
                      },
                      style: const TextStyle(
                          color: Color(0xff192a56), fontSize: 18),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counter: const Offstage(),
                        fillColor: Colors.white,
                        filled: true,
                        errorStyle:
                            const TextStyle(fontSize: 20, color: Colors.red),
                        hintText: 'Número de Serie',
                        hintStyle: TextStyle(color: Colors.grey[700]),
                        prefixIcon: const Icon(
                          Icons.code,
                          color: Color(0xff192a56),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.qr_code,
                            color: Color(0xff192a56),
                          ),
                          onPressed: () => {_.scanSerial()},
                        ),
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                        minWidth: MediaQuery.of(context).size.width * 0.8),
                    child: TextFormField(
                      controller: _.pinTxt,
                      maxLength: 16,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (text) {
                        final isValid = _.formKey.currentState!.validate();
                        if (isValid) {
                          if (_.token != '') {
                            _.loginSubmit();
                          } else {
                            _.getToken();
                            _.loginSubmit();
                          }
                        }
                      },
                      focusNode: _pinFocus,
                      validator: (text) {
                        if (text!.isNotEmpty && text.length == 16) {
                          _.setPin(text);
                          return null;
                        }
                        return "Inserte un PIN válido.";
                      },
                      style: const TextStyle(
                          color: Color(0xff192a56), fontSize: 18),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counter: const Offstage(),
                        fillColor: Colors.white,
                        filled: true,
                        errorStyle:
                            const TextStyle(fontSize: 20, color: Colors.red),
                        hintText: 'Código Personal (PIN)',
                        hintStyle: TextStyle(color: Colors.grey[700]),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xff192a56),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.qr_code,
                            color: Color(0xff192a56),
                          ),
                          onPressed: () => {_.scanPin()},
                        ),
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Salvar los datos de esta tarjeta",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          if (value) {
                            Get.defaultDialog(
                                title: "Advertencia",
                                content: const Text(
                                  "Las credenciales para esta tarjeta serán almacenadas. El PIN no estará visible pero la tarjeta podría ser utilizada mediante el QR si una tercera persona obtiene su teléfono.",
                                ),
                                textConfirm: "Confirmar",
                                textCancel: "Cancelar",
                                buttonColor: const Color(0xff05c46b),
                                confirmTextColor: Colors.white,
                                cancelTextColor: Colors.red,
                                onConfirm: () {
                                  setState(() {
                                    isSwitched = true;
                                  });
                                  _.setSalvaTarjeta(true);
                                  Get.back();
                                });
                          } else {
                            setState(() {
                              isSwitched = false;
                            });
                            _.setSalvaTarjeta(false);
                          }
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                        minWidth: MediaQuery.of(context).size.width * 0.8),
                    child: MaterialButton(
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      onPressed: () {
                        if (kDebugMode) {
                          print('Submit Button');
                        }
                        final isValid = _.formKey.currentState!.validate();
                        if (isValid) {
                          if (_.token != '') {
                            _.loginSubmit();
                          } else {
                            _.getToken();
                            _.loginSubmit();
                          }
                        }
                      },
                      color: const Color(0xff05c46b),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      child: const Text(
                        "Consultar",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }
}
