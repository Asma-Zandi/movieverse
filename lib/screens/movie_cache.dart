import 'movie_model.dart';
import 'tmdb_service.dart';

class MovieCache {
  static List<Movie>? promoMovies;

  static Future<List<Movie>> getPromoMovies() async {

    if (promoMovies != null && promoMovies!.isNotEmpty) {
      return promoMovies!;
    }

    try {
      final moviesPage2 = await TmdbService.getPopularMovies(page: 2);
      final moviesPage3 = await TmdbService.getPopularMovies(page: 3);
      final series = await TmdbService.getPopularSeries();

      List<Movie> mixedList = [];
      if (moviesPage2.isNotEmpty) mixedList.addAll(moviesPage2.take(6));
      if (moviesPage3.isNotEmpty) mixedList.addAll(moviesPage3.take(4));
      if (series.isNotEmpty) mixedList.addAll(series.take(4));

      if (mixedList.isEmpty) {
        mixedList = await TmdbService.getFeaturedMovies();
      }

      promoMovies = mixedList;
      return promoMovies!;
    } catch (_) {
      promoMovies = await TmdbService.getFeaturedMovies();
      return promoMovies!;
    }
  }
}