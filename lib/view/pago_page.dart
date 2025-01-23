import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaginaPago extends StatefulWidget {
  @override
  State<PaginaPago> createState() => _PaginaPagoState();
}

class _PaginaPagoState extends State<PaginaPago> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _tarjetaController = TextEditingController();
  List<Map<String, String>> _pagos = []; // Lista para almacenar los pagos

  @override
  void initState() {
    super.initState();
    _cargarPagos(); // Cargar pagos guardados al inicio
  }

  // Cargar los pagos guardados desde SharedPreferences
  Future<void> _cargarPagos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? pagosGuardados = prefs.getStringList('pagos');
    if (pagosGuardados != null) {
      setState(() {
        _pagos = pagosGuardados
            .map((e) => Map.fromEntries(e.split(',').map((x) => MapEntry(x.split(':')[0], x.split(':')[1]))))
            .toList();
      });
    }
  }

  // Guardar un nuevo pago en SharedPreferences
  Future<void> _guardarPago(String monto, String tarjeta) async {
    final prefs = await SharedPreferences.getInstance();
    final pago = {'monto': monto, 'tarjeta': tarjeta};
    setState(() {
      _pagos.add(pago);
    });

    // Convertir la lista de pagos en una lista de strings para guardarla
    final List<String> pagosParaGuardar = _pagos
        .map((e) => e.entries.map((entry) => '${entry.key}:${entry.value}').join(','))
        .toList();
    await prefs.setStringList('pagos', pagosParaGuardar);
  }

  // Realizar el pago
  void _realizarPago() {
    if (_formKey.currentState!.validate()) {
      _guardarPago(_montoController.text, _tarjetaController.text);

      // Mostrar un AlertDialog para confirmar el pago
      _mostrarConfirmacionPago();

      _montoController.clear();
      _tarjetaController.clear();
    }
  }

  // Mostrar la ventana modal para crear un pago
  void _mostrarModalPago() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Realizar Pago',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _montoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el monto';
                  }
                  final monto = double.tryParse(value);
                  if (monto == null || monto <= 0) {
                    return 'Ingrese un monto válido mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tarjetaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de Tarjeta',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el número de tarjeta';
                  }
                  if (value.length != 16) {
                    return 'El número de tarjeta debe tener 16 dígitos numéricos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  _realizarPago();
                  // Mantener la ventana modal abierta si no es válida
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(ctx).pop(); // Cerrar el modal después de realizar el pago
                  }
                },
                icon: const Icon(Icons.payment),
                label: const Text('Realizar Pago'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para mostrar el Dialog de confirmación
  void _mostrarConfirmacionPago() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('Pago realizado correctamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el dialog
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Contenido introductorio
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Bienvenido a nuestra plataforma de pagos. Aquí puedes realizar pagos de manera rápida y segura. Solo ingresa el monto y el número de tu tarjeta para completar la transacción.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Título para el listado de pagos
              Text(
                'Tus Pagos Realizados:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              const SizedBox(height: 10),

              // Listado de pagos
              _pagos.isEmpty
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No has realizado ningún pago aún.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: _pagos.length,
                itemBuilder: (ctx, index) {
                  final pago = _pagos[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Monto: \$${pago['monto']}'),
                      subtitle: Text('Tarjeta: ${pago['tarjeta']}'),
                      leading: const Icon(Icons.payment, color: Colors.teal),
                      // Eliminar el ícono de la flecha
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Botón para mostrar la ventana modal para crear pago
              Center(
                child: ElevatedButton.icon(
                  onPressed: _mostrarModalPago,
                  icon: const Icon(Icons.add),
                  label: const Text('Crear un Pago'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 18), // Botón más largo
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
