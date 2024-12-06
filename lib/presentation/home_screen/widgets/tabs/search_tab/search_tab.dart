import 'package:flutter/material.dart';

import '../../../../../api/api_manager/api_manager.dart';
import '../../../../../api/sources/movie_Discover/MovieDiscover_Results.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController searchController = TextEditingController();
  List<MovieDiscoverResults>? searchResults;
  bool isLoading = false;

  void searchMovies(String query) async {
    setState(() {
      isLoading = true;
    });
    searchResults = await ApiManager().fetchMoviesBySearch(query);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search...",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              searchMovies(query);
            }
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : searchResults == null || searchResults!.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.movie_creation_outlined,
                          color: Colors.grey, size: 100),
                      Text(
                        "No movies found",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: searchResults!.length,
                  itemBuilder: (context, index) {
                    final movie = searchResults![index];
                    return ListTile(
                      leading: movie.posterPath != null
                          ? Image.network(
                              "https://image.tmdb.org/t/p/w200${movie.posterPath}",
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.movie, color: Colors.white),
                      title: Text(
                        movie.title ?? "No title",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        movie.releaseDate ?? "No release date",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                ),
    );
  }
}
