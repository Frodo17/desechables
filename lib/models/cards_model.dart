class Tarjeta {
  final int id;
  final String tarjeta, pin, pin64, valor, vencimiento;

  Tarjeta(
      {this.id=0,
      required this.tarjeta,
      this.pin='0000000000000000',
      this.pin64='64',
      this.valor='0',
      this.vencimiento='99/99/9999'});

  Map<String, dynamic> toMap() {
    return {'id': id, 'tarjeta': tarjeta, 'pin': pin, 'pin64': pin64};
  }

  @override
  String toString() {
    return 'Tarjeta{id: $id, tarjeta: $tarjeta, pin: $pin, pin64: $pin64}';
  }
}
