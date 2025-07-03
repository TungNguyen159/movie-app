import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/auth.dart';


class AuthenModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(r) {
    r.child(MainRoute.root, child: (ctx) => const AuthGate());
    r.child(AuthenRoute.root, child: (ctx) => const OnboardingScreen());
    r.child(AuthenRoute.rootsingin, child: (ctx) => const SignInScreen());
    r.child(AuthenRoute.rootsingup, child: (ctx) => const SignUpScreen());
    r.child(AuthenRoute.rootforgot, child: (ctx) => const ForgotPassword());
    r.child(AuthenRoute.rootreset, child: (ctx) => const ResetPassword());
  }
}
