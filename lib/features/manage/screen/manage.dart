import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/service/user_service.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  final userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextHead(text: "Manage"),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: userService.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }

          final userProfile = snapshot.data!;
          final role = userProfile['role'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/7.png'),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userProfile['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              role.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (role == "admin")
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.people, color: Colors.blue),
                        title: Text("Manage user"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () => Modular.to.pushNamed("/manage/manageuser"),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.movie, color: Colors.green),
                        title: Text("Manage showtime"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () =>
                            Modular.to.pushNamed("/manage/manageshowtime"),
                      ),
                    ],
                  )
                else
                  Center(
                    child: Text(
                      "Bạn không có quyền quản lý",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.redAccent),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
