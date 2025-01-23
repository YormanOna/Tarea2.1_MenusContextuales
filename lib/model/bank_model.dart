class TarjetaBancaria {
  String id;
  String numero;
  String nombreTitular;
  String fechaExpiracion;
  String cvv;
  double saldo;
  double limiteCredito;
  String tipo;

  TarjetaBancaria({
    required this.id,
    required this.numero,
    required this.nombreTitular,
    required this.fechaExpiracion,
    required this.cvv,
    required this.saldo,
    required this.limiteCredito,
    required this.tipo,
  });

  // Convertir a Map<String, dynamic> para almacenamiento (ejemplo JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'nombreTitular': nombreTitular,
      'fechaExpiracion': fechaExpiracion,
      'cvv': cvv,
      'saldo': saldo,
      'limiteCredito': limiteCredito,
      'tipo': tipo,
    };
  }

  // Convertir desde Map<String, dynamic> al objeto TarjetaBancaria
  factory TarjetaBancaria.fromJson(Map<String, dynamic> json) {
    return TarjetaBancaria(
      id: json['id'],
      numero: json['numero'],
      nombreTitular: json['nombreTitular'],
      fechaExpiracion: json['fechaExpiracion'],
      cvv: json['cvv'],
      saldo: json['saldo'],
      limiteCredito: json['limiteCredito'],
      tipo: json['tipo'],
    );
  }
}

class Transaccion {
  final double monto;
  final String descripcion;
  final DateTime fecha;
  final String tipo; // "Crédito" o "Débito"
  final String idTarjeta;

  Transaccion({
    required this.monto,
    required this.descripcion,
    required this.fecha,
    required this.tipo,
    required this.idTarjeta,
  });

  Map<String, dynamic> toJson() => {
    'monto': monto,
    'descripcion': descripcion,
    'fecha': fecha.toIso8601String(),
    'tipo': tipo,
    'idTarjeta': idTarjeta,
  };

  factory Transaccion.fromJson(Map<String, dynamic> json) {
    return Transaccion(
      monto: (json['monto'] as num).toDouble(),
      descripcion: json['descripcion'],
      fecha: DateTime.parse(json['fecha']),
      tipo: json['tipo'],
      idTarjeta: json['idTarjeta'],
    );
  }
}
