class Movie {
  final String id;
  final String title;
  final String persianTitle;
  final String posterUrl;
  final String rating;
  final String year;
  final String overview;
  final List<String> genres;
  final String trailerUrl;
  final String originCountry;

  Movie({
    required this.id,
    required this.title,
    this.persianTitle = '',
    required this.posterUrl,
    required this.rating,
    required this.year,
    required this.overview,
    required this.genres,
    required this.trailerUrl,
    this.originCountry = 'نامشخص',
  });


  static String _translateCountry(String country) {
    if (country.isEmpty || country == 'نامشخص') return 'نامشخص';

    final cleanCountry = country.trim().toLowerCase();

    final Map<String, String> countryMap = {
      'usa': 'آمریکا',
      'united states': 'آمریکا',
      'united states of america': 'آمریکا',
      'south korea': 'کره جنوبی',
      'korea': 'کره جنوبی',
      'iran': 'ایران',
      'france': 'فرانسه',
      'japan': 'ژاپن',
      'uk': 'انگلستان',
      'united kingdom': 'انگلستان',
      'germany': 'آلمان',
      'china': 'چین',
      'spain': 'اسپانیا',
      'canada': 'کانادا',
      'italy': 'ایتالیا',
      'india': 'هند',
      'new zealand': 'نیوزلند',
      'australia': 'استرالیا',
      'russia': 'روسیه',
      'brazil': 'برزیل',
      'turkey': 'ترکیه',
      'mexico': 'مکزیک',
      'argentina': 'آرژانتین',
      'denmark': 'دانمارک',
      'sweden': 'سوئد',
      'norway': 'نروژ',
    };

    return countryMap[cleanCountry] ?? country;
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<String> parsedGenres = [];
    if (json['genres'] != null && json['genres'] is List) {
      parsedGenres = List<String>.from(json['genres']);
    }

    String mainTitle = json['title'] ?? 'بدون عنوان';
    String pTitle = json['persian_title'] ?? json['title_fa'] ?? mainTitle;

    String rawCountry = 'نامشخص';
    if (json['country'] != null && json['country'].toString().isNotEmpty) {
      rawCountry = json['country'].toString();
    } else if (json['countries'] != null && json['countries'].toString().isNotEmpty) {
      rawCountry = json['countries'].toString();
    } else if (json['origin_country'] != null && json['origin_country'].toString().isNotEmpty) {
      rawCountry = json['origin_country'].toString();
    }

    return Movie(
      id: json['id']?.toString() ?? '',
      title: mainTitle,
      persianTitle: pTitle,
      posterUrl: json['poster'] ?? '',
      rating: json['imdb_rating']?.toString() ?? 'N/A',
      year: json['year']?.toString() ?? '',
      overview: json['plot'] ?? json['summary'] ?? '',
      genres: parsedGenres,
      trailerUrl: json['trailer']?.toString() ?? '',
      originCountry: _translateCountry(rawCountry),
    );
  }
}