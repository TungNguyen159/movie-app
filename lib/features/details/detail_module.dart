import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/config/api_handle.dart';
import 'package:movie_app/features/details/detail_route.dart';
import 'package:movie_app/features/details/detail_screen.dart';

class DetailModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(ControllerApi.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(DetailRoute.rootId, child: (context) {
      final movieId = r.args.params['movieId']; // Lấy movieId từ arguments
      return DetailScreen(movieId: int.parse(movieId));
    });
  }
}
