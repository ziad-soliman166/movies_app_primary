import '../movie_Discover/MovieDiscover_Results.dart';

class SearchSource {
  SearchSource({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  SearchSource.fromJson(dynamic json) {
    page = json['page'];
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(MovieDiscoverResults.fromJson(v)); // Use the correct model
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  num? page;
  List<MovieDiscoverResults>? results; // Updated to use Results
  num? totalPages;
  num? totalResults;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    if (results != null) {
      map['results'] = results?.map((v) => v.toJson()).toList();
    }
    map['total_pages'] = totalPages;
    map['total_results'] = totalResults;
    return map;
  }
}
