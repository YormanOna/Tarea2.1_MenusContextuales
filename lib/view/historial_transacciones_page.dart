import 'package:flutter/material.dart';
import '../controller/transaction_controller.dart';
import '../model/bank_model.dart';

class PaginaHistorialTransacciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controlador = ControladorTransacciones();

    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Transacciones'),
        backgroundColor: Color(0xFF4A148C),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              // Acción para filtrar transacciones
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Transaccion>>(
          future: controlador.obtenerTransaccionesPorTarjeta('tarjeta123'),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error al cargar las transacciones.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No hay transacciones registradas.',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              );
            } else {
              final transacciones = snapshot.data!;
              final totalCredito = controlador.calcularTotalTransacciones(transacciones, 'Crédito');
              final totalDebito = controlador.calcularTotalTransacciones(transacciones, 'Débito');

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: transacciones.length,
                      itemBuilder: (ctx, index) {
                        final transaccion = transacciones[index];

                        return Card(
                          elevation: 8,
                          margin: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => Dialog(
                                  insetPadding: EdgeInsets.symmetric(horizontal: 50),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Detalles de la Transacción',
                                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20),
                                        Text('Descripción: ${transaccion.descripcion}'),
                                        Text('Monto: \$${transaccion.monto.toStringAsFixed(2)}'),
                                        Text('Tipo: ${transaccion.tipo}'),
                                        Text('Fecha: ${transaccion.fecha.toLocal()}'),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple[900],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text('Cerrar', style: TextStyle(color: Colors.white)),
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Icon(
                                    transaccion.tipo == 'Crédito'
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: transaccion.tipo == 'Crédito'
                                        ? Colors.green[700]
                                        : Colors.red[700],
                                    size: 35,
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          transaccion.descripcion,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple[800],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Tipo: ${transaccion.tipo}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.deepPurple[600],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Fecha: ${transaccion.fecha.toLocal()}',
                                          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${transaccion.monto.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Mostrar el total de Créditos y Débitos al final
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Créditos: \$${totalCredito.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Total Débitos: \$${totalDebito.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
