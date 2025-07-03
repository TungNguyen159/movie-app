import 'package:flutter/material.dart';
import 'package:movie_app/features/Onshowing/widgets/showtime_status.dart';
import 'package:movie_app/manage.dart';
import 'package:movie_app/models/movie_detail.dart';


class ShowtimeListItem extends StatelessWidget {
  const ShowtimeListItem({super.key, required this.showtime});
  final List<Showtime> showtime;

  @override
  Widget build(BuildContext context) {
    oneditStatus(BuildContext context, Showtime showtime) {
      String selectedStatus = showtime.status!;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Chỉnh sửa trạng thái"),
          content: DropdownButtonFormField<String>(
            value: selectedStatus,
            items: ["available", "finished","canceled"].map((role) {
              return DropdownMenuItem(
                  value: role, child: Text(role.toUpperCase()));
            }).toList(),
            onChanged: (value) => selectedStatus = value!,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy")),
            ElevatedButton(
              onPressed: () async {
                final hasBooking =
                    await BookingService().checkbookingstatus(showtime);
                if (selectedStatus == "canceled" && hasBooking) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("vui lòng huỷ toàn bộ vé"),
                    ),
                  );
                  return;
                }
                Navigator.of(context).pop();
                ShowtimeService().updateStatusST(selectedStatus, showtime);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("update successful!.")),
                );
              },
              child: const Text("Lưu"),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: showtime.length,
      itemBuilder: (context, index) {
        final showtimes = showtime[index];
        final dateText = DateFormat('dd/MM/yyyy').format(showtimes.date);
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FutureBuilder lấy thông tin phim
                FutureBuilder<MovieDetail>(
                  future: ControllerApi().fetchMovieDetail(showtimes.movieid!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: 50,
                        height: 75,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    final movie = snapshot.data;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: movie!.posterPath!.isNotEmpty
                          ? Image.network(
                              '${ApiLink.imagePath}${movie.posterPath}',
                              width: 60,
                              height: 90,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              ImageApp.defaultImage,
                              width: 60,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                    );
                  },
                ),
                const SizedBox(width: 12),

                // Thông tin chi tiết
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<MovieDetail>(
                        future: ControllerApi()
                            .fetchMovieDetail(showtimes.movieid!),
                        builder: (context, snapshot) {
                          final movie = snapshot.data;
                          return TextHead(
                            text: movie?.title ?? "Không có tiêu đề",
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
                          Text("Time: ${showtimes.starttime}",
                              style: TextStyle(color: Colors.grey[700])),
                          const SizedBox(width: 5),
                          Text("- ${showtimes.endtime}",
                              style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder<Hall>(
                        future: HallService().fetchHallById(showtimes.hallid!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Text("Không có dữ liệu phòng");
                          }
                          final halls = snapshot.data!;
                          return Text(
                            "Phòng ${halls.nameHall} - ${halls.status}",
                            style: TextStyle(color: Colors.grey[700]),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text("Giá vé ${showtimes.price} / vé",
                          style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(height: 4),
                      Text(
                        "Ngày chiếu $dateText",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Status: ${showtimes.status!}",
                        style: TextStyle(
                          color: showtimes.status == "available"
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Showtimestatus(
                        date: showtimes.date,
                        starttime: showtimes.starttime,
                        endtime: showtimes.endtime,
                      )
                    ],
                  ),
                ),
                // Nút chỉnh sửa và xóa
                Column(
                  children: [
                    IconButton(
                      onPressed: () => oneditStatus(context, showtimes),
                      icon: const Icon(Icons.settings, color: Colors.orange),
                    ),
                    IconButton(
                      onPressed: () async {
                        final now = DateTime.now();
                        final start =
                            ShowtimeHelper.getShowStartTime(showtimes);
                        if (now.isBefore(start)) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddShowtimeScreen(showtime: showtimes),
                            ),
                          );
                        } else {
                          // Nếu đã quá giờ chiếu
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Không thể chỉnh sửa vì suất chiếu đã bắt đầu."),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.edit, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () => _onDelete(showtimes, context),
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

  void _onDelete(Showtime showtime, BuildContext context) async {
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
      try {
        final hasBooking = await BookingService().checkbookingstatus(showtime);
        if (hasBooking) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Suất chiếu này đã có người đặt vé vui lòng huỷ toàn bộ vé")),
          );
          return;
        }
        await ShowtimeService().deleteShowtime(showtime);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Xóa thành công!")),
        );
      } catch (e) {
        final errorMessage = e.toString().toLowerCase();
        if (errorMessage.contains('permission denied')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Bạn không có quyền xóa!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Xóa thất bại: $e")),
          );
        }
      }
    }
  }
}
