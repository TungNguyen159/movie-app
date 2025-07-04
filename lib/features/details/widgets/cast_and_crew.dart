import 'package:flutter/material.dart';
import 'package:movie_app/detail.dart';

class CastAndCrew extends StatelessWidget {
  const CastAndCrew({
    super.key,
    required this.cast,
  });
  final List<Cast> cast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextHead(text: 'Cast'),
          const SizedBox(height: 20),
          cast.isNotEmpty
              ? SizedBox(
                  height: 180,
                  child: ListView.builder(
                    itemCount: cast.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 20),
                        width: 90,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: cast[index]
                                      .profilePath
                                      .isNotEmpty
                                  ? NetworkImage(
                                      '${ApiLink.imagePath}${cast[index].profilePath}')
                                  : AssetImage(ImageApp.defaultImage),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              cast[index].originalName,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: TextHead(
                    text: "No cast available",
                  ),
                ),
        ],
      ),
    );
  }
}
