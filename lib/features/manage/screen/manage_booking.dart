import 'package:flutter/material.dart';
import 'package:movie_app/manage.dart';


class ManageBooking extends StatefulWidget {
  const ManageBooking({super.key});

  @override
  State<ManageBooking> createState() => _ManageBookingState();
}

class _ManageBookingState extends State<ManageBooking> {
  final bookingService = BookingService();
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  List<Booking> allBookings = [];
  List<Booking> filteredBookings = [];

  // Lựa chọn status để lọc
  String selectedStatus = 'Tất cả'; // Mặc định là "Tất cả"

  // Hàm lọc booking
  void _filterBookings(String query, String status) {
    setState(() {
      filteredBookings = allBookings.where((booking) {
        final lowerQuery = query.toLowerCase();
        final bookingId = booking.bookingid?.toLowerCase() ?? "";
        final bookingStatus = booking.status?.toLowerCase() ?? "";

        // Lọc theo bookingid và status
        final matchBookingId = bookingId.contains(lowerQuery);
        final matchStatus =
            status == 'Tất cả' || bookingStatus.contains(status.toLowerCase());

        return matchBookingId && matchStatus;
      }).toList();
    });
  }

  // Hàm gọi khi người dùng gõ vào ô tìm kiếm, sử dụng debounce
  void _onSearchChanged(String value) {
    _filterBookings(value, selectedStatus);
  }

  // Hàm tải lại dữ liệu (refresh)
  Future<void> _refreshData() async {
    setState(() {});
  }

  // Hàm thay đổi status để lọc
  void _onStatusChanged(String? value) {
    setState(() {
      selectedStatus = value ?? 'Tất cả';
      _filterBookings(
          searchController.text, selectedStatus); // Lọc lại theo status mới
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách đặt vé")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: SearchBox(
                    onChanged: _onSearchChanged,
                    focusNode: searchFocusNode,
                    controller: searchController,
                  ),
                ),
                Gap.smWidth,
                DropdownButton<String>(
                  value: selectedStatus,
                  items:
                      ['Tất cả', 'paid', 'pending', 'canceled'].map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: _onStatusChanged,
                ),
              ],
            ),
          ),
          Gap.sMHeight,
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: StreamBuilder<List<Booking>>(
                stream: bookingService.streambooking,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Lỗi: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Không có suất chiếu nào."));
                  }
              
                  allBookings = snapshot.data!;
                  if (searchController.text.isEmpty &&
                      selectedStatus == 'Tất cả') {
                    filteredBookings = allBookings;
                  }
                  return BookingListItem(
                    bookingList: filteredBookings,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
