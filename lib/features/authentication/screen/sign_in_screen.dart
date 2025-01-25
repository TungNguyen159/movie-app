import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/text_field_app.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/features/authentication/screen/sign_up_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Gap.sm),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Image.asset('5.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(Gap.mL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TextFieldApp(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.mail),
                  ),
                  const TextFieldApp(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.password),
                    obscureText: true,
                  ),
                  Gap.mdHeight,
                  ElevatedButton(
                    onPressed: () {
                      Modular.to.navigate("/");
                    },
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
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextHead(text: "Dont have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const SignUpScreen()));
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
          ],
        ),
      ),
    );
  }
}
