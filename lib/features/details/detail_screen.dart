import 'package:flutter/material.dart';
import 'package:movie_app/Components/back_button.dart';
import 'package:movie_app/detail.dart';
import 'package:movie_app/features/details/detail_controller.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.movieId});
  final int movieId;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final DetailController detailController;

  @override
  void initState() {
    super.initState();
    final controllerApis =
        Modular.get<ControllerApi>(); // Lấy controllerApi từ Modular
    final movieId = widget.movieId; // Lấy movieId từ widget

    detailController = DetailController(
        controllerApis, movieId); // Khởi tạo detailController trong initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackBind(
          onPressed: () {
            Modular.to.pop();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: FutureBuilder(
                future: detailController.movieDetails,
                builder: (ctx, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    );
                  } else if (snapshot.hasData || snapshot.data != null) {
                    return CustomDetail(snapshot: snapshot);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(
              child: ListDisplay<Cast>(
                  listFuture: detailController.movieCasts
                      .then((credits) => credits.cast),
                  builder: (snapshot) {
                    return CastAndCrew(cast: snapshot.data!);
                  }),
            ),
            // SizedBox(
            //   child: ListDisplay(
            //     listFuture: movieVideos,
            //     builder: (snapshot) => VideosList(snapshot: snapshot),
            //   ),
            // ),
            SizedBox(
              child: ListDisplay(
                  listFuture: detailController.recommendMovies,
                  builder: (snapshot) => RecommendScreen(snapshot: snapshot)),
            ),
            Padding(
              padding: const EdgeInsets.all(Gap.mL),
              child: AppButton(
                text: "Get ticket",
                onPressed: () {
                  Modular.to.pushNamed('/main/detail/ticket/${widget.movieId}');
                },
                // onPressed: () async {
                //   final result = await showDialog(
                //     context: context,
                //     builder: (BuildContext context) => const CustomAlertDialog(
                //       title: "Alert",
                //       description:
                //           "this movie not in onshowing still booking ?",
                //       confirmText: "continue",
                //       cancelText: "cancel",
                //     ),
                //   );
                //   if (result == true) {
                //     Modular.to.pushNamed(
                //       '/main/detail/ticket/${widget.movieId}',
                //     );
                //   } else {
                //     Navigator.of(context).pop;
                //   }
                // },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
