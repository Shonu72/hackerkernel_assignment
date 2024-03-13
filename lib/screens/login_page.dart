import 'package:flutter/material.dart';
import 'package:hackerkernel/screens/home_screen.dart';
import 'package:hackerkernel/services/auth_service.dart';
import 'package:hackerkernel/widgets/custom_alert.dart';
import 'package:hackerkernel/widgets/text_field_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    if (await AuthenticationApi.isUserLoggedIn()) {
      _navigateToHomeScreen();
    }
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    final bool loggedIn = await AuthenticationApi.login(email, password);

    if (loggedIn) {
      _navigateToHomeScreen();
    } else {
      _showErrorDialog();
    }

    setState(() {
      isLoading = false;
    });
  }

  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: "Login Failed!",
          content: "Invalid email or password.",
          buttonText: "OK",
          onPressed: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'assets/login.png',
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: emailController,
                        hintText: "Enter email id",
                        prefixIcon: const Icon(Icons.email),
                        obscureText: false,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: passwordController,
                        hintText: "Enter Password",
                        suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(
                            double.infinity,
                            50,
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("or", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(
                            double.infinity,
                            50,
                          ),
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Image.asset(
                              'assets/google.png',
                              fit: BoxFit.contain,
                              height: 30,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("New to logistics?"),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Register Now",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
