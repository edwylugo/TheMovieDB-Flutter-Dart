import 'package:movies_flutter_android_kobe/models/movie_map.dart';
import 'package:movies_flutter_android_kobe/models/paginated_result_map.dart';

class PaginatedSimilarMovies extends PaginatedResult{
  List<Movie> results = new List();

  PaginatedSimilarMovies.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalResults = json['total_results'];
    totalPages = json['total_pages'];
    if (json['results'] != null) {
      results = List<Movie>.from(json['results'].map((movie) => Movie.fromJson(movie)));
    }
  }
}