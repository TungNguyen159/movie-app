import 'package:flutter/material.dart';
import 'package:movie_app/Components/text_field_app.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/features/authentication/screen/sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 250,
            width: 300,
            child: Image.asset('5.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(Gap.mL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextFieldApp(
                  hintText: "Username",
                  prefixIcon: Icon(Icons.person),
                ),
                const TextFieldApp(
                  hintText: "email",
                  prefixIcon: Icon(Icons.mail),
                ),
                const TextFieldApp(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.password),
                  obscureText: true,
                ),
                const TextFieldApp(
                  hintText: "Confirm password",
                  prefixIcon: Icon(Icons.password),
                  obscureText: true,
                ),
                Gap.mdHeight,
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const SignInScreen(),
                      ),
                    );
                  },
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
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextHead(text: "Already have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const SignInScreen()));
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
          )
        ],
      ),
    );
  }
}
