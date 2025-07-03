import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/features/Search/widgets/search_box.dart';
import 'package:movie_app/features/manage/widget/user_list_item.dart';
import 'package:movie_app/models/user.dart';
import 'package:movie_app/service/user_service.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode(); // Tạo FocusNode để quản lý focus
  final userService = UserService();
  List<Users> allusers = [];
  List<Users> filteredusers = [];

  // Lựa chọn status để lọc
  String selectedStatus = 'Tất cả';

  void _filterUsers(String query, String status) {
    setState(() {
      filteredusers = allusers.where((user) {
        final lowerQuery = query.toLowerCase();
        final name = user.name.toLowerCase();
        final userRole = user.role?.toLowerCase() ?? "";

        // Lọc theo bookingid và status
        final matchusername = name.contains(lowerQuery);
        final matchStatus =
            status == 'Tất cả' || userRole.contains(status.toLowerCase());

        return matchusername && matchStatus;
      }).toList();
    });
  }

  void _onSearchChanged(String value) {
    _filterUsers(value, selectedStatus);
  }

  // Hàm thay đổi status để lọc
  void _onStatusChanged(String? value) {
    setState(() {
      selectedStatus = value ?? 'Tất cả';
      _filterUsers(
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
      appBar: AppBar(
        title: const Text("User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SearchBox(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    onChanged: _onSearchChanged,
                  ),
                ),
                Gap.smWidth,
                DropdownButton<String>(
                  value: selectedStatus,
                  items: ['Tất cả', 'customer', 'staff', 'admin'].map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: _onStatusChanged,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: userService.stream,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Lỗi: ${snapshot.error}"));
                  }

                  allusers = snapshot.data!;
                  if (searchController.text.isEmpty &&
                      selectedStatus == 'Tất cả') {
                    filteredusers = allusers;
                  }
                  return UserItem(user: filteredusers);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
