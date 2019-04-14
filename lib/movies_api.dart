import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:movies_flutter_android_kobe/api_config.dart';
import 'package:movies_flutter_android_kobe/models/actor_map.dart';
import 'package:movies_flutter_android_kobe/models/credits_map.dart';
import 'package:movies_flutter_android_kobe/models/movie_map.dart';
import 'package:movies_flutter_android_kobe/models/movie_details_map.dart';
import 'package:movies_flutter_android_kobe/models/paginated_movies_map.dart';
import 'package:movies_flutter_android_kobe/models/paginated_search_results_map.dart';
import 'package:movies_flutter_android_kobe/models/paginated_similarmovies_map.dart';
import 'package:http/http.dart' as http;

abstract class MovieDB {

  MovieDB();

  Future<List<Movie>> upcomingMovies();
  Future<PaginatedMovies> discoverMovies({int page = 1});
  Future<PaginatedMovies> discoverMovieWithCriteria({int page = 1, int genres = 16, int primaryYearRelease = 2019 });
  Future<MovieDetail> getMovieById(int movieId);
  Future<PaginatedSimilarMovies> getSimilarMovies(int movieId, {int page = 1});
  Future<Credits> getMovieCredits(int movieId);
  Future<Actor> getActorById(int actorId);
  Future<PaginatedSearchResults> search(String query, {int page = 1});

  factory MovieDB.getInstance() => _MovieRepository();
}

class _MovieRepository extends MovieDB{

  static final _MovieRepository _singleton = new _MovieRepository._internal();

  factory _MovieRepository() => _singleton;

  _MovieRepository._internal();

  static List<Movie> _computeMovies(dynamic body) => List<Movie>.from(body.map((movie) => Movie.fromJson(movie)));
  static PaginatedMovies _computePaginatedMovies(dynamic body) => PaginatedMovies.fromJson(body);
  static PaginatedSimilarMovies _computePaginatedSimilarMovies(dynamic body) => PaginatedSimilarMovies.fromJson(body);

  @override
  Future<List<Movie>> upcomingMovies() async{
    var url = Uri.https(BASE_URL, '/3/movie/upcoming',
        { 'api_key': API_KEY,
          'language': 'en-US'
        });

    var response = await http.get(url);

    var body = json.decode(response.body);

    return compute(_computeMovies, body['results']);
  }

  Future<PaginatedMovies> discoverMovies({int page = 1, String sort = "popularity.desc"}) async{
    var url = Uri.https(BASE_URL, '/3/discover/movie',
        { 'api_key': API_KEY,
          'page': page.toString(),
          'sort_by': sort
        });

    var response = await http.get(url);

    return compute(_computePaginatedMovies, json.decode(response.body));
  }


  @override
  Future<PaginatedSimilarMovies> getSimilarMovies(int movieId, {int page = 1}) async{
    var url = Uri.https(BASE_URL, '/3/movie/$movieId/similar',
        { 'api_key': API_KEY,
          'page': page.toString()});

    var response = await http.get(url);

    return compute(_computePaginatedSimilarMovies, json.decode(response.body));
  }

  @override
  Future<PaginatedMovies> discoverMovieWithCriteria({int page = 1, String sort = "popularity.desc", int genres = 16, int primaryYearRelease = 2019})  async {
    var url = Uri.https(BASE_URL, '/3/discover/movie',
        { 'api_key': API_KEY,
          'page': page.toString(),
          'sort_by': sort,
          'with_genres': genres.toString(),
          'primary_release_year': primaryYearRelease.toString()
        });

    var response = await http.get(url);

    return compute(_computePaginatedMovies, json.decode(response.body));
  }

  @override
  Future<Actor> getActorById(int actorId) async {
    var url = Uri.https(BASE_URL, '/3/person/$actorId',
        { 'api_key': API_KEY });

    var response = await http.get(url);

    return Actor.fromJson(json.decode(response.body));
  }

  @override
  Future<MovieDetail> getMovieById(int movieId) async {
    var url = Uri.https(BASE_URL, '/3/movie/$movieId',
        { 'api_key': API_KEY });

    var response = await http.get(url);

    return MovieDetail.fromJson(json.decode(response.body));
  }

  @override
  Future<Credits> getMovieCredits(int movieId) async {
    var url = Uri.https(BASE_URL, '/3/movie/$movieId/credits',
        { 'api_key': API_KEY });

    var response = await http.get(url);

    return Credits.fromJson(json.decode(response.body));
  }

  @override
  Future<PaginatedSearchResults> search(String query, {int page = 1}) async {
    var url = Uri.https(BASE_URL, '/3/search/movie',
        { 'api_key': API_KEY,
          'query': query,
          'page': page.toString()
        });

    var response = await http.get(url);

    return PaginatedSearchResults.fromJson(json.decode(response.body));
  }
}
