import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies/presentation/home_screen/widgets/tabs/home_tab/widgets/related_movie.dart';

import '../../../../../../api/api_manager/api_manager.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;
  MovieDetailsScreen({required this.movieId});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  ApiManager apiManager = ApiManager();
  dynamic movieDetails;
  List<relatedMovie>? relatedMovies;

  final Map<int, bool> _iconToggled = {};

  final CollectionReference watchlistRef =
      FirebaseFirestore.instance.collection('watchlist');

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
    fetchRelatedMovies();
    loadWatchlistFromFirebase();
  }

  Future<void> fetchMovieDetails() async {
    final movie = await apiManager.fetchMovieDetails(widget.movieId);
    setState(() {
      movieDetails = movie;
    });
  }

  Future<void> fetchRelatedMovies() async {
    final related = await apiManager.fetchRelatedMovies(widget.movieId);
    setState(() {
      relatedMovies = related;
    });
  }

  Future<void> loadWatchlistFromFirebase() async {
    QuerySnapshot snapshot = await watchlistRef.get();
    final List<dynamic> watchlist =
        snapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      _iconToggled.clear();
      for (var movie in watchlist) {
        _iconToggled[movie['id']] = true;
      }
    });
  }

  Future<void> toggleWatchlist(relatedMovie movie) async {
    final int movieId = movie.id;

    setState(() {
      _iconToggled[movieId] = !(_iconToggled[movieId] ?? false);
    });

    if (_iconToggled[movieId] == true) {
      await watchlistRef.doc(movieId.toString()).set({
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'releaseDate': movie.releaseDate ?? '',
        'overview': movie.overview ?? '',
      });
    } else {
      await watchlistRef.doc(movieId.toString()).delete();
    }

    loadWatchlistFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Movie Details"),
        backgroundColor: Colors.black,
      ),
      body: movieDetails == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/w500${movieDetails['backdrop_path']}',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.15,
                        left: MediaQuery.of(context).size.width * 0.37,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Icon(
                            Icons.play_arrow,
                            size: 50,
                            color: Colors.black,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(20),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      movieDetails['title'] ?? "No Title",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      movieDetails['overview'] ?? "No description available.",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Rating: ${movieDetails['vote_average']}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Release Date: ${movieDetails['release_date']}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "More Like This",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  relatedMovies == null
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: relatedMovies!.length,
                            itemBuilder: (context, index) {
                              final movie = relatedMovies![index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MovieDetailsScreen(
                                          movieId: movie.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Image.network(
                                            'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                            width: 100,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            movie.title,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 4,
                                        left: 4,
                                        child: GestureDetector(
                                          onTap: () => toggleWatchlist(movie),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  _iconToggled[movie.id] == true
                                                      ? Colors.yellow
                                                      : Colors.grey,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(6),
                                            child: Icon(
                                              _iconToggled[movie.id] == true
                                                  ? Icons.check
                                                  : Icons.add,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
