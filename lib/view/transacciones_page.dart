import 'package:flutter/material.dart';
import '../controller/transaction_controller.dart';
import '../model/bank_model.dart';

class PaginaTransacciones extends StatefulWidget {
  @override
  _PaginaTransaccionesState createState() => _PaginaTransaccionesState();
}

class _PaginaTransaccionesState extends State<PaginaTransacciones> {
  List<Transaccion> transacciones = [];
  final ControladorTransacciones _transactionController = ControladorTransacciones();

  @override
  void initState() {
    super.initState();
    _cargarTransacciones();
  }

  // Cargar las transacciones desde el controlador
  Future<void> _cargarTransacciones() async {
    final transaccionesCargadas = await _transactionController.cargarTransacciones();
    setState(() {
      transacciones = transaccionesCargadas;
    });
  }

  // Guardar las transacciones utilizando el controlador
  Future<void> _guardarTransacciones(List<Transaccion> transacciones) async {
    await _transactionController.guardarTransacciones(transacciones);
  }

  // Mostrar el modal para agregar una nueva transacción
  void _mostrarModalAgregarTransaccion() {
    final montoController = TextEditingController();
    final descripcionController = TextEditingController();
    String tipoTransaccion = 'Crédito'; // Opción por defecto
    final _formKey = GlobalKey<FormState>(); // Clave para el formulario

    showDialog(
      context: context,
      barrierDismissible: false, // Evitar cerrar el modal tocando fuera
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 40), // Modal más grande
          title: Text('Nueva Transacción', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Monto
                  TextFormField(
                    controller: montoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Monto',
                      hintText: 'Ejemplo: 100.50',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el monto';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Monto inválido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Descripción
                  TextFormField(
                    controller: descripcionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      hintText: 'Breve descripción de la transacción',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una descripción';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Selección del tipo de transacción (Crédito/Débito) como Dropdown
                  DropdownButtonFormField<String>(
                    value: tipoTransaccion,
                    decoration: InputDecoration(
                      labelText: 'Tipo de Transacción',
                      prefixIcon: Icon(Icons.payment),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                    items: ['Crédito', 'Débito']
                        .map((tipo) => DropdownMenuItem(
                      value: tipo,
                      child: Text(tipo),
                    ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        tipoTransaccion = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor seleccione un tipo de transacción';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[900],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final monto = double.parse(montoController.text);
                  final descripcion = descripcionController.text;
                  final transaccion = Transaccion(
                    monto: monto,
                    descripcion: descripcion,
                    fecha: DateTime.now(),
                    tipo: tipoTransaccion,
                    idTarjeta: 'tarjeta123', // Ejemplo de idTarjeta
                  );
                  setState(() {
                    transacciones.add(transaccion);
                  });
                  _guardarTransacciones(transacciones);
                  Navigator.of(context).pop(); // Cerrar el modal
                }
              },
              child: Text('Guardar Transacción', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Listado de transacciones
  Widget _mostrarListadoTransacciones() {
    return Expanded(
      child: ListView.builder(
        itemCount: transacciones.length,
        itemBuilder: (context, index) {
          final transaccion = transacciones[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            color: Colors.blueGrey[50],
            child: ListTile(
              leading: Icon(
                transaccion.tipo == 'Crédito' ? Icons.arrow_upward : Icons.arrow_downward,
                color: transaccion.tipo == 'Crédito' ? Colors.green : Colors.red,
                size: 30,
              ),
              title: Text(
                '${transaccion.tipo} - \$${transaccion.monto.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                transaccion.descripcion,
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: Text(
                '${transaccion.fecha.toString().split(' ')[0]}',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: 35), // Icono más grande
            onPressed: _mostrarModalAgregarTransaccion, // Abre el modal de nueva transacción
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Banner de estado de transacciones
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.account_balance_wallet, size: 100, color: Colors.white),
                  SizedBox(height: 15),
                  Text(
                    "Tus últimas transacciones",
                    style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  if (transacciones.isEmpty)
                    Text(
                      "No tienes transacciones aún. ¡Agrega una nueva!",
                      style: TextStyle(color: Colors.white70),
                    )
                  else
                    SizedBox.shrink(),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Listado de transacciones
            _mostrarListadoTransacciones(),
          ],
        ),
      ),
    );
  }
}
