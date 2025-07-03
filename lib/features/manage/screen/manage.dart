import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/core/image/image_app.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/models/user.dart';
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
      body: FutureBuilder<Users?>(
        future: userService.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }

          final userProfile = snapshot.data!;
          final role = userProfile.role;

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
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: (userProfile.imageuser == null ||
                                  userProfile.imageuser!.isEmpty)
                              ? AssetImage(ImageApp.defaultImage)
                              : NetworkImage(userProfile.imageuser!),
                        ),
                        Gap.mdWidth,
                        Gap.mdWidth,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userProfile.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              role!.toUpperCase(),
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
                const SizedBox(height: 20),
                Column(
                  children: [
                    if (role == "admin")
                      Column(
                        children: [
                          buildTile("Manage user", Icons.people, Colors.blue,
                              "/manage/manageuser"),
                          buildTile("Manage hall", Icons.meeting_room,
                              Colors.red, "/manage/manageHall"),
                          buildTile("Manage coupon", Icons.redeem,
                              Colors.lightBlueAccent, "/manage/coupon"),
                          buildTile("Statistic", Icons.bar_chart,
                              Colors.lightBlueAccent, "/manage/statistic"),
                        ],
                      ),
                    if (role == "admin" || role == "staff")
                      Column(
                        children: [
                          buildTile("Manage booking", Icons.receipt_long,
                              Colors.yellow, "/manage/managebooking"),
                          buildTile("Manage showtime", Icons.movie,
                              Colors.green, "/manage/manageshowtime"),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTile(String title, IconData icon, Color color, String route) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => Modular.to.pushNamed(route),
        ),
        const Divider(),
      ],
    );
  }
}
