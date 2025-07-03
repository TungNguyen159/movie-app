import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/config/api_link.dart';
import 'package:movie_app/core/image/image_app.dart';
import 'package:movie_app/core/theme/radius.dart';
import 'package:movie_app/models/movie.dart';

class CustomCardThumbnail extends StatelessWidget {
  const CustomCardThumbnail({
    super.key,
    required this.snapshot,
  });
  final List<Movies> snapshot;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: 10,
        itemBuilder: (context, index, pageViewIndex) {
          final data = snapshot[index];
          return InkWell(
            onTap: () {
              Modular.to.pushNamed("/main/detail/${data.id}");
            },
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: radius20,
                  image: DecorationImage(
                    image: data.posterPath!.isNotEmpty
                        ? NetworkImage('${ApiLink.imagePath}${data.posterPath}')
                        : AssetImage(ImageApp.defaultImage),
                    fit: BoxFit.cover,
                  ),
                ),
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: 20,
                ),
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 400,
          autoPlay: true,
          viewportFraction: 0.6,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(seconds: 2),
        ),
      ),
    );
  }
}
