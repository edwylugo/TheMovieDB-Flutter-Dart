import 'package:flutter/material.dart';
import 'package:movies_flutter_android_kobe/api_config.dart';
import 'package:movies_flutter_android_kobe/models/paginated_movies_map.dart';
import 'package:movies_flutter_android_kobe/models/paginated_search_results_map.dart';
import 'package:movies_flutter_android_kobe/models/search_result_map.dart';
import 'package:movies_flutter_android_kobe/movies_api.dart';
import 'package:movies_flutter_android_kobe/ui/loading_indicator_widget_kobe.dart';
import 'package:movies_flutter_android_kobe/ui/movie_details_kobe/detail_image_widget_kobe.dart';
import 'package:movies_flutter_android_kobe/ui/movie_details_kobe/movie_detail_page_kobe.dart';
import 'package:movies_flutter_android_kobe/ui/upcoming_movies_kobe/upcoming_movies_kobe.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

void main() => runApp(FilmApp());

class FilmApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THE MOVIE DB KOBE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.black,
          fontFamily: 'Montserrat',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
          )),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  SearchBar searchBar;
  String searchQuery = "";

  PaginatedSearchResults searchResults;

  _HomePageState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        closeOnSubmit: false,
        clearOnSubmit: false,
        onSubmitted: (String query) {
          setState(() {
            searchQuery = query;
            var call = MovieDB.getInstance().search(searchQuery);
            call.then((result) {
              setState(() {
                this.searchResults = result;
              });
            });
          });
        },
        buildDefaultAppBar: buildAppBar);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
//        title: Text('APP MOVIES TO KODE COMPANY'),
        title: Image.network("https://www.themoviedb.org/assets/2/v4/logos/408x161-powered-by-rectangle-green-bb4301c10ddc749b4e79463811a68afebeae66ef43d17bcfd8ff0e60ded7ce99.png"),
        centerTitle: true,
        actions: [searchBar.getSearchAction(context)]);

  }



  @override
  Widget build(BuildContext context) {
    var widgets = searchBar.isSearching.value
        ? [SearchMovieWidget(searchResults)]
        : [
      UpcomingMoviesWidget(),
      DiscoverMoviesWidget(),
      DiscoverGenreMoviesWidget()
    ];

    return Scaffold(
        appBar: searchBar.build(context),
        backgroundColor: Colors.black,
        body: ListView(
          scrollDirection: Axis.vertical,
          children: widgets,
        ));
  }
}

class SearchMovieWidget extends StatelessWidget {
  PaginatedSearchResults results;

  SearchMovieWidget(this.results);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: results?.results?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          var movie = results.results[index];

          var container = Container(
              width: 200,
              child: _buildMovieWidget(context, movie, "searchResult", index));

          return container;
        });
  }

  _buildMovieWidget(
      BuildContext context, SearchResult movie, String heroKey, int index) {
    var posterUrl = "$IMAGE_URL_500${movie.poster_path}";
    var detailUrl = "$IMAGE_URL_500${movie.backdrop_path}";
    var heroTag = "${movie.id.toString()}$heroKey";

    return DetailImageWidget(
      posterUrl,
      movie.title,
      index,
      callback: (index) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return MovieDetailPage(movie.id, movie.title, detailUrl, heroTag);
        }));
      },
      heroTag: heroTag,
    );
  }
}

class DiscoverMoviesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: UniqueKey(),
      future: MovieDB.getInstance().discoverMovies(),
      builder: (BuildContext context, AsyncSnapshot<PaginatedMovies> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.hasError) {
          // todo: handle error state
        }

        var data = snapshot.data;

        return MovieListWidget(data, "Upcoming Movies", "upcoming");
      },
    );
  }
}

class DiscoverGenreMoviesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: UniqueKey(),
      future: MovieDB.getInstance().discoverMovieWithCriteria(genres: 16),
      builder: (BuildContext context, AsyncSnapshot<PaginatedMovies> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.hasError) {
          // todo: handle error state
        }

        var data = snapshot.data;

        return MovieListWidget(data, "Animation", "genre");
      },
    );
  }
}

class MovieListWidget extends StatelessWidget {
  final PaginatedMovies data;
  final String title;
  final String heroKey;

  MovieListWidget(this.data, this.title, this.heroKey);

   @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Align(alignment: Alignment.topLeft, child: Text(title)),
          Container(
            height: 200,
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.results == null ? 0 : data.results.length,
                itemBuilder: (BuildContext context, int index) {
                  var movie = data.results[index];

                  var posterUrl = "$IMAGE_URL_500${movie.posterPath}";
                  var detailUrl = "$IMAGE_URL_500${movie.backdropPath}";
                  var heroTag = "${movie.id.toString()}$heroKey";

                    return DetailImageWidget(
                      posterUrl,
                      movie.title,
                      index,
                      callback: (index) {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return MovieDetailPage(
                                  movie.id, movie.title, detailUrl, heroTag);
                            }));
                      },
                      heroTag: heroTag,
                    );



                }),
          ),
        ],
      ),
    );
  }
}
