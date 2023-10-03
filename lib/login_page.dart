import 'package:flutter/material.dart';
import 'homePage.dart';
import 'models/database_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dbHelper = DatabaseHelper();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors
              .blue, // Ubah warna ini sesuai dengan warna yang Anda inginkan
          primaryColor: Color(
              0xffB81736), // Ini juga merupakan warna yang Anda gunakan di atas
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('LOGIN'),
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: Column(children: [
                  //logo
                  const SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                    'images/MU.png',
                    height: 150,
                  ),
                  //Nama App
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "MycashBook",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color(0xffB81736)),
                  ),
                  //Username
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                        hintText: "Username",
                        suffixIcon: Icon(Icons.check, color: Colors.black),
                        label: Text(
                          'Username',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736)),
                        )),
                  ),
                  //Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        suffixIcon:
                            Icon(Icons.visibility_off, color: Colors.black),
                        label: Text(
                          'Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736)),
                        )),
                  ),
                  //Button Login
                  const SizedBox(
                    height: 25,
                  ),
                  // Container(
                  //   height: 35,
                  //   width: 200,
                  // ),
                  Container(
                    height: 35,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          foregroundColor: Colors.grey,
                          backgroundColor: Color(0xffB81736)),
                      child: Text(
                        'LOGIN',
                      ),
                      onPressed: () async {
                        bool isValidUser = await dbHelper.login(
                            usernameController.text, passwordController.text);
                        if (isValidUser) {
                          final userData = await dbHelper
                              .getUserData(usernameController.text);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(userData),
                            ),
                          );
                        } else {
                          print('Login gagal');
                        }
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ));
  }
}
