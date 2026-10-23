import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'movie_model.dart';
import 'tmdb_service.dart';
import 'movie_detail_page.dart';

class PromoSlider extends StatefulWidget {
  const PromoSlider({super.key});

  @override
  State<PromoSlider> createState() => _PromoSliderState();
}

class _PromoSliderState extends State<PromoSlider> {
  late PageController _pageController;

  static List<Movie>? _fixedMovieList;
  static bool _isLoading = false;

  static const int _infiniteCount = 10000;
  int _realIndex = 0;

  Timer? _autoPlayTimer;
  int _currentIndex = (_infiniteCount / 2).floor();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.38,
    );

    if (_fixedMovieList == null && !_isLoading) {
      _loadOnce();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAutoPlay();
      });
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      if (_pageController.hasClients) {
        _currentIndex++;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  Future<void> _loadOnce() async {
    _isLoading = true;
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

      if (mounted) {
        setState(() {
          _fixedMovieList = mixedList;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startAutoPlay();
        });
      }
    } catch (_) {
      try {
        final fallback = await TmdbService.getFeaturedMovies();
        if (mounted) {
          setState(() {
            _fixedMovieList = fallback;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startAutoPlay();
          });
        }
      } catch (_) {}
    } finally {
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryGreen = isDark ? const Color(0xFF00E676) : const Color(0xFF00A859);

    if (_fixedMovieList == null || _fixedMovieList!.isEmpty) {
      return SizedBox(
        height: 285,
        child: Center(
          child: CircularProgressIndicator(color: primaryGreen),
        ),
      );
    }

    final movies = _fixedMovieList!;

    if (_realIndex >= movies.length) {
      _realIndex = 0;
    }

    final currentMovie = movies[_realIndex];

    return SizedBox(
      height: 285,
      width: double.infinity,
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Container(
              key: ValueKey<String>(currentMovie.id),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(currentMovie.posterUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha:0.85),
                      ]
                          : [
                        Colors.white.withValues(alpha:0.4),
                        Colors.white.withValues(alpha:0.9),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                _stopAutoPlay();
              } else if (notification is ScrollEndNotification) {
                _startAutoPlay();
              }
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: _infiniteCount,
              onPageChanged: (int index) {
                setState(() {
                  _currentIndex = index;
                  _realIndex = index % movies.length;
                });
              },
              itemBuilder: (context, index) {
                final movie = movies[index % movies.length];

                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 0.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                    } else {
                      value = (_pageController.initialPage - index).toDouble();
                    }

                    double distortion = (1 - (value.abs() * 0.24)).clamp(0.0, 1.0);
                    double translateY = value.abs() * 24;

                    return Transform.translate(
                      offset: Offset(0, translateY),
                      child: Transform.scale(
                        scale: distortion,
                        child: Opacity(
                          opacity: (1 - (value.abs() * 0.35)).clamp(0.4, 1.0),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(movieData: movie),
                        ),
                      );
                    },
                    child: _buildMovieCard(movie, (index % movies.length) == _realIndex, isDark),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Movie movie, bool isSelected, bool isDark) {
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color badgeBg = isDark ? Colors.black.withValues(alpha:0.5) : Colors.white.withValues(alpha:0.7);
    final Color subTextColor = isDark ? Colors.grey : Colors.black54;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(movie.posterUrl),
              fit: BoxFit.cover,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: (isDark ? Colors.black : Colors.grey).withValues(alpha:0.6),
                blurRadius: 12,
                spreadRadius: 1,
              )
            ]
                : [],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow, color: isDark ? Colors.white : Colors.black, size: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          movie.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textColor,
            fontSize: isSelected ? 14 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                movie.rating,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(' | ', style: TextStyle(color: subTextColor, fontSize: 10)),
              Text(
                movie.year,
                style: TextStyle(color: subTextColor, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}