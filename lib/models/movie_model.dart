class MovieModel {
  String id;
  String? title;
  String? year;
  List<String>? genres;
  List<int>? ratings;
  String? poster;
  String? contentRating;
  String? duration;
  String? releaseDate;
  int? averageRating;
  String? originalTitle;
  String? storyline;
  List<String>? actors;
  double? imdbRating;
  String? posterurl;

  MovieModel({
    required this.id,
    this.title,
    this.year,
    this.genres,
    this.ratings,
    this.poster,
    this.contentRating,
    this.duration,
    this.releaseDate,
    this.averageRating,
    this.originalTitle,
    this.storyline,
    this.actors,
    this.imdbRating,
    this.posterurl,
  });

  MovieModel copyWith({
    String? id,
    String? title,
    String? year,
    List<String>? genres,
    List<int>? ratings,
    String? poster,
    String? contentRating,
    String? duration,
    String? releaseDate,
    int? averageRating,
    String? originalTitle,
    String? storyline,
    List<String>? actors,
    double? imdbRating,
    String? posterurl,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      genres: genres ?? this.genres,
      ratings: ratings ?? this.ratings,
      poster: poster ?? this.poster,
      contentRating: contentRating ?? this.contentRating,
      duration: duration ?? this.duration,
      releaseDate: releaseDate ?? this.releaseDate,
      averageRating: averageRating ?? this.averageRating,
      originalTitle: originalTitle ?? this.originalTitle,
      storyline: storyline ?? this.storyline,
      actors: actors ?? this.actors,
      imdbRating: imdbRating ?? this.imdbRating,
      posterurl: posterurl ?? this.posterurl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'genres': genres,
      'ratings': ratings,
      'poster': poster,
      'contentRating': contentRating,
      'duration': duration,
      'releaseDate': releaseDate,
      'averageRating': averageRating,
      'originalTitle': originalTitle,
      'storyline': storyline,
      'actors': actors,
      'imdbRating': imdbRating,
      'posterurl': posterurl,
    };
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      year: json['year'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      ratings:
          (json['ratings'] as List<dynamic>?)?.map((e) => e as int).toList(),
      poster: json['poster'] as String?,
      contentRating: json['contentRating'] as String?,
      duration: json['duration'] as String?,
      releaseDate: json['releaseDate'] as String?,
      averageRating: json['averageRating'] as int?,
      originalTitle: json['originalTitle'] as String?,
      storyline: json['storyline'] as String?,
      actors:
          (json['actors'] as List<dynamic>?)?.map((e) => e as String).toList(),

      //? WHY THIS FIELD CAN BE DOUBLE OR STRING
      imdbRating:
          json['imdbRating'] is double?
              ? json['imdbRating'] as double
              : double.tryParse(json['imdbRating']),
      posterurl: json['posterurl'] as String?,
    );
  }

  @override
  String toString() =>
      "MovieModel(id: $id,title: $title,year: $year,genres: $genres,ratings: $ratings,poster: $poster,contentRating: $contentRating,duration: $duration,releaseDate: $releaseDate,averageRating: $averageRating,originalTitle: $originalTitle,storyline: $storyline,actors: $actors,imdbRating: $imdbRating,posterurl: $posterurl)";

  @override
  int get hashCode => Object.hash(
    id,
    title,
    year,
    genres,
    ratings,
    poster,
    contentRating,
    duration,
    releaseDate,
    averageRating,
    originalTitle,
    storyline,
    actors,
    imdbRating,
    posterurl,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          year == other.year &&
          genres == other.genres &&
          ratings == other.ratings &&
          poster == other.poster &&
          contentRating == other.contentRating &&
          duration == other.duration &&
          releaseDate == other.releaseDate &&
          averageRating == other.averageRating &&
          originalTitle == other.originalTitle &&
          storyline == other.storyline &&
          actors == other.actors &&
          imdbRating == other.imdbRating &&
          posterurl == other.posterurl;
}
