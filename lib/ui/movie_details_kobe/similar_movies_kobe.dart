import 'package:flutter/material.dart';
import 'package:movies_flutter_android_kobe/api_config.dart';
import 'package:movies_flutter_android_kobe/models/paginated_similarmovies_map.dart';
import 'package:movies_flutter_android_kobe/movies_api.dart';
import 'package:movies_flutter_android_kobe/ui/loading_indicator_widget_kobe.dart';
import 'package:movies_flutter_android_kobe/ui/movie_details_kobe/detail_image_widget_kobe.dart';
import 'package:movies_flutter_android_kobe/ui/movie_details_kobe/movie_detail_page_kobe.dart';

class SimilarMoviesWidget extends StatelessWidget {
  final int movieId;

  SimilarMoviesWidget(this.movieId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MovieDB.getInstance().getSimilarMovies(movieId),
      builder: (BuildContext context,
          AsyncSnapshot<PaginatedSimilarMovies> snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicatorWidget();
        } else if (snapshot.hasError) {
          // todo: handle error state
        }

        var list = snapshot.data.results;

        Function(int) callback = (index) {
          var movie = list[index];
          var heroTag = movie.id.toString();
          var movieImageUrl = "$IMAGE_URL_500${movie.backdropPath}";
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return MovieDetailPage(
                movie.id, movie.title, movieImageUrl, heroTag);
          }));
        };

        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              var movie = list[index];

              return DetailImageWidget(
                "$IMAGE_URL_500${movie.posterPath}",
                movie.title,
                index,
                callback: callback,
                heroTag: movie.id.toString(),
              );
            });
      },
    );
  }
}
