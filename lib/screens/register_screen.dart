import 'package:flutter/material.dart';

Color myCustomColor = const Color.fromARGB(255, 103, 197, 200);
// Define el widget de TextFormField reutilizable
Widget buildFormTextField(TextEditingController controller, String labelText, {bool isPassword = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: isPassword,
    ),
  );
}
enum UserType {
  client,
  company,
}
class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  final UserType userType;
  RegisterScreen(this.userType);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String nameLabel = userType == UserType.client ? 'Nombre' : 'Nombre de Compañía';
    String lastNameLabel = userType == UserType.client ? 'Apellido' : 'RUC';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: myCustomColor,
        title: Text('Registro'),
      ),
      body: Stack(
        children: [
          BackgroundImage(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                buildFormTextField(emailController, 'Correo Electrónico'),
                buildFormTextField(nameController, nameLabel),
                buildFormTextField(lastNameController, lastNameLabel),
                buildFormTextField(addressController, 'Dirección'),
                buildFormTextField(departmentController, 'Departamento'),
                buildFormTextField(districtController, 'Distrito'),
                buildFormTextField(numberController, 'Número de Teléfono'),
                buildFormTextField(passwordController, 'Contraseña', isPassword: true),
                buildFormTextField(repeatPasswordController, 'Repetir Contraseña', isPassword: true),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para el registro
                    final email = emailController.text;
                    final name = nameController.text;
                    final lastName = lastNameController.text;
                    final address = addressController.text;
                    final department = departmentController.text;
                    final district = districtController.text;
                    final number = numberController.text;
                    final password = passwordController.text;
                    final repeatPassword = repeatPasswordController.text;
                    // Agregar aquí la lógica de registro
                    Navigator.of(context).pushNamed("login");
                  },
                  style: ElevatedButton.styleFrom(
                    primary: myCustomColor,
                  ),
                  child: Text('Registrarse'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TipoDeUsuario extends StatelessWidget {
  UserType selectedUserType = UserType.client; // Por defecto, se establece como cliente
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Acción cuando se selecciona "Cliente"
                    selectedUserType = UserType.client;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterScreen(UserType.client)));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: myCustomColor, // Utiliza tu color personalizado aquí
                    minimumSize: Size(200, 60), // Ajusta el tamaño a tu preferencia
                  ),
                  child: Text(
                    'Cliente',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18, // Tamaño del texto
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Acción cuando se selecciona "Compañía"
                    selectedUserType = UserType.company;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterScreen(UserType.company)));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: myCustomColor, // Utiliza tu color personalizado aquí
                    minimumSize: Size(200, 60), // Ajusta el tamaño a tu preferencia
                  ),
                  child: Text(
                    'Compañía',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18, // Tamaño del texto
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}