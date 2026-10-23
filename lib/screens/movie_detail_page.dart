import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'movie_model.dart';
import 'tmdb_service.dart';
import 'package:android_intent_plus/android_intent.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movieData;

  const MovieDetailPage({super.key, required this.movieData});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<Movie> _movieDetailFuture;

  // لیست موقت نظرات کاربران برای این اثر
  final List<String> _comments = [
    'فوق‌العاده بود، حتماً پیشنهاد می‌کنم ببینید!',
    'داستان جذابی داشت، خسته کننده نبود.',
  ];
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text.trim());
        _commentController.clear();
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    _movieDetailFuture = TmdbService.getMovieDetails(widget.movieData.id);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // تابع تبدیل هوشمند و کامل نام کشور به فارسی
  String _translateCountry(String country) {
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

  // تابع تبدیل ژانرهای انگلیسی به فارسی
  String _translateGenre(String englishGenre) {
    final Map<String, String> genreMap = {
      'Action': 'اکشن',
      'Adventure': 'ماجراجویی',
      'Animation': 'انیمیشن',
      'Comedy': 'کمدی',
      'Crime': 'جنایی',
      'Drama': 'درام',
      'Family': 'خانوادگی',
      'Fantasy': 'فانتزی',
      'Horror': 'ترسناک',
      'Mystery': 'معمایی',
      'Romance': 'عاشقانه',
      'Science Fiction': 'علمی-تخیلی',
      'Sci-Fi': 'علمی-تخیلی',
      'Thriller': 'هیجانی',
      'War': 'جنگی',
      'Western': 'وسترن',
      'History': 'تاریخی',
      'Biography': 'زندگی‌نامه',
      'Documentary': 'مستند',
      'Music': 'موزیکال',
      'Sport': 'ورزشی',
    };
    return genreMap[englishGenre.trim()] ?? englishGenre;
  }

  Future<void> _launchUrl(BuildContext context, String url, String typeName) async {
    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لینک $typeName برای این اثر یافت نشد.')),
      );
    }
  }
  // لینک تستی (ویدیوی نمونه‌ی متن‌باز Big Buck Bunny)
  // ویدیوهای نمونه‌ی آزاد (متن‌باز)
  static const List<String> _demoVideos = [
    'https://gnjx4q9pgkzymnchqbc3fy74.abrtech.top/aG5p/Film/New-Server/Avengers%20Infinity%20War%20BluRay/Farsi%20Dubbed/V2/Avengers.Infinity.War.2018.1080p.Farsi.Dubbed.Film9.mkv',
    'https://bvxbbajdhgxd9g87jwb463wx.abrtech.top/yA3f/Film/1994/The.Shawshank.Redemption.1994/DUB/The.Shawshank.Redemption.1994.1080p.BluRay.Farsi.2Dubbed.Film2Media.mkv',
    'https://bvxbbajdhgxd9g87jwb463wx.abrtech.top/yA3f/Film/1972/The.Godfather.All.in.One/1972/DUB/The.Godfather.1972.1080p.BluRay.Farsi.Dubbed.Film2Media.mkv',
    'https://bvxbbajdhgxd9g87jwb463wx.abrtech.top/yA3f/Film/1994/Forrest.Gump.1994/DUB/Forrest.Gump.1994.1080p.BluRay.Farsi.Dubbed.Film2Media.mkv',
    'https://bvxbbajdhgxd9g87jwb463wx.abrtech.top/yA3f/Film/1995/Toy.Story.All.in.one/1999/3DUB/Toy.Story.2.1999.1080p.BluRay.Farsi.Dubbed.Film2Media.mkv',
  ];

  // هر فیلم بر اساس id همیشه همون ویدیوی خودش رو میگیره
  String _videoFor(String id) {
    final n = int.tryParse(id) ?? id.hashCode;
    return _demoVideos[n.abs() % _demoVideos.length];
  }

  Future<void> _playInMxPlayer(BuildContext context, String url) async {
    try {
      final intent = AndroidIntent(
        action: 'action_view',
        data: url,
        type: 'video/*',
        package: 'com.mxtech.videoplayer.ad',
      );
      await intent.launch();
    } catch (e) {
      // اگه MX Player نصب نبود، با هر برنامه‌ی دیگه باز کن
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('پخش‌کننده‌ای برای باز کردن ویدیو پیدا نشد.')),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // رنگ‌های پویا بر اساس تم
    final Color scaffoldBg = isDark ? const Color(0xFF0D1117) : Colors.white;
    final Color cardBg = isDark ? const Color(0xFF161D26) : Colors.grey[100]!;
    final Color primaryGreen = isDark ? const Color(0xFF00E676) : const Color(0xFF00A859);
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black54;
    final Color borderColor = isDark ? Colors.white24 : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          widget.movieData.title,
          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Movie>(
        future: _movieDetailFuture,
        builder: (context, snapshot) {
          final serverMovie = snapshot.data;

          final resolvedCountry = (serverMovie?.originCountry != null && serverMovie!.originCountry != 'نامشخص')
              ? serverMovie.originCountry
              : widget.movieData.originCountry;

          final displayMovie = Movie(
            id: serverMovie?.id ?? widget.movieData.id,
            title: serverMovie?.title ?? widget.movieData.title,
            persianTitle: (serverMovie?.persianTitle != null && serverMovie!.persianTitle.isNotEmpty)
                ? serverMovie.persianTitle
                : widget.movieData.persianTitle,
            posterUrl: (serverMovie?.posterUrl != null && serverMovie!.posterUrl.isNotEmpty)
                ? serverMovie.posterUrl
                : widget.movieData.posterUrl,
            rating: serverMovie?.rating ?? widget.movieData.rating,
            year: serverMovie?.year ?? widget.movieData.year,
            overview: (serverMovie?.overview != null && serverMovie!.overview.isNotEmpty)
                ? serverMovie.overview
                : widget.movieData.overview,
            genres: (serverMovie?.genres != null && serverMovie!.genres.isNotEmpty)
                ? serverMovie.genres
                : widget.movieData.genres,
            trailerUrl: serverMovie?.trailerUrl ?? widget.movieData.trailerUrl,
            originCountry: resolvedCountry,
          );

          final persianGenres = displayMovie.genres
              .map((g) => _translateGenre(g))
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ۱. پوستر فیلم
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        displayMovie.posterUrl,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          height: 300,
                          color: isDark ? Colors.grey[900] : Colors.grey[300],
                          child: Icon(Icons.movie, size: 80, color: subTextColor),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ۲. اطلاعات فیلم
                Text(
                  'اسم فیلم: ${displayMovie.title}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'ژانر: ${persianGenres.isNotEmpty ? persianGenres.join('، ') : 'نامشخص'}',
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'سال ساخت: ${displayMovie.year}',
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'امتیاز فیلم یا سریال: ${displayMovie.rating}',
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.public, size: 18, color: primaryGreen),
                    const SizedBox(width: 6),
                    Text(
                      'محصول کشور: ${_translateCountry(resolvedCountry)}',
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ۳. دکمه‌های پخش
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _playInMxPlayer(context, _videoFor(displayMovie.id)),
                          icon: const Icon(Icons.play_circle_fill, color: Colors.black, size: 24),
                          label: const Text(
                            'پخش فیلم',
                            style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: primaryGreen, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _launchUrl(context, displayMovie.trailerUrl, 'تریلر'),
                          icon: Icon(Icons.movie_creation_outlined, color: primaryGreen, size: 22),
                          label: Text(
                            'پخش تریلر',
                            style: TextStyle(color: primaryGreen, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ۴. خلاصه داستان
                Text(
                  'خلاصه داستان:',
                  style: TextStyle(color: primaryGreen, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  displayMovie.overview.isNotEmpty ? displayMovie.overview : 'توضیحاتی برای این اثر یافت نشد.',
                  style: TextStyle(color: subTextColor, fontSize: 15, height: 1.6),
                ),

                const SizedBox(height: 30),
                Divider(color: borderColor),
                const SizedBox(height: 16),

                // ۵. بخش نظرات کاربران
                Text(
                  'نظرات کاربران',
                  style: TextStyle(color: primaryGreen, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'نظر خود را بنویسید...',
                          hintStyle: TextStyle(color: subTextColor),
                          filled: true,
                          fillColor: cardBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _addComment,
                      icon: Icon(Icons.send, color: primaryGreen),
                      style: IconButton.styleFrom(
                        backgroundColor: cardBg,
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _comments.isEmpty
                    ? Text('هنوز نظری ثبت نشده است.', style: TextStyle(color: subTextColor))
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.person_outline, color: subTextColor, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _comments[index],
                              style: TextStyle(color: textColor, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}