class TransferModel {
  final String destino, fecha, origen, telefono, tipo;
  final importe;

  TransferModel(
      {required this.destino,
      required this.fecha,
      required this.origen,
      required this.telefono,
      this.importe,
      required this.tipo});

  static TransferModel fromJson(Map<String, dynamic> json) {
    return TransferModel(
        destino: json['destino'],
        fecha: json['fecha'],
        origen: json['origen'],
        telefono: json['telefono'],
        importe: json['importe'],
        tipo: "trans");
  }
}
