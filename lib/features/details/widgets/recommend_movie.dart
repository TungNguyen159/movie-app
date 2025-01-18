import 'package:flutter/material.dart';
import 'package:movie_app/detail.dart';

class RecommendScreen extends StatelessWidget {
  const RecommendScreen({super.key, required this.snapshot});
  final AsyncSnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Gap.sM, horizontal: Gap.mL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextHead(text: "Recommend movie"),
          Gap.sMHeight,
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: snapshot.data != null && snapshot.data.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final movie = snapshot.data[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: Gap.md),
                        child: InkWell(
                          onTap: () {
                            Modular.to.pushNamed("/main/detail/${movie.id}");
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: radius20,
                                child: Container(
                                  height: 150,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: movie.backdropPath != null
                                          ? NetworkImage(
                                              "${ApiLink.imagePath}${movie.backdropPath}")
                                          : AssetImage(ImageApp.defaultImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 20,
                                right: 15,
                                bottom: 5,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.originalTitle ??
                                                "Unknown Title",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                          Gap.xsHeight
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "No recommend available",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
