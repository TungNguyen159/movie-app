import 'package:flutter/material.dart';
import 'package:movie_app/features/manage/screen/add_showtime.dart';
import 'package:movie_app/features/manage/widget/showtime_list_item.dart';
import 'package:movie_app/models/showtime.dart';
import 'package:movie_app/service/showtime_service.dart';

class ManageShowtime extends StatefulWidget {
  const ManageShowtime({super.key});

  @override
  State<ManageShowtime> createState() => _ManageShowtimeState();
}

class _ManageShowtimeState extends State<ManageShowtime> {
  final showtimeService = ShowtimeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Showtime"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<List<Showtime>>(
                      stream: showtimeService.streamShowtime,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text("Lỗi: ${snapshot.error}"));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text("Không có suất chiếu nào."));
                        }

                        final List<Showtime> showtimeList = snapshot.data!;

                        return ShowtimeListItem(showtime: showtimeList);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => const AddShowtimeScreen()),
                    );
                  },
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
