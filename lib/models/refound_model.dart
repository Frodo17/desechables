class RefoundModel {
  final String autorizo, tipo, fecha;
  final importe, operacion, pos;

  RefoundModel(
      {required this.autorizo,
      required this.fecha,
      this.importe,
      this.operacion,
      required this.tipo,
      this.pos});

  static RefoundModel fromJson(Map<String, dynamic> json) {
    return RefoundModel(
        autorizo: json['autorizo'],
        fecha: json['fecha'],
        importe: json['importe'],
        operacion: json['operacion'],
        tipo: "refound",
        pos: json['pos']);
  }
}
