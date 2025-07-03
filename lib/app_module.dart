import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/app.dart';
import 'package:movie_app/features/authentication/authen_controller.dart';
import 'package:movie_app/service/auth_service.dart';
import 'package:movie_app/service/user_service.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(AuthService());
    i.addInstance(UserService());
    i.addLazySingleton(AuthenController.new);
    i.addLazySingleton(ControllerApi.new);
    i.addLazySingleton(HomeController.new);
    i.addLazySingleton(DetailController.new);
  }

  String get initialRoute => '/';
  @override
  void routes(r) {
    r.module("/", module: SplashModule());
    r.module(AuthenRoute.root, module: AuthenModule());
    r.module(HomeRoute.root, module: HomeModule());
    r.module(DetailRoute.root, module: DetailModule());
    r.module(TicketRoute.root, module: TicketModule());
    r.module(CheckingRoute.root, module: CheckingModule());
    r.module(SettingRoute.root, module: SettingModule());
    r.module(ManageRoute.root, module: ManageModule());
    r.child("/main", child: (context) => const BottomBar());
  }
}
