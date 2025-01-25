import 'package:flutter/material.dart';
import 'package:movie_app/Components/list_display.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/config/api_handle.dart';
import 'package:movie_app/features/Yourbooking/widget/booking_list_item.dart';
import 'package:movie_app/models/movie.dart';

class BookedScreen extends StatefulWidget {
  const BookedScreen({super.key});

  @override
  State<BookedScreen> createState() => _BookedScreenState();
}

class _BookedScreenState extends State<BookedScreen> {
  late Future<List<Movies>> movieList;
  final controllerApis = ControllerApi();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    movieList = controllerApis.getTopRatedMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextHead(text: "Your booking"),
      ),
      body: ListDisplay(
        listFuture: movieList,
        builder: (snapshot) => BookingListItem(
          snapshot: snapshot,
        ),
      ),
    );
  }
}
