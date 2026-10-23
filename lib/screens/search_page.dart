import 'package:flutter/material.dart';
import 'tmdb_service.dart';
import 'movie_model.dart';
import 'movie_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Movie> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      List<Movie> moviesPage1 = await TmdbService.getPopularMovies(page: 1);
      List<Movie> moviesPage2 = await TmdbService.getPopularMovies(page: 2);
      List<Movie> seriesPage1 = await TmdbService.getPopularSeries(page: 1);

      List<Movie> allItems = [...moviesPage1, ...moviesPage2, ...seriesPage1];

      final Map<String, Movie> uniqueMap = {for (var item in allItems) item.id: item};

      final results = uniqueMap.values.where((movie) {
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color primaryGreen = isDark ? const Color(0xFF00E676) : const Color(0xFF00A859);
    final Color bgColor = isDark ? const Color(0xFF0D1117) : Colors.white;
    final Color cardBg = isDark ? const Color(0xFF161D26) : Colors.grey[100]!;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black54;
    final Color hintColor = isDark ? Colors.white38 : Colors.black45;
    final Color borderColor = isDark ? Colors.white10 : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                      Text(
                        'جستجو',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     
                      IconButton(
                        icon: Icon(Icons.arrow_forward_rounded, color: textColor, size: 24),
                        onPressed: () => Navigator.of(context).pop(),
                      ),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: _searchController,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: textColor, fontSize: 14),
                  cursorColor: primaryGreen,
                  decoration: InputDecoration(
                    hintText: '...فیلم، سریال مورد نظر را جستجو کنید',
                    hintStyle: TextStyle(color: hintColor, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: Icon(Icons.search_rounded, color: hintColor, size: 22),
                    prefixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear, color: hintColor, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {});
                    _performSearch(value);
                  },
                ),
              ),
            ),

            Expanded(
              child: _isLoading
                  ? Center(
                child: CircularProgressIndicator(color: primaryGreen),
              )
                  : _searchResults.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_hasSearched) ...[
                      Icon(Icons.search_off_rounded, color: hintColor, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'موردی یافت نشد',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else ...[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: borderColor,
                                width: 1.5,
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(-8, -10),
                            child: Container(
                              width: 85,
                              height: 55,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF253140) : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(8, 10),
                            child: Container(
                              width: 85,
                              height: 55,
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.grey[400],
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'اینجا خالیه و خبری نیست!',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final movie = _searchResults[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          movie.posterUrl,
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.movie, color: hintColor),
                        ),
                      ),
                      title: Text(
                        movie.title,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          'سال انتشار: ${movie.year}',
                          style: TextStyle(color: subTextColor, fontSize: 12),
                        ),
                      ),
                      trailing: Icon(Icons.arrow_back_ios_rounded, color: hintColor, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(movieData: movie),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}