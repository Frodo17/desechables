class SalesModel {
  final String autorizo, tipo, fecha;
  final importe, operacion, pos;

  SalesModel(
      {required this.autorizo,
      required this.fecha,
      this.importe,
      this.operacion,
      required this.tipo,
      this.pos});

  static SalesModel fromJson(Map<String, dynamic> json) {
    return SalesModel(
        autorizo: json['autorizo'],
        fecha: json['fecha'],
        importe: json['importe'],
        operacion: json['operacion'],
        tipo: "sale",
        pos: json['pos']);
  }
}
