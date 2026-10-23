import 'package:flutter/material.dart';
import 'tmdb_service.dart';
import 'genre_movies_page.dart';

class GenreSection extends StatefulWidget {
  final Function(String genreName)? onGenreTap;

  const GenreSection({super.key, this.onGenreTap});

  @override
  State<GenreSection> createState() => _GenreSectionState();
}

class _GenreSectionState extends State<GenreSection> {
  bool isMovieGenreSelected = true;
  late Future<List<Map<String, dynamic>>> _genresWithPosterFuture;

  @override
  void initState() {
    super.initState();
    _genresWithPosterFuture = TmdbService.getGenresWithPosters();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;


    final Color cardBg = isDark ? const Color(0xFF161D26) : Colors.grey[100]!;
    final Color primaryGreen = isDark ? const Color(0xFF00E676) : const Color(0xFF00A859);
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black54;
    final Color borderColor = isDark ? Colors.white12 : Colors.grey[300]!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  Icon(Icons.grid_view_rounded, color: textColor, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'ژانر ها',
                    style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),


              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => isMovieGenreSelected = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isMovieGenreSelected ? primaryGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'ژانر فیلم',
                          style: TextStyle(
                            color: isMovieGenreSelected ? (isDark ? Colors.black : Colors.white) : subTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => setState(() => isMovieGenreSelected = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: !isMovieGenreSelected ? primaryGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'ژانر سریال',
                          style: TextStyle(
                            color: !isMovieGenreSelected ? (isDark ? Colors.black : Colors.white) : subTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 95,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _genresWithPosterFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: primaryGreen),
                );
              }
              final genres = snapshot.data ?? [];

              if (genres.isEmpty) return const SizedBox();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  final item = genres[index];
                  final genreName = item['name'] ?? '';
                  final imageUrl = item['poster'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GenreMoviesPage(genreName: genreName),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 145,
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 0.8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: cardBg,
                                    child: Center(
                                      child: Icon(Icons.movie, color: subTextColor, size: 30),
                                    ),
                                  );
                                },
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withValues(alpha: 0.8),
                                      Colors.black.withValues(alpha: 0.2),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text(
                                    genreName,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 4.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}