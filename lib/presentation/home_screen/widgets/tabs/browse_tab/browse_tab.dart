import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../../api/sources/movies_list/Genres.dart';
import '../../../../../api/sources/movies_list/MoviesList_source.dart';
import 'movies_list_screen.dart';

class BrowseTab extends StatefulWidget {
  @override
  _BrowseTabState createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  List<Genres> genres = [];
  Map<int, String> categoryImages = {};
  final String apiKey = "a736b3c53cebf4cbabfbd7b6c77a6305";

  final String fallbackImageUrl =
      "https://via.placeholder.com/500x300?text=Movie";

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndImages();
  }

  Future<void> fetchCategoriesAndImages() async {
    final genresUrl = Uri.parse(
        "https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey");

    final genresResponse = await http.get(genresUrl);

    if (genresResponse.statusCode == 200) {
      final genresData = json.decode(genresResponse.body);
      final moviesListSource = MoviesListSource.fromJson(genresData);

      setState(() {
        genres = moviesListSource.genres ?? [];
      });

      for (var genre in genres) {
        fetchSampleImage(genre.id!);
      }
    } else {
      print('Failed to fetch genres');
    }
  }

  Future<void> fetchSampleImage(num genreId) async {
    final url = Uri.parse(
        "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final movie = data['results'][0];
        final imageUrl = movie['backdrop_path'] != null
            ? 'https://image.tmdb.org/t/p/w500${movie['backdrop_path']}'
            : fallbackImageUrl;

        setState(() {
          categoryImages[genreId.toInt()] = imageUrl;
        });
      } else {
        setState(() {
          categoryImages[genreId.toInt()] = fallbackImageUrl;
        });
      }
    } else {
      print('Failed to fetch movies for genre $genreId');
      setState(() {
        categoryImages[genreId.toInt()] = fallbackImageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Browse Categories',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: genres.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 16 / 9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: genres.length,
              itemBuilder: (ctx, index) {
                final genre = genres[index];
                final genreName = genre.name ?? 'Unknown';
                final genreImage =
                    categoryImages[genre.id?.toInt()] ?? fallbackImageUrl;

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            MoviesListScreen(genre.id!.toInt(), genreName),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(genreImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black54,
                        child: Text(
                          genreName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
