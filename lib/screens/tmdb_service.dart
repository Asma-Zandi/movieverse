import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie_model.dart';

class TmdbService {
  static const String _baseUrl = 'https://moviesapi.ir/api/v1';

  static Future<List<Movie>> getFeaturedMovies() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/movies?page=1'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List results = data['data'] ?? [];
        List<Movie> movies = results.map((item) => Movie.fromJson(item)).toList();
        return movies.take(6).toList();
      } else {
        throw Exception('خطا در دریافت فیلم‌های ویژه');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/movies?page=$page'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List results = data['data'] ?? [];
        return results.map((item) => Movie.fromJson(item)).toList();
      } else {
        throw Exception('خطا در دریافت لیست فیلم‌ها');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Movie>> getPopularSeries({int page = 1}) async {
    try {
      int targetPage = page + 9;
      final response = await http.get(Uri.parse('$_baseUrl/movies?page=$targetPage'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List results = data['data'] ?? [];
        return results.map((item) => Movie.fromJson(item)).toList();
      } else {
        throw Exception('خطا در دریافت سریال‌ها');
      }
    } catch (e) {
      rethrow;
    }
  }

  static const Map<String, String> _genreTranslations = {
    'Action': 'اکشن',
    'Comedy': 'کمدی',
    'Drama': 'درام',
    'Horror': 'ترسناک',
    'Sci-Fi': 'علمی تخیلی',
    'Romance': 'عاشقانه',
    'Animation': 'انیمیشن',
    'Crime': 'جنایی',
    'Adventure': 'ماجراجویی',
    'Fantasy': 'فانتزی',
    'Mystery': 'رازآلود',
    'Thriller': 'هیجان‌انگیز',
    'History': 'تاریخی',
    'Biography': 'بیوگرافی',
    'Family': 'خانوادگی',
    'Documentary': 'مستند',
    'Music': 'موسیقی',
    'Musical': 'موزیکال',
    'Film-Noir': 'فیلم نوار',
    'Film-noir': 'فیلم نوار',
    'War': 'جنگی',
    'Western': 'وسترن',
    'Sport': 'ورزشی',
    'Short': 'کوتاه',
    'News': 'خبری',
    'Reality-TV': 'رئالیتی شو',
    'Talk-Show': 'تاک شو',
    'Game-Show': 'مسابقه',
  };

  static Future<List<String>> getGenres() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/genres'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((g) {
          final name = g['name'].toString();
          return _genreTranslations[name] ?? name;
        }).toList();
      }
    } catch (_) {}
    return [
      'اکشن',
      'کمدی',
      'درام',
      'ترسناک',
      'علمی تخیلی',
      'عاشقانه',
      'انیمیشن',
      'جنایی'
    ];
  }

  static Future<List<Map<String, dynamic>>> getGenresWithPosters() async {
    try {
      final genresResponse = await http.get(Uri.parse('$_baseUrl/genres'));
      if (genresResponse.statusCode == 200) {
        final List genresData = json.decode(genresResponse.body);
        List<Map<String, dynamic>> results = [];
        Set<String> usedPosters = {};
        int indexOffset = 0;

        for (var g in genresData) {
          final String originalName = g['name'].toString();
          final String faName = _genreTranslations[originalName] ?? originalName;
          final String genreId = g['id'].toString();

          String posterUrl = '';

          final responses = await Future.wait([
            http.get(Uri.parse('$_baseUrl/genres/$genreId/movies?page=1')),
            http.get(Uri.parse('$_baseUrl/genres/$genreId/movies?page=2')),
          ]);

          List allGenreMovies = [];
          for (var res in responses) {
            if (res.statusCode == 200) {
              final Map<String, dynamic> moviesData = json.decode(res.body);
              final List movieList = moviesData['data'] ?? [];
              allGenreMovies.addAll(movieList);
            }
          }

          if (allGenreMovies.isNotEmpty) {
            bool found = false;
            int currentIndex = indexOffset % allGenreMovies.length;

            for (int i = 0; i < allGenreMovies.length; i++) {
              int targetIdx = (currentIndex + i) % allGenreMovies.length;
              String candidate = allGenreMovies[targetIdx]['poster'] ?? '';

              if (candidate.isNotEmpty && !usedPosters.contains(candidate)) {
                posterUrl = candidate;
                usedPosters.add(posterUrl);
                found = true;
                break;
              }
            }

            if (!found && allGenreMovies.isNotEmpty) {
              posterUrl = allGenreMovies[0]['poster'] ?? '';
            }
          }

          indexOffset++;

          results.add({
            'name': faName,
            'poster': posterUrl,
          });
        }
        return results;
      }
    } catch (_) {}
    return [];
  }

  static Future<List<Movie>> getMoviesByGenre(String genreName) async {
    try {
      final genresResponse = await http.get(Uri.parse('$_baseUrl/genres'));
      if (genresResponse.statusCode == 200) {
        final List genresData = json.decode(genresResponse.body);

        String? targetId;
        for (var g in genresData) {
          final String originalName = g['name'].toString();
          final String faName = _genreTranslations[originalName] ?? originalName;
          if (faName == genreName || originalName.toLowerCase() == genreName.toLowerCase()) {
            targetId = g['id'].toString();
            break;
          }
        }

        if (targetId != null) {
          List<Movie> allMovies = [];

          final responses = await Future.wait([
            http.get(Uri.parse('$_baseUrl/genres/$targetId/movies?page=1')),
            http.get(Uri.parse('$_baseUrl/genres/$targetId/movies?page=2')),
          ]);

          for (var res in responses) {
            if (res.statusCode == 200) {
              final Map<String, dynamic> data = json.decode(res.body);
              final List results = data['data'] ?? [];
              allMovies.addAll(results.map((item) => Movie.fromJson(item)));
            }
          }

          final Map<String, Movie> uniqueMovies = {for (var m in allMovies) m.id: m};
          List<Movie> sortedMovies = uniqueMovies.values.toList();
          sortedMovies.sort((a, b) => (b.year ?? '').compareTo(a.year ?? ''));

          return sortedMovies;
        }
      }
    } catch (_) {}
    return [];
  }

  static Future<Movie> getMovieDetails(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/movies/$id'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        Movie movie = Movie.fromJson(data);

        if (movie.overview.isNotEmpty) {
          String faOverview = await _translateToPersian(movie.overview);
          return Movie(
            id: movie.id,
            title: movie.title,
            posterUrl: movie.posterUrl,
            rating: movie.rating,
            year: movie.year,
            overview: faOverview,
            genres: movie.genres,
            trailerUrl: movie.trailerUrl,
          );
        }
        return movie;
      } else {
        throw Exception('خطا در دریافت جزئیات');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> _translateToPersian(String text) async {
    try {
      final url = Uri.parse(
          'https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=fa&dt=t&q=${Uri.encodeComponent(text)}');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        String translated = '';
        for (var item in data[0]) {
          translated += item[0];
        }
        return translated;
      }
    } catch (_) {}
    return text;
  }
}