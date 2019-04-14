import 'package:flutter/material.dart';
import 'package:movies_flutter_android_kobe/api_config.dart';
import 'package:movies_flutter_android_kobe/models/credits_map.dart';
import 'package:movies_flutter_android_kobe/movies_api.dart';
import 'package:movies_flutter_android_kobe/ui/crew_details_kobe.dart';
import 'package:movies_flutter_android_kobe/ui/loading_indicator_widget_kobe.dart';
import 'package:movies_flutter_android_kobe/ui/movie_details_kobe/detail_image_widget_kobe.dart';

class CrewWidget extends StatelessWidget {
  final int movieId;

  CrewWidget(this.movieId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MovieDB.getInstance().getMovieCredits(movieId),
      builder: (BuildContext context, AsyncSnapshot<Credits> snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicatorWidget();
        } else if (snapshot.hasError) {
          // todo: handle error state
        }

        var list = snapshot.data.cast;

        Function(int) callback = (index) {
          var crew = list[index];
          var heroTag = crew.id.toString();
          var crewImageUrl = "$IMAGE_URL_500${crew.profile_path}";
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return CrewDetailPage(crew.id, crew.name, crewImageUrl, heroTag);
          }));
        };

        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return DetailImageWidget(
                  "$IMAGE_URL_500${list[index].profile_path}",
                  list[index].name,
                  index,
                  heroTag: list[index].id.toString(),
                  callback: callback);
            });
      },
    );
  }
}
