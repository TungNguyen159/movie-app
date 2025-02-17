import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/features/authentication/screen/sign_in_screen.dart';
import 'package:movie_app/router/main_route.dart';

class AuthenModule extends Module {
  @override
  void binds(Injector i) {
    // TODO: implement binds
    super.binds(i);
  }

  @override
  void routes(r) {
    r.child(MainRoute.root, child: (ctx) => const SignInScreen());
  }
}
