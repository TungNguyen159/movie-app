import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/config/api_link.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/core/theme/radius.dart';
import 'package:movie_app/models/movie.dart';

class CustomCardMovie extends StatelessWidget {
  const CustomCardMovie({
    super.key,
    required this.snapshot,
  });

  final List<Movies> snapshot;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Gap.sM, vertical: Gap.sM),
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.length,
        itemBuilder: (context, index) {
          final data = snapshot[index];
          return InkWell(
            onTap: () {
              Modular.to.pushNamed("/main/detail/${data.id}");
            },
            child: Stack(
              children: [
                ClipRRect(
                  child: Container(
                    height: 210,
                    width: 150,
                    margin: const EdgeInsets.symmetric(horizontal: Gap.sm),
                    decoration: BoxDecoration(
                      borderRadius: radius20,
                      image: DecorationImage(
                        image: NetworkImage(
                          "${ApiLink.imagePath}${data.posterPath}",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: radius20,
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  right: 15,
                  bottom: 15,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHead(
                              text: data.originalTitle,
                              maxLines: 1,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
                                  ),
                            ),
                            Gap.xsWidth,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextHead(
                                  text: data.voteAverage.toString(),
                                  maxLines: 1,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary,
                                      ),
                                ),
                                Gap.xsWidth,
                                const Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.yellow,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
