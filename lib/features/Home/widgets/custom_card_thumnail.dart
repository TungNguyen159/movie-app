import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/config/api_link.dart';

class CustomCardThumbnail extends StatelessWidget {
  const CustomCardThumbnail({
    super.key,
    required this.snapshot,
  });
  final AsyncSnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: 10,
        itemBuilder: (context, index, pageViewIndex) {
          return InkWell(
            onTap: () {
              context.go("/home/detail/${snapshot.data[index].id}");
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(
                          "${keyLink.imagePath}${snapshot.data[index].posterPath}"),
                      fit: BoxFit.cover)),
              margin: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 20,
                bottom: 20,
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 400,
          autoPlay: true,
          viewportFraction: 0.55,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(seconds: 2),
        ),
      ),
    );
  }
}