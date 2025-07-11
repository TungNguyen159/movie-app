import 'package:flutter/material.dart';
import 'package:movie_app/checking.dart';
class CheckingScreen extends StatefulWidget {
  final Map movie;
  final int movieId;
  const CheckingScreen({
    super.key,
    required this.movie,
    required this.movieId,
  });

  @override
  State<CheckingScreen> createState() => _CheckingScreenState();
}

class _CheckingScreenState extends State<CheckingScreen> {
  late final Future<MovieDetail> movieDetails;
  late List<Seat> selectedSeat;
  late String selectedShowtimeId;
  final seatService = SeatService();
  @override
  void initState() {
    super.initState();
    movieDetails = ControllerApi().fetchMovieDetail(widget.movieId);
    selectedSeat = Modular.args.data['selectedSeat'];
    selectedShowtimeId = Modular.args.data['selectedShowtimeId'];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: BackBind(onPressed: () {
          Modular.to.pop();
        }),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
        title: const TextHead(text: "Checking"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Gap.mL),
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        height: 500,
                        child: FutureBuilder<MovieDetail>(
                          future: movieDetails,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text("Error loading image"));
                            } else {
                              String imageUrl = snapshot.data?.posterPath ?? '';
                              return Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageUrl.isNotEmpty
                                          ? NetworkImage(
                                              '${ApiLink.imagePath}$imageUrl')
                                          : AssetImage(ImageApp.defaultImage),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(Gap.sM),
                                        topRight: Radius.circular(Gap.sM))),
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        height: 50,
                        width: double.maxFinite,
                        color: const Color.fromARGB(255, 252, 205, 212),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 252, 205, 212),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 10,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(Gap.sM),
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return Flex(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      direction: Axis.horizontal,
                                      children: List.generate(
                                        (constraints.constrainWidth() / 15)
                                            .floor(),
                                        (index) => const SizedBox(
                                          width: 5,
                                          height: 1,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              width: 10,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedSeat.length,
                    itemBuilder: (ctx, index) {
                      Seat seat = selectedSeat[index]; // Lấy ghế hiện tại
                      return TicketItem(
                        seatNumber: seat.seatnumber!, // Hiển thị số ghế
                        price: seat.price!, // Hiển thị loại ghế (normal/vip)
                        type: seat.type,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Nút "Pay" nằm ở cuối màn hình, không bị cuộn
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Gap.mL, vertical: Gap.sM),
            child: AppButton(
              text: "Confirm",
              onPressed: () async {
                try {
                  // Nếu lưu thành công, chuyển hướng sang trang xác nhận
                  Modular.to.pushReplacementNamed(
                    "/main/detail/ticket/payment",
                    arguments: {
                      "selectedSeat": selectedSeat,
                      "selectedShowtimeId": selectedShowtimeId,
                    },
                  );
                } catch (e) {
                  // Hiển thị lỗi nếu có
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lỗi khi lưu ghế: $e")),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
