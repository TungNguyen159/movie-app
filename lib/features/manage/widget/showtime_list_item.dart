import 'package:flutter/material.dart';
import 'package:movie_app/Components/alert_dialog.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/app.dart';
import 'package:movie_app/features/manage/screen/add_showtime.dart';
import 'package:movie_app/models/showtime.dart';
import 'package:movie_app/service/hall_service.dart';
import 'package:movie_app/service/showtime_service.dart';

class ShowtimeListItem extends StatelessWidget {
  const ShowtimeListItem({super.key, required this.showtime});
  final List<Showtime> showtime;

  @override
  Widget build(BuildContext context) {
    _onDelete(Showtime showtimeid) async {
      final result = await showDialog(
        context: context,
        builder: (BuildContext context) => const CustomAlertDialog(
          title: "Xác nhận",
          description: "Bạn có chắc chắn muốn xóa suất chiếu này?",
          confirmText: "Có",
          cancelText: "Không",
        ),
      );
      if (result == true) {
        await ShowtimeService().deleteShowtime(showtimeid);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Xóa thành công!")),
        );
      }
    }

    return ListView.builder(
      itemCount: showtime.length,
      itemBuilder: (context, index) {
        final showtimes = showtime[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Icon phim
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      const Icon(Icons.movie, size: 30, color: Colors.black54),
                ),
                const SizedBox(width: 12),

                // Thông tin phim
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<String>(
                        future: ControllerApi().getitle(showtimes.movieid!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          }
                          return TextHead(
                            text: snapshot.data ?? "Không có tiêu đề",
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "Time: ${showtimes.starttime}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Price: ${showtimes.ticketprice}đ",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder(
                        future: HallService().fetchHallById(showtimes.hallid!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 15,
                              width: 15,
                              child:
                                  CircularProgressIndicator(strokeWidth: 1.5),
                            );
                          }

                          return TextHead(
                            text: "Hall ${snapshot.data?['name']}",
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Nút chỉnh sửa và xoá
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddShowtimeScreen(showtime: showtimes),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () => _onDelete(showtimes),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
