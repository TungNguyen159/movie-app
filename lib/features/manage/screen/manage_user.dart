import 'package:flutter/material.dart';
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
  String searchInfo = '';

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
            SearchBox(
                controller: searchController,
                focusNode: searchFocusNode,
                onChanged: (value) {
                  setState(() {
                    searchInfo = value.toLowerCase();
                  });
                }),
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

                  final List<Users> userlist = snapshot.data!;
                  final filteredUsers = userlist.where((user) {
                    return user.name.toLowerCase().contains(searchInfo);
                  }).toList();
                  if (filteredUsers.isEmpty) {
                    return const Center(
                      child: Text("no user"),
                    );
                  }
                  return UserItem(user: filteredUsers);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
