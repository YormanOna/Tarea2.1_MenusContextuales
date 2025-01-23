import 'package:flutter/material.dart';
import 'package:nueva/view/pago_page.dart';
import 'package:nueva/view/transacciones_page.dart';
import 'card_page.dart';
import 'historial_transacciones_page.dart';

class PaginaInicio extends StatefulWidget {
  @override
  _PaginaInicioState createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  int _selectedIndex = 0; // Para manejar la página seleccionada en el Bottom Navigation
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // Para el Navigation Drawer

  // Método para manejar la selección de la página en el Bottom Navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Banco Élite', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF4A148C), // Morado oscuro elegante
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Banco Élite - Servicio confiable desde 1990')),
              );
            },
          ),
        ],
      ),
      drawer: NavigationDrawer(),
      body: _selectedIndex == 0
          ? ContenidoPrincipal() // Página principal
          : _selectedIndex == 1
          ? PaginaPago() // Página de pagos
          : _selectedIndex == 2
          ? PaginaTransacciones() // Página de historial de transacciones
          : PaginaTarjetas(), // Página de tarjetas
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xFFF3E5F5), // Beige claro
        selectedItemColor: Color(0xFF4A148C), // Morado oscuro
        unselectedItemColor: Color(0xFFB39DDB), // Morado suave
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Pagar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Transacciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Mis Tarjetas',
          ),
        ],
      ),
    );
  }
}

// Widget para el contenido principal con información sobre el banco y estilo actualizado
class ContenidoPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Banco Élite',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A148C), // Morado elegante
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFEDE7F6), // Fondo suave beige-morado
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // Sombra ligera
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.account_balance, size: 80, color: Color(0xFF4A148C)),
                SizedBox(height: 10),
                Text(
                  'Confianza, Innovación y Seguridad',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A148C),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Desde 1990, Banco Élite ha sido líder en el sector bancario, '
                      'ofreciendo soluciones tecnológicas avanzadas para mejorar la vida financiera '
                      'de nuestros clientes. Nos enfocamos en proporcionar servicios seguros y '
                      'eficientes, respaldados por la última tecnología y un servicio al cliente excepcional.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xFF5E35B1)),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Nuestros Servicios',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A148C),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ServicioBanco(icon: Icons.security, label: 'Seguridad'),
              ServicioBanco(icon: Icons.thumb_up, label: 'Confianza'),
              ServicioBanco(icon: Icons.smartphone, label: 'Tecnología'),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget para los servicios del banco (con iconos minimalistas)
class ServicioBanco extends StatelessWidget {
  final IconData icon;
  final String label;

  ServicioBanco({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFFD1C4E9), // Fondo morado suave
          child: Icon(icon, size: 30, color: Color(0xFF4A148C)), // Icono morado oscuro
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Color(0xFF4A148C))),
      ],
    );
  }
}

// Navigation Drawer con las opciones de navegación
class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Juan Pérez'),
            accountEmail: Text('juan.perez@bancoelite.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.account_circle, size: 50, color: Color(0xFF4A148C)),
            ),
            decoration: BoxDecoration(color: Color(0xFF4A148C)), // Morado oscuro
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PaginaInicio()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Realizar Pago'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaginaPago()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Historial de Transacciones'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaginaHistorialTransacciones()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Mis Tarjetas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaginaTarjetas()),
              );
            },
          ),
        ],
      ),
    );
  }
}
