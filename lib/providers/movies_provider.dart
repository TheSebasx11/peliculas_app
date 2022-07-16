import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  String _url = "api.themoviedb.org",
      _ApiKey = "fcfd3262b188df932e0cb218e6cec3bc",
      _language = "es-ES";
  int _popularPage = 0;
  List<Movie> onDisplayMovies = [];
  List<Movie> PopularMovies = [];
  Map<int, List<Cast>> moviesCast = {};
  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreams =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestions => _suggestionStreams.stream;

  MoviesProvider() {
    getPlayingMovies();
    getPopularMovies();
  }

  Future _getJsonData(String endpoint, [int page = 1]) async {
    var uri = Uri.https(_url, endpoint, {
      "api_key": _ApiKey,
      "language": _language,
      "page": "$page",
    });

    final response = await http.get(uri);
    return response;
  }

  getPlayingMovies() async {
    final data = await _getJsonData("/3/movie/now_playing");
    final nowPlayingResponse = NowPlaying.fromJson(data.body);

    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final data = await _getJsonData("/3/movie/popular", _popularPage);
    final Popular = PopularResponse.fromJson(data.body);

    PopularMovies = [...PopularMovies, ...Popular.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) {
      return moviesCast[movieId]!;
    }

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData.body);

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _ApiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = "";
    debouncer.onValue = (value) async {
      final results = await searchMovies(value);
      _suggestionStreams.add(results);
    };
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });
    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
