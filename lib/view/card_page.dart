import 'package:flutter/material.dart';
import '../controller/card_controller.dart';
import '../model/bank_model.dart';

class PaginaTarjetas extends StatefulWidget {
  const PaginaTarjetas({Key? key}) : super(key: key);

  @override
  State<PaginaTarjetas> createState() => _PaginaTarjetasState();
}

class _PaginaTarjetasState extends State<PaginaTarjetas> {
  final _formKey = GlobalKey<FormState>();
  final _numeroController = TextEditingController();
  final _nombreController = TextEditingController();
  final _fechaController = TextEditingController();
  final _cvvController = TextEditingController();
  final _saldoController = TextEditingController();
  final _limiteController = TextEditingController();
  String _tipoSeleccionado = "Crédito";

  final ControladorTarjetas _controlador = ControladorTarjetas();

  @override
  void initState() {
    super.initState();
    _cargarTarjetas();
  }

  _cargarTarjetas() async {
    await _controlador.inicializar();
    setState(() {});
  }

  _guardarTarjetas() async {
    await _controlador.guardarTarjetas();
  }

  void _crearTarjeta() {
    if (_formKey.currentState!.validate()) {
      final nuevaTarjeta = TarjetaBancaria(
        id: DateTime.now().toString(),
        numero: _numeroController.text,
        nombreTitular: _nombreController.text,
        fechaExpiracion: _fechaController.text,
        cvv: _cvvController.text,
        saldo: double.parse(_saldoController.text),
        limiteCredito: double.parse(_limiteController.text),
        tipo: _tipoSeleccionado,
      );

      _controlador.agregarTarjeta(nuevaTarjeta);
      _guardarTarjetas();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Tarjeta Creada'),
            content: const Text('La tarjeta se ha agregado correctamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );

      // Limpiar los campos
      _numeroController.clear();
      _nombreController.clear();
      _fechaController.clear();
      _cvvController.clear();
      _saldoController.clear();
      _limiteController.clear();
      setState(() {
        _tipoSeleccionado = "Crédito";
      });
    }
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: validator,
    );
  }

  Widget buildCreditCard(TarjetaBancaria tarjeta) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: tarjeta.tipo == "Crédito"
            ? const LinearGradient(
          colors: [Colors.deepPurple, Colors.deepPurpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : const LinearGradient(
          colors: [Colors.teal, Colors.tealAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              '**** **** **** ${tarjeta.numero.substring(tarjeta.numero.length - 4)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 20,
            child: Text(
              tarjeta.nombreTitular.toUpperCase(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              'Expira: ${tarjeta.fechaExpiracion}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Icon(
              tarjeta.tipo == "Crédito"
                  ? Icons.credit_card
                  : Icons.account_balance_wallet,
              color: Colors.white70,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarjetas'),
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
        child: Column(
          children: [
            // Mostrar contenido adicional cuando no hay tarjetas
            _controlador.tarjetasBanca.isEmpty
                ? Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '¡No tienes tarjetas agregadas aún!\nA continuación, puedes agregar una nueva tarjeta para gestionar tu saldo, límite de crédito y realizar transacciones.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.5, // Mejora la legibilidad
                ),
                textAlign: TextAlign.center,
              ),
            )
                : const SizedBox.shrink(), // Si hay tarjetas, no mostrar este texto

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: _controlador.tarjetasBanca.length,
                itemBuilder: (context, index) {
                  final tarjeta = _controlador.tarjetasBanca[index];
                  return buildCreditCard(tarjeta);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildTextFormField(
                          controller: _numeroController,
                          labelText: 'Número de Tarjeta',
                          hintText: '1234 5678 9123 4567',
                          icon: Icons.credit_card,
                          validator: (value) {
                            // Validar que solo contenga números y tenga 16 dígitos
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese un número de tarjeta';
                            }
                            if (!RegExp(r'^\d{16}$').hasMatch(value)) {
                              return 'El número de tarjeta debe contener exactamente 16 dígitos';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        buildTextFormField(
                          controller: _nombreController,
                          labelText: 'Nombre del Titular',
                          hintText: 'Juan Pérez',
                          icon: Icons.person,
                          validator: (value) {
                            // Validar que solo contenga letras
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese el nombre del titular';
                            }
                            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                              return 'El nombre del titular solo debe contener letras';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        buildTextFormField(
                          controller: _fechaController,
                          labelText: 'Fecha de Expiración',
                          hintText: 'MM/AA',
                          icon: Icons.calendar_today,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese la fecha de expiración';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        buildTextFormField(
                          controller: _cvvController,
                          labelText: 'CVV',
                          hintText: '123',
                          icon: Icons.lock,
                          validator: (value) {
                            // Validar que el CVV tenga 3 dígitos
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese el CVV';
                            }
                            if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                              return 'El CVV debe contener exactamente 3 dígitos';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        buildTextFormField(
                          controller: _saldoController,
                          labelText: 'Saldo Inicial',
                          hintText: '1000.00',
                          icon: Icons.attach_money,
                          validator: (value) {
                            // Validar que solo contenga números
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese el saldo inicial';
                            }
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
                              return 'Ingrese un saldo válido (por ejemplo, 1000.00)';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                        const SizedBox(height: 10),
                        buildTextFormField(
                          controller: _limiteController,
                          labelText: 'Límite de Crédito',
                          hintText: '5000.00',
                          icon: Icons.money_off,
                          validator: (value) {
                            // Validar que solo contenga números
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese el límite de crédito';
                            }
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
                              return 'Ingrese un límite válido (por ejemplo, 5000.00)';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _crearTarjeta,
                          child: const Text('Agregar Tarjeta'),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
