import 'package:flutter/material.dart';
import 'package:movie_app/manage.dart';

class BookingDetail extends StatefulWidget {
  const BookingDetail({super.key});

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  final seatService = SeatService();
  final couponService = CouponService();
  final bookingService = BookingService();
  late String selectedBookingId;
  int discount = 0; // % giảm giá nếu có coupon
  String couponCode = '';
  String couponid = '';
  bool isPercentage = true;
  @override
  void initState() {
    selectedBookingId = Modular.args.data["bookingid"] ?? '';
    super.initState();
  }

  Future<void> _fetchCouponDiscount() async {
    Coupon? coupon = await couponService.checkCoupondetail(couponid);
    if (coupon != null && mounted) {
      setState(() {
        couponCode = coupon.code;
        discount = coupon.discount;
        isPercentage = coupon.ispercentage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết đặt vé")),
      body: FutureBuilder<List<Seat>>(
        future: seatService.getseat(selectedBookingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có ghế nào được đặt."));
          }

          final seatList = snapshot.data!;
          int totalPrice =
              seatList.fold(0, (sum, seat) => sum + (seat.price ?? 0));
          int discountAmount = isPercentage
              ? (totalPrice * discount ~/ 100) // Dùng ~/ để lấy kết quả nguyên
              : discount;
          int priceAfterDiscount = totalPrice - discountAmount;
          int tax = (totalPrice * 10 ~/ 100);
          int finalTotal = priceAfterDiscount + tax;
          return FutureBuilder(
            future: bookingService.getbookingbyid(selectedBookingId),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Lỗi: ${snapshot.error}"));
              }
              if (!snapshot.hasData) {
                return const Center(child: Text("Vé đã bị huỷ."));
              }
              final bookings = snapshot.data!;
              //check coupon
              if (couponCode.isEmpty &&
                  bookings.couponid != null &&
                  bookings.couponid!.isNotEmpty) {
                couponid = bookings.couponid!;
                _fetchCouponDiscount();
              }
              final showEndTime =
                  ShowtimeHelper.getShowEndTime(bookings.showtime!);
              final datetext = DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(bookings.time!));
              final datetexts = DateFormat('dd/MM/yyyy HH:mm')
                  .format(bookings.showtime!.date);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        FutureBuilder(
                          future: ControllerApi()
                              .fetchMovieDetail(bookings.showtime!.movieid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2));
                            }
                            final movies = snapshot.data;

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: movies!.posterPath!.isNotEmpty
                                          ? Image.network(
                                              '${ApiLink.imagePath}${movies.posterPath}',
                                              width: 90,
                                              height: 130,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              ImageApp.defaultImage,
                                              width: 90,
                                              height: 130,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextHead(
                                              text: movies.originalTitle,
                                              maxLines: 1,
                                              //overflow: TextOverflow.ellipsis,
                                            ),
                                            Gap.smHeight,
                                            Text(
                                                "Time: ${bookings.showtime!.starttime} - ${bookings.showtime!.endtime}"),
                                            Gap.smHeight,
                                            Text("Ngày chiếu: $datetexts"),
                                            Gap.smHeight,
                                            Text("Ngày đặt: $datetext")
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Chip(
                                        label: Text(
                                          bookings.status!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        backgroundColor:
                                            bookings.status! == "paid"
                                                ? Colors.green
                                                : bookings.status! == "canceled"
                                                    ? Colors.grey
                                                    : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: BillingDetails(selectedSeats: seatList),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: PriceDetail(
                        totalPrice: totalPrice,
                        taxAmount: tax,
                        code: couponCode.isNotEmpty
                            ? couponCode
                            : "Không có mã giảm giá",
                        discountAmount: discountAmount,
                        finalPrice: finalTotal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'Hủy đơn',
                              onPressed: (bookings.status == "paid" &&
                                      showEndTime.isBefore(DateTime.now()))
                                  ? () => ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text("không thể huỷ đơn do dã hết hạn")))
                                  : () => _onCancel(selectedBookingId),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppButton(
                                text: 'Thanh toán',
                                onPressed: () {
                                  if (bookings.status == "canceled" ||
                                      bookings.status == "paid" ||
                                      showEndTime.isBefore(DateTime.now())) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Không thể thanh toán do hết hạn hoặc bị huỷ")),
                                    );
                                  } else {
                                    _onUpdate(selectedBookingId);
                                  }
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  _onUpdate(String bookingid) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) => const CustomAlertDialog(
        title: "Xác nhận",
        description: "Xác nhận thanh toán",
        confirmText: "Có",
        cancelText: "Không",
      ),
    );
    if (result == true) {
      await bookingService.updatestatus(bookingid);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật thành công")),
      );
      Navigator.pop(context, true);
    }
  }

  _onCancel(String bookingid) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) => const CustomAlertDialog(
        title: "Xác nhận",
        description: "Bạn có chắc chắn muốn hủy đơn đặt vé này?",
        confirmText: "Có",
        cancelText: "Không",
      ),
    );

    if (result == true) {
      bookingService.updatestatusCancel(bookingid);
      seatService.deleteSeat(bookingid);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đơn đặt vé đã bị hủy.")),
      );
      Navigator.pop(context, true);
    }
  }
}
