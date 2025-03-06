import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/text_field_app.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/service/auth_service.dart';
import 'package:movie_app/service/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final authService = AuthService();
  final userService = UserService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  void signup() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final passwordConfirm = _passwordConfirmController.text;
    final name = _nameController.text;
    if (password != passwordConfirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("password not match"),
        ),
      );
      return;
    }
    try {
      final response =
          await authService.signUpWithEmailPassword(email, password);
      if (response.user != null) {
        // save database user
        await userService.insertUserProfile(name);
        await Supabase.instance.client.auth.signOut();

        // Chuyển hướng đến trang đăng nhập
        Modular.to.pushReplacementNamed("/authen/signin");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign up successful! Please log in."),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
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
                  height: 250,
                  width: 300,
                  child: Image.asset('assets/10.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(Gap.mL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFieldApp(
                        hintText: "Username",
                        prefixIcon: const Icon(Icons.person),
                        controller: _nameController,
                      ),
                      TextFieldApp(
                        hintText: "email",
                        prefixIcon: const Icon(Icons.mail),
                        controller: _emailController,
                      ),
                      TextFieldApp(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.password),
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      TextFieldApp(
                        hintText: "Confirm password",
                        prefixIcon: const Icon(Icons.password),
                        obscureText: true,
                        controller: _passwordConfirmController,
                      ),
                      Gap.mdHeight,
                      ElevatedButton(
                        onPressed: signup,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 60),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(vertical: Gap.sM),
                        ),
                        child: TextHead(
                          text: "Sign up",
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Modular.to.navigate("/authen/signin");
                      },
                      child: TextHead(
                        text: "Login",
                        textStyle: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
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
