import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/config/api_handle.dart';
import 'package:movie_app/config/api_link.dart';
import 'package:movie_app/core/image/image_app.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/models/showtime.dart';

class OnshowingListItem extends StatelessWidget {
  const OnshowingListItem({
    super.key,
    required this.showtime,
  });

  final List<Showtime> showtime;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin:
            const EdgeInsets.symmetric(horizontal: Gap.sM, vertical: Gap.sM),
        width: double.infinity,
        child: ListView.builder(
          itemCount: showtime.length,
          itemBuilder: (ctx, index) {
            final data = showtime[index];

            return Padding(
              padding: const EdgeInsets.only(top: Gap.sm),
              child: SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    Modular.to.pushNamed("/main/detail/${data.movieid}");
                  },
                  child: FutureBuilder(
                    future: ControllerApi().fetchMovieDetail(data.movieid),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text("Lỗi tải phim"));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text("Không có dữ liệu"));
                      }

                      final datas = snapshot.data!;

                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: Gap.sm),
                            child: Column(
                              children: [
                                Image.network(
                                  datas.posterPath!.isNotEmpty
                                      ? "${ApiLink.imagePath}${datas.posterPath}"
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
                                  text: datas.originalTitle,
                                  maxLines: 2,
                                  textStyle:
                                      Theme.of(context).textTheme.titleMedium!,
                                ),
                                Gap.xsHeight,
                                Row(
                                  children: [
                                    TextHead(
                                      text: datas.voteAverage.toString(),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Gap.xsWidth,
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(Gap.sm)
                                .copyWith(top: Gap.mL),
                            child: const Icon(Icons.favorite),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
