import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/app_button.dart';
import 'package:movie_app/Components/back_button.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/config/api_handle.dart';
import 'package:movie_app/config/api_link.dart';
import 'package:movie_app/core/image/image_app.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/features/Checking/widgets/ticket_item.dart';
import 'package:movie_app/models/movie_detail.dart';
import 'package:movie_app/models/seat.dart';

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
  late String selectedDate;
  late String selectedTime;
  @override
  void initState() {
    super.initState();
    movieDetails = ControllerApi().fetchMovieDetail(widget.movieId);
    selectedSeat = Modular.args.data['selectedSeat'];
    selectedDate = Modular.args.data['selectedDate'];
    selectedTime = Modular.args.data['selectedTime'];
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
        title: FutureBuilder<MovieDetail>(
          future: movieDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading..."); // Hiển thị khi đang tải
            } else if (snapshot.hasError) {
              return const Text("Error loading title"); // Lỗi
            } else {
              return Text(snapshot.data!.originalTitle, // In ra title
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold));
            }
          },
        ),
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
                        child: Padding(
                          padding: const EdgeInsets.all(Gap.sM),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextHead(text: selectedDate),
                              TextHead(text: selectedTime),
                            ],
                          ),
                        ),
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
                      return TicketItem(
                        seatNumber: selectedSeat[index].id,
                        price: selectedSeat[index].price.toString(),
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
              onPressed: () {
                Modular.to.pushNamed(
                  "/main/detail/ticket/seat/payment",
                  arguments: {
                    "selectedSeat": selectedSeat,
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
