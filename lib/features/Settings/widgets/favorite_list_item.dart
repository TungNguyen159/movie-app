import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/app.dart';
import 'package:movie_app/config/api_link.dart';
import 'package:movie_app/core/image/image_app.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/core/theme/radius.dart';
import 'package:movie_app/models/favourite.dart';

class Favoritelistitem extends StatelessWidget {
  const Favoritelistitem({
    super.key,
    required this.favor,
  });

  final List<Favourite> favor;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favor.length,
        itemBuilder: (context, index) {
          final fav = favor[index];
          return FutureBuilder(
              future: ControllerApi().fetchMovieDetail(fav.movieid),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return const Center(child: Text("không có dữ liệu"));
                }
                final movies = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.only(top: Gap.sM),
                  child: SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        Modular.to.pushNamed("/main/detail/${movies.id}");
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: Gap.sm),
                            child: Column(
                              children: [
                                Image.network(
                                  movies.posterPath!.isNotEmpty
                                      ? "${ApiLink.imagePath}${movies.posterPath}"
                                      : ImageApp.defaultImage,
                                  height: 120,
                                  width: 100,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      ImageApp.defaultImage,
                                      height: 120,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextHead(
                                    text: movies.title,
                                    maxLines: 2,
                                    textStyle:
                                        Theme.of(context).textTheme.titleMedium!
                                    //overflow: TextOverflow.ellipsis,
                                    ),
                                Gap.xsHeight,
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                    borderRadius: radius8,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(Gap.sm),
                                    child: TextHead(
                                      text:
                                          'Release Date ${movies.releaseDate}',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.yellow,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: radius50,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(Gap.sm)
                                  .copyWith(top: Gap.mL),
                              child: Text(
                                movies.voteAverage.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
