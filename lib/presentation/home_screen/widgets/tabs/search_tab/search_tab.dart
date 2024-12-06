import 'package:flutter/material.dart';

import '../../../../../api/api_manager/api_manager.dart';
import '../../../../../api/sources/movie_Discover/MovieDiscover_Results.dart';
import '../home_tab/widgets/movieDetails_screen.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController searchController = TextEditingController();
  List<MovieDiscoverResults>? searchResults = [];
  bool isLoading = false;

  Duration debounceDuration = const Duration(milliseconds: 500);
  late final VoidCallback _debounce;

  @override
  void initState() {
    super.initState();
    _debounce = () {
      if (searchController.text.isNotEmpty) {
        searchMovies(searchController.text);
      } else {
        setState(() {
          searchResults = [];
        });
      }
    };
    searchController.addListener(_debouncedSearch);
  }

  @override
  void dispose() {
    searchController.removeListener(_debouncedSearch);
    searchController.dispose();
    super.dispose();
  }

  void _debouncedSearch() {
    if (searchController.text.isEmpty) return;
    Future.delayed(debounceDuration, _debounce);
  }

  void searchMovies(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      searchResults = await ApiManager().fetchMoviesBySearch(query);
    } catch (error) {
      searchResults = [];
    }

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
            hintText: "Search movies...",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
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
                      onTap: () {
                        // Navigate to the MovieDetailsScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(
                              movieId: movie.id!.toInt(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
