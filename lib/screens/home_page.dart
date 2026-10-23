import 'package:flutter/material.dart';
import 'movie_card.dart';
import 'movie_model.dart';
import 'section_header.dart';
import 'custom_drawer.dart';
import 'promo_slider.dart';
import 'genre_section.dart';
import 'search_page.dart';
import 'tmdb_service.dart';
import 'see_all_movies_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {


  static Future<List<Movie>>? _cachedMoviesFuture;
  static Future<List<Movie>>? _cachedSeriesFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _cachedMoviesFuture ??= TmdbService.getPopularMovies();
    _cachedSeriesFuture ??= TmdbService.getPopularSeries();
  }

  Widget _buildHorizontalList(Future<List<Movie>> futureData, bool isDark, Color primaryGreen) {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<Movie>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: primaryGreen),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'خطا در دریافت اطلاعات شبکه',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontSize: 12,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'موردی یافت نشد',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontSize: 12,
                ),
              ),
            );
          }

          final items = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: items[index]);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);


    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF0F1017) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color primaryGreen = isDark ? const Color(0xFF00E676) : const Color(0xFF00A859);

    return Scaffold(
      backgroundColor: bgColor,
      drawer: const CustomDrawer(),


      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'MovieVerse',
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: textColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
          ),
        ],
      ),


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const PromoSlider(),

            const SizedBox(height: 24),


            SectionHeader(
              title: 'فیلم‌ها',
              onSeeAllPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  SeeAllMoviesPage(isSeries: false,isDark: isDark),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildHorizontalList(_cachedMoviesFuture!, isDark, primaryGreen),

            const SizedBox(height: 24),


            GenreSection(
              onGenreTap: (genreName) {
                setState(() {
                  _cachedMoviesFuture = TmdbService.getMoviesByGenre(genreName);
                });
              },
            ),

            const SizedBox(height: 24),
            SectionHeader(
              title: 'سریال‌ها',
              onSeeAllPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  SeeAllMoviesPage(isSeries: true,isDark: isDark),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildHorizontalList(_cachedSeriesFuture!, isDark, primaryGreen),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}