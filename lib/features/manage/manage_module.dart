import 'package:movie_app/manage.dart';

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
    r.child(ManageRoute.rootBooking, child: (ctx) => const ManageBooking());
    r.child(ManageRoute.rootHall, child: (ctx) => const ManageHall());
    r.child(ManageRoute.rootbookdetail, child: (ctx) => const BookingDetail());
    r.child(ManageRoute.rootcoupon, child: (ctx) => const ManageCoupon());
    r.child(ManageRoute.rootstatistic, child: (ctx) => const ManageStatitics());
    r.child(ManageRoute.rootstmonth, child: (ctx) => const StatisticMonth());
    r.child(ManageRoute.rootstmovie, child: (ctx) => const StatisticMovie());
  }
}
