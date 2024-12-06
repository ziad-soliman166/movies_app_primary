import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../../api/api_manager/api_manager.dart';
import '../../../../../api/sources/popular/popular_Results.dart';
import '../../../../../api/sources/topRated/topRated_Results.dart';
import '../../../../../api/sources/upcoming/upComing_Results.dart';
import 'widgets/movieDetails_screen.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  ApiManager apiManager = ApiManager();
  List<popularResults>? popularMovies;
  List<upComingResults>? upcomingMovies;
  List<topRatedResults>? topRatedMovies;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final popular = await apiManager.fetchPopularMovies();
    final upcoming = await apiManager.fetchUpcomingMovies();
    final topRated = await apiManager.fetchTopRatedMovies();

    setState(() {
      popularMovies = popular?.results;
      upcomingMovies = upcoming?.results;
      topRatedMovies = topRated?.results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Popular Movies Section
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: popularMovies != null
                    ? CarouselSlider.builder(
                        itemCount: popularMovies!.length,
                        itemBuilder: (context, index, realIndex) {
                          final movie = popularMovies![index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailsScreen(
                                    movieId: movie.id as int,
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                                Positioned(
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.1,
                                  left:
                                      MediaQuery.of(context).size.width * 0.41,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print("Play ${movie.title}");
                                    },
                                    child: Icon(
                                      Icons.play_arrow,
                                      size: 30,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),

              // Upcoming Movies Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Upcoming Movies",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Container(
                height: 150,
                child: upcomingMovies != null
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: upcomingMovies!.length,
                        itemBuilder: (context, index) {
                          final movie = upcomingMovies![index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailsScreen(
                                      movieId: movie.id as int,
                                    ),
                                  ),
                                );
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Image.network(
                                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                      width: 100,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      movie.title ?? "No Title",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(child: CircularProgressIndicator()),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Top Rated Movies",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Container(
                height: 150,
                child: topRatedMovies != null
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: topRatedMovies!.length,
                        itemBuilder: (context, index) {
                          final movie = topRatedMovies![index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailsScreen(
                                      movieId: movie.id as int,
                                    ),
                                  ),
                                );
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                      width: 100,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      movie.title ?? "No Title",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
