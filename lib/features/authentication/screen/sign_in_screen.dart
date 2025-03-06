import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/text_field_app.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/service/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response =
          await authService.signInWithEmailPassword(email, password);
      if (response.user != null) {
        Modular.to.navigate("/");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login sucsessful !")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Login failed. Please check your credentials.")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("errror :$e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.asset("assets/10.png"),
                ),
                Padding(
                  padding: const EdgeInsets.all(Gap.mL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFieldApp(
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.mail),
                        controller: _emailController,
                      ),
                      TextFieldApp(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.password),
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      Gap.mdHeight,
                      ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 60),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: TextHead(
                          text: "login",
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Gap.mLHeight,
                      TextHead(
                        text: "Forgot password?",
                        textStyle: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Modular.to.navigate("/authen/signup");
                          },
                          child: TextHead(
                            text: "Sign up",
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
