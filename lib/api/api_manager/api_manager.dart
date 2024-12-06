import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../presentation/home_screen/widgets/tabs/home_tab/widgets/related_movie.dart';
import '../sources/movie_Discover/MovieDiscover_Results.dart';
import '../sources/popular/Popular_source.dart';
import '../sources/topRated/TopRated_source.dart';
import '../sources/upcoming/Upcoming_source.dart';

class Video {
  final String
      key; // The key used to fetch the video from YouTube or other platforms

  Video({required this.key});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(key: json['key']);
  }
}

class ApiManager {
  final String baseUrl = "https://api.themoviedb.org/3";
  final String apiKey = "a736b3c53cebf4cbabfbd7b6c77a6305";

  Future<PopularSource?> fetchPopularMovies() async {
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return PopularSource.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Error fetching popular movies: $e");
    }
    return null;
  }

  Future<UpcomingSource?> fetchUpcomingMovies() async {
    final url = Uri.parse('$baseUrl/movie/upcoming?api_key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return UpcomingSource.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Error fetching upcoming movies: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchMovieDetails(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error fetching movie details: $e");
    }
    return null;
  }

  Future<TopRatedSource?> fetchTopRatedMovies() async {
    final url = Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return TopRatedSource.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Error fetching top-rated movies: $e");
    }
    return null;
  }

  // Fetch related movies by movie ID
  Future<List<relatedMovie>?> fetchRelatedMovies(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/similar?api_key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['results'] as List)
            .map((movie) => relatedMovie.fromJson(movie))
            .toList();
      }
    } catch (e) {
      print("Error fetching related movies: $e");
    }
    return null;
  }

  // Fetch video URL for a movie
  Future<String?> fetchMovieVideoUrl(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          // Assuming the first video result is the one to play
          String videoKey = data['results'][0]['key'];
          return 'https://www.youtube.com/watch?v=$videoKey'; // URL for YouTube
        }
      }
    } catch (e) {
      print("Error fetching video details: $e");
    }
    return null;
  }

  // Add this method to ApiManager class
  Future<List<MovieDiscoverResults>?> fetchMoviesBySearch(String query) async {
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null) {
          return (data['results'] as List)
              .map((movie) => MovieDiscoverResults.fromJson(movie))
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching search results: $e");
    }
    return null;
  }
}
