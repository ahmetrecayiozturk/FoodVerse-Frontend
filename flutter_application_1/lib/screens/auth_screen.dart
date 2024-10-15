import 'package:flutter/material.dart';
import 'package:foodverse_frontend/screens/addfilteroraskgpt_screen.dart';
import 'package:foodverse_frontend/screens/userprofile_screen.dart';
import 'package:foodverse_frontend/services/auth_service.dart' as auth;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class User {
  final String email;
  final String password;

  User({required this.email, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
    );
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        notificationPredicate: (notification) => true,
        title: const Text(''),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.red,
                Colors.red,
              ],
            ),
          ),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/foodverse2.png'),
              const SizedBox(height: 10.0), // Boşluk burada eklendi
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: _buildTextField(
                  _emailController,
                  'E-mail',
                ),
              ),
              const SizedBox(height: 10.0), // Boşluk burada eklendi
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: _buildTextField(_passwordController, 'Password',
                    isPassword: true),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.orange),
                ),
              const SizedBox(height: 25.0), // Boşluk burada eklendi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildElevatedButton(
                    'Register',
                    Colors.orange,
                    Colors.orange,
                    () async {
                      bool success = await auth.AuthService().registerUser(
                          _emailController.text, _passwordController.text);
                      if (success) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddorFilterPage(
                                    user: User(
                                        email: _emailController.text,
                                        password: _passwordController.text))));
                      } else {
                        setState(() {
                          _errorMessage =
                              'Registration failed. Please try again.';
                        });
                      }
                    },
                  ),
                  _buildElevatedButton(
                    '    Login    ',
                    Colors.orange,
                    Colors.orange,
                    () async {
                      bool success = await auth.AuthService().loginUser(
                          _emailController.text, _passwordController.text);
                      if (success) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfileScreen(
                                    user: User(
                                        email: _emailController.text,
                                        password: _passwordController.text))));
                      } else {
                        setState(() {
                          _errorMessage =
                              'There is an error in login, please check username or password.';
                        });
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    IconData icon;
    if (label == 'E-mail') {
      icon = Icons.person_2;
    } else {
      icon = Icons.key;
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(icon), // icon'u burada kullanabilirsiniz
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildElevatedButton(
      String text, Color color, Color highlight, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 5,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: Text(text),
    );
  }
}