import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/config/api_handle.dart';
import 'package:movie_app/config/api_link.dart';
import 'package:movie_app/core/image/image_app.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/features/Yourbooking/formreviews.dart';
import 'package:movie_app/features/Yourbooking/widget/detail_booking_dialog.dart';
import 'package:movie_app/models/booking.dart';
import 'package:movie_app/service/showtime_service.dart';

class BookingListItem extends StatelessWidget {
  const BookingListItem({super.key, required this.booking});

  final List<Booking> booking;

  @override
  Widget build(BuildContext context) {
    final controllerApis = ControllerApi();
    final showtimeService = ShowtimeService();
    // await showtimeService.fetchmovieid(data.showtimeid);
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.md),
        child: ListView.builder(
          itemCount: booking.length,
          itemBuilder: (ctx, index) {
            final bookings = booking[index];

            return Padding(
              padding: const EdgeInsets.only(top: Gap.sm),
              child: InkWell(
                onTap: () {
                  showGeneralDialog(
                    barrierColor:
                        Colors.black.withOpacity(0.5), // Đặt màu nền mờ
                    transitionDuration: const Duration(milliseconds: 400),
                    barrierDismissible: false,
                    barrierLabel: '',
                    context: context,
                    transitionBuilder: (context, a1, a2, dialog) {
                      final offset =
                          MediaQuery.of(context).size.height * (1 - a1.value);

                      return Transform.translate(
                        offset: Offset(0, offset), // Di chuyển dọc
                        child: Opacity(opacity: a1.value, child: dialog),
                      );
                    },
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Center(
                      child: Material(
                        color: Colors.transparent, // Để không có màu nền
                        child: DetailBookingDialog(
                          bookingid: bookings.bookingid!,
                          couponid: bookings.couponid ?? "",
                          status: bookings.status!,
                        ),
                      ),
                    ),
                  );
                },
                child: FutureBuilder(
                  future:
                      showtimeService.fetchbyshowtimeid(bookings.showtimeid),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text("Không có dữ liệu phim"));
                    }

                    final showtimes = snapshot.data!;
                    final dateText =
                        DateFormat('dd/MM/yyyy').format(showtimes.date);
                    return FutureBuilder(
                        future:
                            controllerApis.fetchMovieDetail(showtimes.movieid),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                                child: Text("Không có dữ liệu phim"));
                          }
                          final movie = snapshot.data!;
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          "${ApiLink.imagePath}${movie.posterPath}",
                                          height: 120,
                                          width: 90,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              ImageApp.defaultImage,
                                              height: 120,
                                              width: 90,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: Gap.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              movie.originalTitle,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                              maxLines: 2,
                                            ),
                                            const SizedBox(height: Gap.sm),
                                            Row(
                                              children: [
                                                const Icon(Icons.date_range,
                                                    size: 16),
                                                const SizedBox(width: 4),
                                                Text(dateText),
                                              ],
                                            ),
                                            const SizedBox(height: Gap.xs),
                                            Row(
                                              children: [
                                                const Icon(Icons.schedule,
                                                    size: 16),
                                                const SizedBox(width: 4),
                                                Text(
                                                    "${showtimes.starttime} - ${showtimes.endtime}"),
                                              ],
                                            ),
                                            const SizedBox(height: Gap.xs),
                                            Row(
                                              children: [
                                                const Icon(Icons.meeting_room,
                                                    size: 16),
                                                const SizedBox(width: 4),
                                                Text(
                                                    "Phòng ${showtimes.halls!.nameHall}"),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.attach_money,
                                                    color: Colors.green,
                                                    size: 20),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "${bookings.totalprice} VND",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.green[700],
                                                      ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Gap.md),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      bookings.status! == "paid" &&
                                              bookings.isreviewed == false
                                          ? TextButton.icon(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            Formreviews(
                                                              movieId: showtimes
                                                                  .movieid!,
                                                              bookingid: bookings
                                                                  .bookingid!,
                                                            )));
                                              },
                                              icon: const Icon(
                                                  Icons.rate_review_outlined,
                                                  color: Colors.blue),
                                              label: const Text(
                                                "Đánh giá phim",
                                              ),
                                            )
                                          : const SizedBox(width: 1),
                                      _buildStatusChip(bookings.status!),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor;
    String statusText;

    switch (status.toLowerCase()) {
      case "paid":
        statusColor = Colors.green;
        statusText = "Đã thanh toán";
        break;
      case "pending":
        statusColor = Colors.orange;
        statusText = "Chờ xác nhận";
        break;
      case "canceled":
        statusColor = Colors.red;
        statusText = "Đã hủy";
        break;
      default:
        statusColor = Colors.grey;
        statusText = "Không xác định";
    }

    return Chip(
      label: Text(statusText, style: const TextStyle(color: Colors.white)),
      backgroundColor: statusColor,
    );
  }
}
