import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

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

/*class RegisterScreen extends StatelessWidget {
  final UserType userType;
  RegisterScreen(this.userType);

  bool acceptedTerms = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameOrRucController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  Future<void> insertCustomer({
    required String email,
    required String name,
    required String address,
    required String department,
    required String district,
    required String number,
    required String password,
    required String repeatPassword,
    required String lastName
  // Otros campos del usuario
  }) async {
    final url = Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/customers');

    final Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'address': address,
      'department': department,
      'district': district,
      'phoneNumber': number,
      'password': password,
      'repeatPassword': repeatPassword,
      'lastName': lastName
      // Otros campos del usuario
    };

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data)
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Éxito: Usuario insertado correctamente en la API
      print('Usuario insertado con éxito en la API');
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } else {
      // Respuesta inesperada del servidor
      print('Error en la API: ${response.statusCode}');
    }
  }

  Future<void> insertCompany({
    required String email,
    required String name,
    required String address,
    required String department,
    required String district,
    required String number,
    required String password,
    required String repeatPassword,
    required String ruc
    // Otros campos del usuario
  }) async {
    final url = Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/companies');

    final Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'address': address,
      'department': department,
      'district': district,
      'phoneNumber': number,
      'password': password,
      'repeatPassword': repeatPassword,
      'ruc': ruc
      // Otros campos del usuario
    };

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data)
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Éxito: Usuario insertado correctamente en la API
      print('Usuario insertado con éxito en la API');
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } else {
      // Respuesta inesperada del servidor
      print('Error en la API: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');
    }
  }

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
                buildFormTextField(lastNameOrRucController, lastNameLabel),
                buildFormTextField(addressController, 'Dirección'),
                buildFormTextField(departmentController, 'Departamento'),
                buildFormTextField(districtController, 'Distrito'),
                buildFormTextField(numberController, 'Número de Teléfono'),
                buildFormTextField(passwordController, 'Contraseña', isPassword: true),
                buildFormTextField(repeatPasswordController, 'Repetir Contraseña', isPassword: true),
                // Nuevo Widget para el cuadro de selección de términos y condiciones
                Row(
                  children: [
                    Checkbox(
                      value: acceptedTerms,
                      checkColor: Colors.black,
                      onChanged: (value) {
                        // Actualiza el estado al cambiar la selección
                        // Puedes agregar lógica adicional según tus necesidades
                        acceptedTerms = value ?? false;
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        // Aquí puedes abrir un diálogo o navegar a una nueva pantalla
                        // donde se muestren los términos y condiciones.
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Términos y Condiciones'),
                              content: const SingleChildScrollView(
                                child: Text(
                                  // Agrega aquí el texto completo de tus términos y condiciones
'''
**Términos y Condiciones de Uso**

Bienvenido a SaveUp, una plataforma de ventas en línea. Antes de utilizar nuestros servicios, te pedimos que leas detenidamente los siguientes términos y condiciones. Al acceder y utilizar nuestra aplicación, aceptas cumplir con estos términos y condiciones.

**1. Registro de Cuenta:**
  - Al registrarte en SaveUp, proporcionas información personal, incluyendo tu nombre, dirección, número de teléfono y dirección de correo electrónico.
  - Los usuarios de tipo "Cliente" también pueden necesitar ingresar información adicional, como detalles de tarjetas de crédito, para facilitar transacciones.

**2. Responsabilidades del Usuario Cliente:**
  - Los usuarios clientes son responsables de la veracidad y exactitud de la información proporcionada.
  - Al proporcionar información de tarjeta de crédito, aceptas que esta información será utilizada para procesar pagos de compras en la plataforma.

**3. Responsabilidades del Usuario Compañía:**
  - Los usuarios compañía son responsables de la información proporcionada al registrar su empresa en la aplicación.
  - Al publicar productos, aceptas cumplir con las políticas de contenido y derechos de autor de SaveUp.

**4. Uso Apropiado de la Plataforma:**
  - Los usuarios no deben utilizar la aplicación para actividades ilegales, fraudulentas o que violen los derechos de terceros.
  - No se permite la publicación de contenido obsceno, difamatorio o que pueda causar daño a otros usuarios.

**5. Privacidad y Seguridad:**
  - SaveUp se compromete a proteger la privacidad de los usuarios. Consulta nuestra Política de Privacidad para obtener más detalles.
  - Los usuarios son responsables de mantener la confidencialidad de sus credenciales de inicio de sesión.

**6. Modificaciones en los Términos y Condiciones:**
  - SaveUp se reserva el derecho de modificar estos términos y condiciones en cualquier momento. Los usuarios serán notificados de cambios significativos.

**7. Finalización de Cuenta:**
  - SaveUp se reserva el derecho de suspender o cancelar cuentas que violen estos términos y condiciones.

Al utilizar SaveUp, aceptas estos términos y condiciones. Si no estás de acuerdo con alguno de estos términos, te recomendamos que dejes de utilizar la aplicación.

Gracias por ser parte de nuestra comunidad.

Fecha de última actualización: 20-11-2023
'''
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Acepto los términos y condiciones',
                        style: TextStyle(color: Color(0xFFE95D5D), decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Lógica para el registro
                    final email = emailController.text;
                    final name = nameController.text;
                    final lastNameOrRuc = lastNameOrRucController.text;
                    final address = addressController.text;
                    final department = departmentController.text;
                    final district = districtController.text;
                    final number = numberController.text;
                    final password = passwordController.text;
                    final repeatPassword = repeatPasswordController.text;

                    // Validar que las contraseñas coincidan
                    if (password != repeatPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Las contraseñas no coinciden'),
                        ),
                      );
                      return;
                    }

                    // Validar que la contraseña tenga entre 8 y 12 carcateres
                    if (password.length < 8 || password.length > 12) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('La contraseña debe tener entre 8 y 12 caracteres'),
                        ),
                      );
                      return;
                    }

                    // Validar que ni exista un usuario con el mismo correo
                    final customersUrl = Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/customers');
                    final customersResponse = await http.get(customersUrl);
                    final customersData = json.decode(customersResponse.body) as List;
                    final companiesUrl = Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/companies');
                    final companiesResponse = await http.get(companiesUrl);
                    final companiesData = json.decode(companiesResponse.body) as List;

                    bool emailExists = false;
                    for (var customerUser in customersData) {
                      if (email == customerUser['email']) {
                        emailExists = true;
                        break;
                      }
                    }
                    for (var companyUser in companiesData) {
                      if (email == companyUser['email']) {
                        emailExists = true;
                        break;
                      }
                    }
                    if (emailExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ya existe un usuario con el mismo correo'),
                        ),
                      );
                      return;
                    }

                    // Validar que el numero telefonico tenga 9 digitos
                    if (number.length != 9) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('El número de teléfono debe tener 9 dígitos'),
                        ),
                      );
                      return;
                    }
                    
                    // Validar que no exista un usuario con el mismo numero telefonico
                    bool numberExists = false;
                    for (var customerUser in customersData) {
                      if (number == customerUser['phoneNumber']) {
                        numberExists = true;
                        break;
                      }
                    }
                    for (var companyUser in companiesData) {
                      if (number == companyUser['phoneNumber']) {
                        numberExists = true;
                        break;
                      }
                    }
                    if (numberExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ya existe un usuario con el mismo número de teléfono'),
                        ),
                      );
                      return;
                    }

                    // Si el userType == UserType.company, entonces lastNameOrRuc debe tener 11 caracteres
                    if (userType == UserType.company && lastNameOrRuc.length != 11) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('El RUC debe tener 11 caracteres'),
                        ),
                      );
                      return;
                    }

                    // Validar que no exista un usuario company con el mismo ruc
                    bool rucExists = false;
                    for (var companyUser in companiesData) {
                      if (lastNameOrRuc == companyUser['ruc']) {
                        rucExists = true;
                        break;
                      }
                    }
                    if (rucExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ya existe un usuario con el mismo RUC'),
                        ),
                      );
                      return;
                    }

                    // Validar que no haya campos vacíos
                    if (email.isEmpty ||
                        name.isEmpty ||
                        lastNameOrRuc.isEmpty ||
                        address.isEmpty ||
                        department.isEmpty ||
                        district.isEmpty ||
                        number.isEmpty ||
                        password.isEmpty ||
                        repeatPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, llene todos los campos'),
                        ),
                      );
                      return;
                    }

                    // Verificar si el usuario ha aceptado los términos y condiciones
                    if (!acceptedTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, acepta los términos y condiciones'),
                        ),
                      );
                      return;
                    }

                    // Insertar en la base de datos
                    if(userType == UserType.client) {
                      await insertCustomer(
                        email: email,
                        name: name,
                        lastName: lastNameOrRuc,
                        address: address,
                        department: department,
                        district: district,
                        number: number,
                        password: password,
                        repeatPassword: repeatPassword
                      );
                    }
                    else if(userType == UserType.company) {
                      await insertCompany(
                        email: email,
                        name: name,
                        ruc: lastNameOrRuc,
                        address: address,
                        department: department,
                        district: district,
                        number: number,
                        password: password,
                        repeatPassword: repeatPassword
                      );
                    }

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
}*/

