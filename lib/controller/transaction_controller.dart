import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/bank_model.dart';

class ControladorTransacciones with ChangeNotifier {
  List<Transaccion> _transacciones = [];

  List<Transaccion> get transacciones => [..._transacciones];

  // Cargar las transacciones desde SharedPreferences
  Future<List<Transaccion>> cargarTransacciones() async {
    final prefs = await SharedPreferences.getInstance();
    final transaccionesString = prefs.getString('transacciones');
    if (transaccionesString != null) {
      final List<dynamic> transaccionesList = json.decode(transaccionesString);
      return transaccionesList.map((t) => Transaccion.fromJson(t)).toList();
    }
    return [];
  }

  // Guardar las transacciones en SharedPreferences
  Future<void> guardarTransacciones(List<Transaccion> transacciones) async {
    final prefs = await SharedPreferences.getInstance();
    final transaccionesJson = json.encode(transacciones.map((t) => t.toJson()).toList());
    prefs.setString('transacciones', transaccionesJson);
  }

  // Agregar una transacción
  Future<void> agregarTransaccion(Transaccion transaccion) async {
    _transacciones.add(transaccion);
    await guardarTransacciones;
    notifyListeners();
  }

  // Eliminar una transacción
  Future<void> eliminarTransaccion(String idTarjeta) async {
    _transacciones.removeWhere((transaccion) => transaccion.idTarjeta == idTarjeta);
    await guardarTransacciones;
    notifyListeners();
  }

  // Obtener transacciones por tarjeta desde SharedPreferences o cualquier fuente de datos
  Future<List<Transaccion>> obtenerTransaccionesPorTarjeta(String idTarjeta) async {
    final prefs = await SharedPreferences.getInstance();
    final transaccionesString = prefs.getString('transacciones');
    if (transaccionesString != null) {
      final List<dynamic> transaccionesList = json.decode(transaccionesString);
      // Filtrar por la tarjeta, si la transacción tiene el campo 'idTarjeta'
      return transaccionesList
          .where((t) => t['idTarjeta'] == idTarjeta)
          .map((t) => Transaccion.fromJson(t))
          .toList();
    }
    return [];
  }

  // Calcular el total de transacciones por tarjeta y tipo (Crédito o Débito)
  double calcularTotalTransacciones(List<Transaccion> transacciones, String tipo) {
    return transacciones
        .where((t) => t.tipo == tipo)
        .fold(0.0, (suma, t) => suma + t.monto);
  }

  // Inicializar el controlador (cargar las transacciones)
  Future<void> inicializar() async {
    await cargarTransacciones;
  }
}
