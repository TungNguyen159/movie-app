import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/app.dart';
import 'package:movie_app/features/manage/screen/manage.dart';
import 'package:movie_app/features/manage/screen/manage_showtime.dart';
import 'package:movie_app/features/manage/screen/manage_user.dart';
import 'package:movie_app/router/main_route.dart';

class ManageModule extends Module {
  @override
  void binds(Injector i) {
    // TODO: implement binds
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(MainRoute.root, child: (ctx) => const ManageScreen());
    r.child(ManageRoute.rootUser, child: (ctx) => const ManageUser());
    r.child(ManageRoute.rootShowtime, child: (ctx) => const ManageShowtime());
  }
}
