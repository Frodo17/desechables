// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:http/io_client.dart';
import 'package:miscratch/db/db_operations.dart';
import 'package:miscratch/models/cards_model.dart';
import 'package:miscratch/models/refound_model.dart';
import 'package:miscratch/models/sales_model.dart';
import 'package:miscratch/models/transfer_model.dart';
import 'package:miscratch/pages/saldo_page.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class ScratchController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void onReady() async {
    super.onReady();
    checkConnect();
    loadTarjetas();
    _saldoVisible = true;
  }

  //Declaracion de variables
  bool _salvaTarjeta = false;
  bool _saldoVisible = false;
  int _tabCurrentIndex = 0;
  late String _serial,
      _pinOrigen,
      _pin,
      _pin64,
      _clearPin,
      _clearPinOrigen,
      _appName,
      _packageName,
      _version,
      _buildNumber,
      _token = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final _serialTxt = TextEditingController();
  final _pinTxt = TextEditingController();
  // ignore: unused_field
  var _apiresponse, _transresponse;
  late double _percent;
  List<RefoundModel> _refounds = <RefoundModel>[];
  List<SalesModel> _sales = <SalesModel>[];
  List<TransferModel> _transfers = <TransferModel>[];
  List _operations = [];
  final List<String> _pinArray = <String>[];
  List<Tarjeta> _tarjetas = <Tarjeta>[];

  //variables en tipo getx para ser leidas desde un controller
  int get tabCurrentIndex => _tabCurrentIndex;
  String get serial => _serial;
  String get pinOrigen => _pinOrigen;
  String get pin => _pin;
  String get pin64 => _pin64;
  String get clearPin => _clearPin;
  String get clearPinOrigen => _clearPinOrigen;
  String get appName => _appName;
  String get packageName => _packageName;
  String get version => _version;
  String get buildNumber => _buildNumber;
  GlobalKey<FormState> get formKey => _formKey;
  GlobalKey<FormState> get formKey1 => _formKey1;
  get serialTxt => _serialTxt;
  get pinTxt => _pinTxt;
  get apiresponse => _apiresponse;
  get token => _token;
  double get percent => _percent;
  List<SalesModel> get sales => _sales;
  List<RefoundModel> get refounds => _refounds;
  List<TransferModel> get transfers => _transfers;
  List get operations => _operations;
  List get pinArray => _pinArray;
  List get tarjetas => _tarjetas;
  bool get salvaTarjeta => _salvaTarjeta;
  bool get saldoVisible => _saldoVisible;

  //Funcion para cargar tarjetas de sqlite
  void loadTarjetas() async {
    _tarjetas = await DbOperations.tarjetas();
    if (kDebugMode) {
      print(_tarjetas);
    }
    update(['tarjetas']);
  }

  void setClearPin(String text) async {
    _clearPin = text;
  }

  //Funcion para buscar tarjetas de sqlite
  void searchTarjetas(String searchTxt) async {
    _tarjetas = await DbOperations.searchTarjeta(searchTxt);
    update(['tarjetas']);
  }

  //funcion para setear el serial
  void setSerial(String text) {
    _serial = text;
  }

  //funcion para setear el pin de la tarjeta de origen en recarga
  void setPinOrigen(String text) {
    _clearPinOrigen = text;
    if (kDebugMode) {
      print("Pin Claro: $_clearPinOrigen");
    }
    var inputBytes = utf8.encode(text);
    Digest sha512Result = sha512.convert(inputBytes);
    _pinOrigen = base64Encode(sha512Result.bytes);
  }

  //funcion mostrar u ocultar saldo
  void setSaldoVisible() {
    _saldoVisible = !_saldoVisible;
    update(['balance']);
  }

  //Funcion para setear el salvado de tarjetas
  void setSalvaTarjeta(bool option) {
    _salvaTarjeta = option;
    if (kDebugMode) {
      print(_salvaTarjeta);
    }
  }

  //funcion para refrescar el indice de la navegacion inferior
  void setTabCurrentIntex(int index) {
    _tabCurrentIndex = index;
    update(['tabs']);
  }

  //funcion para enviar un pin encryptandolo
  void setPin(String text) {
    _clearPin = text;

    var inputBytes = utf8.encode(text);
    Digest sha512Result = sha512.convert(inputBytes);
    _pin = base64Encode(sha512Result.bytes);
    _pin64 = _pin;
    if (kDebugMode) {
      print("Pin$_pin");
    }
  }

  //funcion para enviar un pin ya encryptado
  void setPinCipher(String text) {
    _pin = text;
    if (kDebugMode) {
      print('Pin Cifrado$_pin');
    }
  }

  //Funcion que comprueba si estamos conectados
  Future checkConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (kDebugMode) {
        print("Mobile Connected");
      }
      getToken();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (kDebugMode) {
        print("Wifi Connected");
      }
      getToken();
    } else {
      Get.snackbar(
          'Sin Conexión', "Debe conectarse a una red para acceder al servicio",
          icon: const Icon(
            Icons.signal_cellular_off,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  //Funcion que obtiene el token del WSO2ApiManager. En credenciales se pasa el ConsumerKey y Consumer Secret de WS02
  //Los datos pasados en credentials son falsos.
  Future getToken() async {
    String credentials =
        "C0NSUM3RK3Y:C0NSUM3RS3CR3T";
    String encoded = base64.encode(utf8.encode(credentials));

    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate, String host, int port) => true);

    try {
      final response = await http.post(
        Uri.parse('https://wso2am.cimex.com.cu/token'),
        client: http.IOClient(httpClient),
        headers: {
          'Authorization': 'Basic $encoded',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'grant_type': 'client_credentials'},
      );

      if (response.statusCode == 200) {
        _token = json.decode(response.body)['access_token'];
        if (kDebugMode) {
          print("Token: $_token");
        }
      } else {
        if (kDebugMode) {
          print("Token Error: $response");
        }
        Get.snackbar('Error', "Error desconocido",
            icon: const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Token Error: $e");
      }
      Get.snackbar(
        'Error',
        "No puede conectarse al servidor",
        icon: const Icon(
          Icons.signal_cellular_off,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 30),
      );
    }
  }

  //Funcion que envia la consulta de saldo
  Future loginSubmit() async {
    try {
      final response = await http.post(
        'https://wso2am.cimex.com.cu/appscratch/1/saldo_apk/' as Uri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'serie': _serial, 'pin': _pin}),
      );
      if (kDebugMode) {
        print(response.body);
      }
      final responseData = json.decode(response.body);
      if (responseData["estado"] == 0) {
        Get.snackbar('TARJETA INACTIVA',
            "Su tarjeta no ha sido ACTIVADA. Debe comunicarse con una oficina de FINCIMEX.SA",
            icon: const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 30,
            ),
            duration: const Duration(seconds: 10),
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } else if (responseData["estado"] == 3) {
        Get.snackbar('TARJETA CANCELADA',
            "Su tarjeta ha sido CANCELADA. Debe comunicarse con una oficina de FINCIMEX.SA",
            icon: const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } else if (responseData["estado"] == 2 || responseData["estado"] == 1) {
        _apiresponse = responseData;
        getSales();
        getRefounds();
        getOperations();
        getTrans();

        if (double.parse(_apiresponse["importe"]) >
            double.parse(_apiresponse["valor"])) {
          _percent = 1.0;
        } else {
          _percent = ((double.parse(_apiresponse["importe"]) /
              double.parse(_apiresponse["valor"])));
        }

        if (_salvaTarjeta == true) {
          DbOperations.insert(
              Tarjeta(tarjeta: _serial, pin: _clearPin, pin64: _pin));
          loadTarjetas();
          update(['tarjetas']);
        }

        Get.to(() => const SaldoPage());
      } else {
        Get.snackbar('Error', responseData["msg"],
            icon: const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print("Submit Timeout Error: $e");
      }
      Get.snackbar('Error', "La conexión ha tardado demasiado",
          icon: const Icon(
            Icons.signal_cellular_off,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      if (kDebugMode) {
        print("Submit Error: $e");
      }
      Get.snackbar('Error', "No puede conectarse al servidor",
          icon: const Icon(
            Icons.signal_cellular_off,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  //Funcion que consulta si tiene transferencias.
  Future getTrans() async {
    try {
      final response = await http.post(
        'https://wso2am.cimex.com.cu/appscratch/1/estado_recarga/' as Uri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'serie': _serial}),
      );
      if (kDebugMode) {
        print("Serial: $_serial");
        print(response.body);
      }
      final responseData = json.decode(response.body);
      _transfers = (responseData["transf"] as List)
          .map((e) => TransferModel.fromJson(e))
          .toList();
      update(['operations']);
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print("Transfer Timeout Error: $e");
      }
      Get.snackbar('Error', "La conexión ha tardado demasiado",
          icon: const Icon(
            Icons.signal_cellular_off,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      if (kDebugMode) {
        print("Transfer Error: $e");
      }
      Get.snackbar(
          'Error', "Ha ocurrido un error al obtener las transferencias.",
          icon: const Icon(
            Icons.signal_cellular_off,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  //funcion que devuelve las ventas
  Future<List<SalesModel>?> getSales() async {
    if (kDebugMode) {
      print('Funcion que lista las operaciones de venta');
    }
    try {
      _sales = (_apiresponse["pagos"] as List)
          .map((e) => SalesModel.fromJson(e))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Get Sales Error: $e");
      }
      return null;
    }
    update(['sales']);
    return _sales;
  }

  //Funcion que devuelve las devoluciones
  Future<List<RefoundModel>?> getRefounds() async {
    if (kDebugMode) {
      print('Funcion que lista las Devoluciones');
    }
    try {
      _refounds = (_apiresponse["devoluciones"] as List)
          .map((e) => RefoundModel.fromJson(e))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Get Refound Error: $e");
      }
      return null;
    }
    update(['refounds']);
    return _refounds;
  }

  //Funcion que concatena las ventas y las devoluciones y las organiza devolviendo las operaciones
  Future<List?> getOperations() async {
    if (kDebugMode) {
      print('Funcion que lista las Transferencias');
    }
    try {
      _operations = [..._sales, ..._refounds];
      _operations.sort((a, b) => a.operacion.compareTo(b.operacion));
    } catch (e) {
      if (kDebugMode) {
        print("Get Operations: $e");
      }
      return null;
    }

    update(['operations']);
    return _operations;
  }

  //Funcion para llamar al scanner qr de la Serie de la Tarjeta
  Future scanSerial() async {
    var options = const ScanOptions(
      strings: {
        "cancel": "Cancelar",
        "flash_on": "Flash ON",
        "flash_off": "Flash OFF"
      },
      autoEnableFlash: true,
    );

    var serialresult = await BarcodeScanner.scan(options: options);

    try {
      serialTxt.text = serialresult.rawContent;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        Get.snackbar(
            'Permiso Denegado', 'No tiene permisos para utilizar la camara',
            icon: const Icon(
              Icons.perm_camera_mic,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Error: $e',
            icon: const Icon(
              Icons.error,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } on FormatException {
      Get.snackbar(
          'Error de formato', 'El codigo leido no posee un formato correcto',
          icon: const Icon(
            Icons.error,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Error: $e',
          icon: const Icon(
            Icons.error,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future addPinToList(String text) async {
    _clearPinOrigen = text;
    if (kDebugMode) {
      print("Pin Claro: $_clearPinOrigen");
    }
    var inputBytes = utf8.encode(text);
    Digest sha512Result = sha512.convert(inputBytes);

    if (_pinArray.contains(base64Encode(sha512Result.bytes))) {
      Get.snackbar(
          'PIN Agregado', 'Ya ha agregado esa tarjeta en la lista de recarga.',
          icon: const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } else {
      _pinArray.add(base64Encode(sha512Result.bytes));
      //_pinOrigen = base64Encode(sha512Result.bytes);

      //_pinArray.add(text);
      Get.snackbar('PIN Agregado', 'Tarjeta agregada a la lista de recarga',
          icon: const Icon(
            Icons.check_box_sharp,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.green,
          colorText: Colors.white);
    }
    update(['recarga']);
  }

  //Funcion para llamar al scanner qr del PIN
  Future scanPin() async {
    var options = const ScanOptions(
      strings: {
        "cancel": "Cancelar",
        "flash_on": "Flash ON",
        "flash_off": "Flash OFF"
      },
      autoEnableFlash: true,
    );

    var pinresult = await BarcodeScanner.scan(options: options);

    try {
      pinTxt.text = pinresult.rawContent;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        Get.snackbar(
            'Permiso Denegado', 'No tiene permisos para utilizar la camara',
            icon: const Icon(
              Icons.perm_camera_mic,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Error: $e',
            icon: const Icon(
              Icons.error,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } on FormatException {
      Get.snackbar(
          'Error de formato', 'El codigo leido no posee un formato correcto',
          icon: const Icon(
            Icons.error,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Error: $e',
          icon: const Icon(
            Icons.error,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
