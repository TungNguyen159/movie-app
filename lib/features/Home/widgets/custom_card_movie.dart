import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/config/api_link.dart';

class CustomCardMovie extends StatelessWidget {
  const CustomCardMovie({
    super.key,
    required this.snapshot,
  });

  final AsyncSnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Modular.to.navigate("/home/detail/?movieId=${snapshot.data[index].id}");
            },
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: 140,
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                          "${keyLink.imagePath}${snapshot.data[index].posterPath}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  right: 15,
                  bottom: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data[index].originalTitle,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data[index].voteAverage.toString(),
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 5),
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