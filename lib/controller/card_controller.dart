import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/bank_model.dart';

class ControladorTarjetas with ChangeNotifier {
  List<TarjetaBancaria> tarjetas = [];

  List<TarjetaBancaria> get tarjetasBanca => List.unmodifiable(tarjetas);

  // Guardamos las tarjetas en SharedPreferences
  Future<void> guardarTarjetas() async {
    final prefs = await SharedPreferences.getInstance();
    final tarjetasJson = tarjetas.map((t) => t.toJson()).toList();
    prefs.setString('tarjetas', json.encode(tarjetasJson));
  }

  // Cargamos las tarjetas desde SharedPreferences
  Future<void> _cargarTarjetas() async {
    final prefs = await SharedPreferences.getInstance();
    final tarjetasString = prefs.getString('tarjetas');

    // Verificar si hay datos disponibles en SharedPreferences
    if (tarjetasString != null && tarjetasString.isNotEmpty) {
      try {
        final List<dynamic> tarjetasList = json.decode(tarjetasString);
        tarjetas = tarjetasList
            .map((t) => TarjetaBancaria.fromJson(t as Map<String, dynamic>))
            .toList();
        print("Tarjetas cargadas correctamente.");
      } catch (e) {
        print("Error al cargar las tarjetas: $e");
      }
    } else {
      print("No hay tarjetas almacenadas.");
    }
  }

  // Agregar una tarjeta
  Future<void> agregarTarjeta(TarjetaBancaria tarjeta) async {
    tarjetas.add(tarjeta);
    await guardarTarjetas();
    notifyListeners();
  }

  // Actualizar una tarjeta
  Future<void> actualizarTarjeta(TarjetaBancaria tarjeta) async {
    final indice = tarjetas.indexWhere((t) => t.id == tarjeta.id);
    if (indice >= 0) {
      tarjetas[indice] = tarjeta;
      await guardarTarjetas();
      notifyListeners();
    }
  }

  // Eliminar una tarjeta
  Future<void> eliminarTarjeta(String id) async {
    tarjetas.removeWhere((tarjeta) => tarjeta.id == id);
    await guardarTarjetas();
    notifyListeners();
  }

  // Obtener una tarjeta por su ID
  TarjetaBancaria obtenerTarjetaPorId(String id) {
    return tarjetas.firstWhere(
          (tarjeta) => tarjeta.id == id,
      orElse: () {
        throw Exception('Tarjeta no encontrada con el id: $id');
      },
    );
  }

  // Obtener el saldo total de todas las tarjetas
  double obtenerSaldoTotal() {
    return tarjetas.fold(0, (suma, tarjeta) => suma + tarjeta.saldo);
  }

  // Inicializar cargando las tarjetas al iniciar la app
  Future<void> inicializar() async {
    await _cargarTarjetas();
  }
}
