class relatedMovie {
  final int id;
  final String title;
  final String posterPath;

  relatedMovie({
    required this.id,
    required this.title,
    required this.posterPath,
  });

  // Factory method to create a relatedMovie from JSON
  factory relatedMovie.fromJson(Map<String, dynamic> json) {
    return relatedMovie(
      id: json['id'],
      title: json['title'] ?? "No Title", // Default text in case title is null
      posterPath:
          json['poster_path'] ?? "", // Default empty string for poster path
    );
  }
}
