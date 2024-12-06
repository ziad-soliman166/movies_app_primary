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

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
    fetchRelatedMovies();
  }

  // Fetch movie details
  void fetchMovieDetails() async {
    final movie = await apiManager.fetchMovieDetails(widget.movieId);
    setState(() {
      movieDetails = movie;
    });
  }

  // Fetch related movies
  void fetchRelatedMovies() async {
    final related = await apiManager.fetchRelatedMovies(widget.movieId);
    setState(() {
      relatedMovies = related;
    });
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
                  // Movie Image and Description
                  Stack(
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/w500${movieDetails['backdrop_path']}',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                      // Play button in the center of the image
                      Positioned(
                        top: MediaQuery.of(context).size.height *
                            0.15, // Vertically center
                        left: MediaQuery.of(context).size.width *
                            0.37, // Horizontally center
                        child: ElevatedButton(
                          onPressed:
                              () {}, // Trigger video fetching and navigation
                          child: Icon(
                            Icons.play_arrow,
                            size: 50, // Increased size for better visibility
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
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      movieDetails['overview'] ?? "No description available.",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Rating: ${movieDetails['vote_average']}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Release Date: ${movieDetails['release_date']}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: relatedMovies!.length,
                            itemBuilder: (context, index) {
                              final movie = relatedMovies![index];
                              return InkWell(
                                onTap: () {
                                  // Navigate to the details of a related movie
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailsScreen(
                                        movieId: movie.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Image.network(
                                          'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                          width: 100,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          movie.title,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
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
