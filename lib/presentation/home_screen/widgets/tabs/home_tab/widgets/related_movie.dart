class relatedMovie {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;
  final String overview;

  relatedMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.overview,
  });

  factory relatedMovie.fromJson(Map<String, dynamic> json) {
    return relatedMovie(
      id: json['id'],
      title: json['title'] ?? "No Title",
      posterPath: json['poster_path'] ?? "",
      releaseDate: json['release_date'] ?? "Unknown Release Date",
      overview: json['overview'] ?? "No description available",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'releaseDate': releaseDate,
      'overview': overview,
    };
  }
}
