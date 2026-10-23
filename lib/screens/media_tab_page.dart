import 'package:flutter/material.dart';
import 'movie_model.dart';
import 'tmdb_service.dart';
import 'movie_detail_page.dart';

class MediaTabPage extends StatefulWidget {
  final bool isSeries;
  final String title;

  const MediaTabPage({
    super.key,
    required this.isSeries,
    required this.title,
  });

  @override
  State<MediaTabPage> createState() => _MediaTabPageState();
}

class _MediaTabPageState extends State<MediaTabPage> {
  late Future<List<Movie>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _loadData();
  }


  Future<List<Movie>> _loadData() async {
    List<Movie> allItems = [];

    try {
      if (widget.isSeries) {

        final s1 = await TmdbService.getPopularSeries(page: 5);
        final s2 = await TmdbService.getPopularSeries(page: 6);
        final s3 = await TmdbService.getPopularSeries(page: 7);
        final s4 = await TmdbService.getPopularSeries(page: 8);

        allItems.addAll(s1);
        allItems.addAll(s2);
        allItems.addAll(s3);
        allItems.addAll(s4);
      } else {

        final p1 = await TmdbService.getPopularMovies(page: 1);
        final p2 = await TmdbService.getPopularMovies(page: 2);
        final p3 = await TmdbService.getPopularMovies(page: 3);
        final p4 = await TmdbService.getPopularMovies(page: 4);

        allItems.addAll(p1);
        allItems.addAll(p2);
        allItems.addAll(p3);
        allItems.addAll(p4);
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
    }


    final uniqueItems = {for (var item in allItems) item.id: item}.values.toList();
    return uniqueItems;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;


    final Color scaffoldBg = isDark ? const Color(0xFF0F1017) : Colors.white;
    final Color primaryGreen = isDark ? const Color(0xFF00E676) : const Color(0xFF00A859);
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.white54 : Colors.black54;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: primaryGreen),
            );
          }

          final list = snapshot.data ?? [];

          if (list.isEmpty) {
            return Center(
              child: Text('موردی یافت نشد', style: TextStyle(color: subTextColor)),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.62,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final movie = list[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movieData: movie),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          movie.posterUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: isDark ? Colors.grey[900] : Colors.grey[300],
                            child: Icon(Icons.movie_creation_outlined, color: subTextColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}