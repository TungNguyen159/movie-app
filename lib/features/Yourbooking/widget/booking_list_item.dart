import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/config/api_link.dart';
import 'package:movie_app/core/image/image_app.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/features/Yourbooking/widget/detail_booking_dialog.dart';

class BookingListItem extends StatelessWidget {
  const BookingListItem({
    super.key,
    required this.snapshot,
  });
  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    void bookdetail() {}

    return Scaffold(
      body: Container(
        margin:
            const EdgeInsets.symmetric(horizontal: Gap.sM, vertical: Gap.sM),
        width: double.infinity,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (ctx, index) {
            final data = snapshot.data[index];
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
                      final offset = MediaQuery.of(context).size.height *
                          (1 - a1.value);

                      return Transform.translate(
                        offset: Offset(0, offset), // Di chuyển dọc
                        child: Opacity(opacity: a1.value, child: dialog),
                      );
                    },
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Center(
                      child: Material(
                        color: Colors.transparent, // Để không có màu nền
                        child: DetailBookingDialog(posterurl: data.posterPath),
                      ),
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    ClipRRect(
                      child: Image.network(
                        "${ApiLink.imagePath}${data.posterPath}",
                        height: 120,
                        width: 100,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            ImageApp.defaultImage,
                            height: 120,
                            width: 100,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: Gap.sm),
                    // Information Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHead(
                            text: data.originalTitle,
                            maxLines: 2,
                            textStyle: Theme.of(context).textTheme.titleMedium,
                          ),
                          Gap.xsHeight,
                          Row(
                            children: [
                              TextHead(
                                text: data.voteAverage.toString(),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.star,
                                  color: Colors.yellow, size: 16),
                            ],
                          ),
                          Gap.xsHeight,
                          Row(
                            children: [
                              const Icon(Icons.date_range_outlined, size: 16),
                              const SizedBox(width: 4),
                              Text("Monday 13",
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                          Gap.xsHeight,
                          Row(
                            children: [
                              const Icon(Icons.timer, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "15:00 PM",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Gap.sm),
                    Container(
                      height: 120, // Đảm bảo chiều cao bằng với Image
                      width: 50, // Đặt chiều rộng cố định
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.local_activity_sharp,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          TextHead(
                            text: "10",
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
