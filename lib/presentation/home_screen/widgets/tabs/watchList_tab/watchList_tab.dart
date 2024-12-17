import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WatchlistTab extends StatelessWidget {
  final List<dynamic> watchlistMovies;

  WatchlistTab({Key? key, required this.watchlistMovies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Watchlist"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('watchlist').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No movies in the watchlist",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          final movies = snapshot.data!.docs;

          return ListView.separated(
            itemCount: movies.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 0.5,
              indent: 10,
              endIndent: 10,
            ),
            itemBuilder: (context, index) {
              final movie = movies[index].data() as Map<String, dynamic>?;

              final posterPath = movie?['posterPath'] ?? '';
              final title = movie?['title'] ?? 'No Title';
              final releaseDate =
                  movie?['releaseDate'] ?? 'Unknown Release Date';
              final overview = movie?['overview'] ?? 'No description available';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    posterPath.isNotEmpty
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w200$posterPath',
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.white,
                            ),
                          ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            releaseDate,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            overview,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
