import 'package:movies_flutter_android_kobe/models/movie_map.dart';
import 'package:movies_flutter_android_kobe/models/paginated_result_map.dart';
import 'package:movies_flutter_android_kobe/models/search_result_map.dart';

class PaginatedSearchResults extends PaginatedResult{
  List<SearchResult> results = new List();

  PaginatedSearchResults.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalResults = json['total_results'];
    totalPages = json['total_pages'];
    if (json['results'] != null) {
      results = List<SearchResult>.from(json['results'].map((search) => SearchResult.fromJson(search)));
    }
  }
}