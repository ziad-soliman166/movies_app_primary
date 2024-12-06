class relatedMovie {
  final int id;
  final String title;
  final String posterPath;

  relatedMovie({
    required this.id,
    required this.title,
    required this.posterPath,
  });

  factory relatedMovie.fromJson(Map<String, dynamic> json) {
    return relatedMovie(
      id: json['id'],
      title: json['title'] ?? "No Title",
      posterPath: json['poster_path'] ?? "",
    );
  }
}