class RegisterScreen extends StatefulWidget {
  final UserType userType;
  RegisterScreen(this.userType);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState(userType);
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool acceptedTerms = false;
  final UserType userType;

  _RegisterScreenState(this.userType);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameOrRucController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  Future<void> insertCustomer({
    required String email,
    required String name,
    required String address,
    required String department,
    required String district,
    required String number,
    required String password,
    required String repeatPassword,
    required String lastName
  // Otros campos del usuario
  }) async {
    final url = Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/customers');

    final Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'address': address,
      'department': department,
      'district': district,
      'phoneNumber': number,
      'password': password,
      'repeatPassword': repeatPassword,
      'lastName': lastName
      // Otros campos del usuario
    };

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data)
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Éxito: Usuario insertado correctamente en la API
      print('Usuario insertado con éxito en la API');
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } else {
      // Respuesta inesperada del servidor
      print('Error en la API: ${response.statusCode}');
    }
  }

  Future<void> insertCompany({
    required String email,
    required String name,
    required String address,
    required String department,
    required String district,
    required String number,
    required String password,
    required String repeatPassword,
    required String ruc
    // Otros campos del usuario
  }) async {
    final url = Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/companies');

    final Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'address': address,
      'department': department,
      'district': district,
      'phoneNumber': number,
      'password': password,
      'repeatPassword': repeatPassword,
      'ruc': ruc
      // Otros campos del usuario
    };

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data)
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Éxito: Usuario insertado correctamente en la API
      print('Usuario insertado con éxito en la API');
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } else {
      // Respuesta inesperada del servidor
      print('Error en la API: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');
    }
  }

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
                buildFormTextField(lastNameOrRucController, lastNameLabel),
                buildFormTextField(addressController, 'Dirección'),
                buildFormTextField(departmentController, 'Departamento'),
                buildFormTextField(districtController, 'Distrito'),
                buildFormTextField(numberController, 'Número de Teléfono'),
                buildFormTextField(passwordController, 'Contraseña', isPassword: true),
                buildFormTextField(repeatPasswordController, 'Repetir Contraseña', isPassword: true),
                // Nuevo Widget para el cuadro de selección de términos y condiciones
                Row(
                  children: [
                    Checkbox(
                      value: acceptedTerms,
                      checkColor: Colors.black,
                      onChanged: (value) {
                        // Actualiza el estado al cambiar la selección
                        // Puedes agregar lógica adicional según tus necesidades
                        setState(() {
                          acceptedTerms = value ?? false;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        // Aquí puedes abrir un diálogo o navegar a una nueva pantalla
                        // donde se muestren los términos y condiciones.
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Términos y Condiciones'),
                              content: const SingleChildScrollView(
                                child: Text(
                                  // Agrega aquí el texto completo de tus términos y condiciones
'''
**Términos y Condiciones de Uso**

Bienvenido a SaveUp, una plataforma de ventas en línea. Antes de utilizar nuestros servicios, te pedimos que leas detenidamente los siguientes términos y condiciones. Al acceder y utilizar nuestra aplicación, aceptas cumplir con estos términos y condiciones.

**1. Registro de Cuenta:**
  - Al registrarte en SaveUp, proporcionas información personal, incluyendo tu nombre, dirección, número de teléfono y dirección de correo electrónico.
  - Los usuarios de tipo "Cliente" también pueden necesitar ingresar información adicional, como detalles de tarjetas de crédito, para facilitar transacciones.

**2. Responsabilidades del Usuario Cliente:**
  - Los usuarios clientes son responsables de la veracidad y exactitud de la información proporcionada.
  - Al proporcionar información de tarjeta de crédito, aceptas que esta información será utilizada para procesar pagos de compras en la plataforma.

**3. Responsabilidades del Usuario Compañía:**
  - Los usuarios compañía son responsables de la información proporcionada al registrar su empresa en la aplicación.
  - Al publicar productos, aceptas cumplir con las políticas de contenido y derechos de autor de SaveUp.

**4. Uso Apropiado de la Plataforma:**
  - Los usuarios no deben utilizar la aplicación para actividades ilegales, fraudulentas o que violen los derechos de terceros.
  - No se permite la publicación de contenido obsceno, difamatorio o que pueda causar daño a otros usuarios.

**5. Privacidad y Seguridad:**
  - SaveUp se compromete a proteger la privacidad de los usuarios. Consulta nuestra Política de Privacidad para obtener más detalles.
  - Los usuarios son responsables de mantener la confidencialidad de sus credenciales de inicio de sesión.

**6. Modificaciones en los Términos y Condiciones:**
  - SaveUp se reserva el derecho de modificar estos términos y condiciones en cualquier momento. Los usuarios serán notificados de cambios significativos.

**7. Finalización de Cuenta:**
  - SaveUp se reserva el derecho de suspender o cancelar cuentas que violen estos términos y condiciones.

Al utilizar SaveUp, aceptas estos términos y condiciones. Si no estás de acuerdo con alguno de estos términos, te recomendamos que dejes de utilizar la aplicación.

Gracias por ser parte de nuestra comunidad.

Fecha de última actualización: 20-11-2023
'''
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Acepto los términos y condiciones',
                        style: TextStyle(color: Color(0xFFE95D5D), decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Lógica para el registro
                    final email = emailController.text;
                    final name = nameController.text;
                    final lastNameOrRuc = lastNameOrRucController.text;
                    final address = addressController.text;
                    final department = departmentController.text;
                    final district = districtController.text;
                    final number = numberController.text;
                    final password = passwordController.text;
                    final repeatPassword = repeatPasswordController.text;

                    // Validar que las contraseñas coincidan
                    if (password != repeatPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Las contraseñas no coinciden'),
                        ),
                      );
                      return;
                    }

                    // Validar que la contraseña tenga entre 8 y 12 carcateres
                    if (password.length < 8 || password.length > 12) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('La contraseña debe tener entre 8 y 12 caracteres'),
                        ),
                      );
                      return;
                    }

                    // Validar que ni exista un usuario con el mismo correo
                    final customersUrl = Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/customers');
                    final customersResponse = await http.get(customersUrl);
                    final customersData = json.decode(customersResponse.body) as List;
                    final companiesUrl = Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/companies');
                    final companiesResponse = await http.get(companiesUrl);
                    final companiesData = json.decode(companiesResponse.body) as List;

                    bool emailExists = false;
                    for (var customerUser in customersData) {
                      if (email == customerUser['email']) {
                        emailExists = true;
                        break;
                      }
                    }
                    for (var companyUser in companiesData) {
                      if (email == companyUser['email']) {
                        emailExists = true;
                        break;
                      }
                    }
                    if (emailExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ya existe un usuario con el mismo correo'),
                        ),
                      );
                      return;
                    }

                    // Validar que el numero telefonico tenga 9 digitos
                    if (number.length != 9) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('El número de teléfono debe tener 9 dígitos'),
                        ),
                      );
                      return;
                    }
                    
                    // Validar que no exista un usuario con el mismo numero telefonico
                    bool numberExists = false;
                    for (var customerUser in customersData) {
                      if (number == customerUser['phoneNumber']) {
                        numberExists = true;
                        break;
                      }
                    }
                    for (var companyUser in companiesData) {
                      if (number == companyUser['phoneNumber']) {
                        numberExists = true;
                        break;
                      }
                    }
                    if (numberExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ya existe un usuario con el mismo número de teléfono'),
                        ),
                      );
                      return;
                    }

                    // Si el userType == UserType.company, entonces lastNameOrRuc debe tener 11 caracteres
                    if (userType == UserType.company && lastNameOrRuc.length != 11) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('El RUC debe tener 11 caracteres'),
                        ),
                      );
                      return;
                    }

                    // Validar que no exista un usuario company con el mismo ruc
                    bool rucExists = false;
                    for (var companyUser in companiesData) {
                      if (lastNameOrRuc == companyUser['ruc']) {
                        rucExists = true;
                        break;
                      }
                    }
                    if (rucExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ya existe un usuario con el mismo RUC'),
                        ),
                      );
                      return;
                    }

                    // Validar que no haya campos vacíos
                    if (email.isEmpty ||
                        name.isEmpty ||
                        lastNameOrRuc.isEmpty ||
                        address.isEmpty ||
                        department.isEmpty ||
                        district.isEmpty ||
                        number.isEmpty ||
                        password.isEmpty ||
                        repeatPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, llene todos los campos'),
                        ),
                      );
                      return;
                    }

                    // Verificar si el usuario ha aceptado los términos y condiciones
                    if (!acceptedTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, acepta los términos y condiciones'),
                        ),
                      );
                      return;
                    }

                    // Insertar en la base de datos
                    if(userType == UserType.client) {
                      await insertCustomer(
                        email: email,
                        name: name,
                        lastName: lastNameOrRuc,
                        address: address,
                        department: department,
                        district: district,
                        number: number,
                        password: password,
                        repeatPassword: repeatPassword
                      );
                    }
                    else if(userType == UserType.company) {
                      await insertCompany(
                        email: email,
                        name: name,
                        ruc: lastNameOrRuc,
                        address: address,
                        department: department,
                        district: district,
                        number: number,
                        password: password,
                        repeatPassword: repeatPassword
                      );
                    }

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