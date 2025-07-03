import 'package:flutter/material.dart';
import 'package:movie_app/Components/back_button.dart';
import 'package:movie_app/Components/showtime_helper.dart';
import 'package:movie_app/detail.dart';
import 'package:movie_app/features/details/detail_controller.dart';
import 'package:movie_app/features/details/widgets/review_list_item.dart';
import 'package:movie_app/models/showtime.dart';
import 'package:movie_app/service/favourite_service.dart';
import 'package:movie_app/service/review_service.dart';
import 'package:movie_app/service/showtime_service.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.movieId});
  final int movieId;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final DetailController detailController;
  final favoriteService = FavoriteService();
  final reviewService = ReviewService();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    detailController = DetailController(
      Modular.get<ControllerApi>(),
      widget.movieId,
    );
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    String? favorid = await favoriteService.checkIfFavorite(widget.movieId);
    setState(() {
      isFavorite = favorid != null;
    });
  }

  final showtimeService = ShowtimeService();
  void _checkShowtimeAndNavigate() async {
    List<Showtime> showtimes =
        await showtimeService.getShowtimeMovieid(widget.movieId);

    final List<Showtime> filteredShowtimeList = showtimes
        .where((show) =>
            show.status?.toLowerCase() != "canceled" &&
            ShowtimeHelper.getShowEndTime(show).isAfter(DateTime.now()) &&
            show.halls!.status?.toLowerCase() != "closed")
        .toList();

    if (filteredShowtimeList.isNotEmpty) {
      Modular.to.pushNamed('/main/detail/ticket/${widget.movieId}');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Thông báo"),
            content: const Text(
                "Phim này hiện không có suất chiếu hoặc không có phòng!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          );
                        } else if (snapshot.hasData || snapshot.data != null) {
                          final snapshots = snapshot.data!;
                          return CustomDetail(snapshot: snapshots);
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    child: ListDisplay<Cast>(
                        listFuture: detailController.movieCasts
                            .then((credits) => credits.cast),
                        builder: (snapshot) {
                          return CastAndCrew(cast: snapshot);
                        }),
                  ),
                  SizedBox(
                    child: ListDisplay(
                        listFuture: detailController.recommendMovies,
                        builder: (snapshot) =>
                            RecommendScreen(snapshot: snapshot)),
                  ),
                  SizedBox(
                    child: ListDisplay(
                        listFuture: reviewService.getReviews(widget.movieId),
                        builder: (review) => ReviewListItem(reviews: review)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Gap.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1, // Chiếm 1/5 tổng width (1 phần)
                  child: IconButton(
                    onPressed: () async {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      if (isFavorite) {
                        await favoriteService.insertfavorite(widget.movieId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Đã thêm vào yêu thích!")),
                        );
                      } else {
                        await favoriteService.deletefavorite(widget.movieId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Đã xóa khỏi yêu thích!")),
                        );
                      }
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_outline,
                      color: isFavorite
                          ? Colors.red
                          : Theme.of(context).colorScheme.onPrimary,
                      size: 30,
                    ),
                  ),
                ),
                Gap.mLWidth,
                Expanded(
                  flex: 4, // Chiếm 4/5 tổng width (4 phần)
                  child: AppButton(
                    text: "Get Ticket",
                    onPressed: _checkShowtimeAndNavigate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
