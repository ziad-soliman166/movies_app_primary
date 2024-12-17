import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../api/api_manager/api_manager.dart';
import '../../../../../api/sources/popular/popular_Results.dart';
import '../../../../../api/sources/topRated/topRated_Results.dart';
import '../../../../../api/sources/upcoming/upComing_Results.dart';
import 'widgets/movieDetails_screen.dart';

class HomeTab extends StatefulWidget {
  final List<dynamic> watchlistMovies;

  HomeTab({required this.watchlistMovies});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  ApiManager apiManager = ApiManager();
  List<popularResults>? popularMovies;
  List<upComingResults>? upcomingMovies;
  List<topRatedResults>? topRatedMovies;

  final Map<int, bool> _iconToggled = {};

  final CollectionReference watchlistRef =
      FirebaseFirestore.instance.collection('watchlist');

  @override
  void initState() {
    super.initState();
    fetchData();
    loadWatchlistFromFirebase();
  }

  Future<void> fetchData() async {
    final popular = await apiManager.fetchPopularMovies();
    final upcoming = await apiManager.fetchUpcomingMovies();
    final topRated = await apiManager.fetchTopRatedMovies();

    setState(() {
      popularMovies = popular?.results;
      upcomingMovies = upcoming?.results;
      topRatedMovies = topRated?.results;
    });
  }

  Future<void> loadWatchlistFromFirebase() async {
    QuerySnapshot snapshot = await watchlistRef.get();
    final List<dynamic> watchlist =
        snapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      widget.watchlistMovies.clear();
      widget.watchlistMovies.addAll(watchlist);
      for (var movie in watchlist) {
        _iconToggled[movie['id']] = true;
      }
    });
  }

  Future<void> toggleWatchlist(dynamic movie) async {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildMovieCarousel("Popular Movies", popularMovies),
            buildMovieListSection("Upcoming Movies", upcomingMovies),
            buildMovieListSection("Top Rated Movies", topRatedMovies),
          ],
        ),
      ),
    );
  }

  Widget buildMovieCarousel(String title, List<dynamic>? movies) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: movies != null
          ? CarouselSlider.builder(
              itemCount: movies.length,
              itemBuilder: (context, index, realIndex) {
                final movie = movies[index];
                return buildMovieCard(movie, isCarousel: true);
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildMovieListSection(String title, List<dynamic>? movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Container(
          height: 150,
          child: movies != null
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return buildMovieCard(movie);
                  },
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget buildMovieCard(dynamic movie, {bool isCarousel = false}) {
    final int movieId = movie.id;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(
                movieId: movieId,
              ),
            ),
          );
        },
        child: Stack(
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/w200${movie.posterPath}',
              width: isCarousel ? double.infinity : 100,
              height: isCarousel ? double.infinity : 150,
              fit: BoxFit.fill,
            ),
            Positioned(
              top: 4,
              left: 4,
              child: GestureDetector(
                onTap: () => toggleWatchlist(movie),
                child: Container(
                  decoration: BoxDecoration(
                    color: _iconToggled[movieId] == true
                        ? Colors.yellow
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    _iconToggled[movieId] == true ? Icons.check : Icons.add,
                    color: Colors.white,
                    size: isCarousel ? 24 : 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
