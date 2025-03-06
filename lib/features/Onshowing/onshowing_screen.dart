import 'package:flutter/material.dart';
import 'package:movie_app/Components/list_display.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/config/api_handle.dart';
import 'package:movie_app/features/Onshowing/widgets/onshowing_list_item.dart';
import 'package:movie_app/models/showtime.dart';
import 'package:movie_app/service/showtime_service.dart';

class OnshowingScreen extends StatefulWidget {
  const OnshowingScreen({super.key});

  @override
  State<OnshowingScreen> createState() => _OnshowingScreenState();
}

class _OnshowingScreenState extends State<OnshowingScreen> {
  late Stream<List<Showtime>> onShowingList;
  final controllerApis = ControllerApi();
  final showtimeService = ShowtimeService();
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    onShowingList = showtimeService.streamShowtime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextHead(text: "Onshowing"),
      ),
      body: StreamBuilder<List<Showtime>>(
        stream: onShowingList,
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

          final List<Showtime> showtimeList = snapshot.data!;

          return OnshowingListItem(showtime: showtimeList);
        },
      ),
    );
  }
}
