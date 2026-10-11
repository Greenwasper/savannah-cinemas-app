import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme.dart';
import '../widgets/brand_mark.dart';
import '../widgets/frosted_bottom_navigation.dart';
import '../widgets/savannah_menu_drawer.dart';

class Movie {
  const Movie({
    required this.title,
    required this.genre,
    required this.rating,
    required this.poster,
  });
  final String title;
  final String genre;
  final double rating;
  final String poster;
}

class _CinemaChoice {
  const _CinemaChoice({
    required this.id,
    required this.shortName,
    required this.name,
    required this.address,
  });

  final String id;
  final String shortName;
  final String name;
  final String address;
}

const _cinemaChoices = [
  _CinemaChoice(
    id: 'accra-mall',
    shortName: 'Accra Mall',
    name: 'Accra Mall Cinema',
    address: 'Accra Mall, Spintex Road',
  ),
  _CinemaChoice(
    id: 'tema',
    shortName: 'Tema',
    name: 'Tema Shopping Cinema',
    address: 'Tema Community 25',
  ),
  _CinemaChoice(
    id: 'kumasi-city',
    shortName: 'Kumasi City',
    name: 'Kumasi City Cinema',
    address: 'Kumasi City Mall, Lake Road',
  ),
];

String _activeCinemaId = _cinemaChoices.first.id;

const _movies = [
  Movie(
    title: 'Resident Evil',
    genre: 'Horror · Sci-Fi',
    rating: 7.3,
    poster: 'https://image.tmdb.org/t/p/w500/i7UyjfPio0VFHB9rBUZSFyhOoM8.jpg',
  ),
  Movie(
    title: 'The Odyssey',
    genre: 'Adventure · Fantasy',
    rating: 8.0,
    poster: 'https://image.tmdb.org/t/p/w500/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg',
  ),
  Movie(
    title: 'Colony',
    genre: 'Action · Horror',
    rating: 8.1,
    poster: 'https://image.tmdb.org/t/p/w500/tN799oUR0f1gUKDYdMNrDaY7I51.jpg',
  ),
  Movie(
    title: 'Coyote vs. Acme',
    genre: 'Comedy · Family',
    rating: 7.5,
    poster: 'https://image.tmdb.org/t/p/w500/kYDCl2y0VPvhT5eYWbMRInPoB03.jpg',
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  _CinemaChoice _selectedCinema = _cinemaChoices.firstWhere(
    (cinema) => cinema.id == _activeCinemaId,
  );
  String _query = '';
  bool _saved = false;

  List<Movie> get _filteredMovies {
    if (_query.trim().isEmpty) return _movies;
    final needle = _query.toLowerCase();
    return _movies
        .where(
          (movie) =>
              movie.title.toLowerCase().contains(needle) ||
              movie.genre.toLowerCase().contains(needle),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature will be added in the next build.')),
    );
  }

  void _handleMenuSelection(String destination) {
    final route = routeForDrawerDestination(destination);
    if (route != null) {
      Navigator.of(context).pushReplacementNamed(route);
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _comingSoon(destination);
    });
  }

  void _selectBottomDestination(int index) {
    openPrimaryDestination(context, currentIndex: 0, destinationIndex: index);
  }

  Future<void> _showCinemaPicker() async {
    final selection = await showModalBottomSheet<_CinemaChoice>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: SavannahColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your cinema',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose the cinema location you want to browse.',
                style: TextStyle(color: SavannahColors.muted),
              ),
              const SizedBox(height: 16),
              for (final cinema in _cinemaChoices)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: cinema.id == _selectedCinema.id
                        ? const Color(0x1FEDAA3B)
                        : SavannahColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      key: Key('cinemaChoice-${cinema.id}'),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 4,
                      ),
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: cinema.id == _selectedCinema.id
                              ? SavannahColors.gold
                              : const Color(0x24EDAA3B),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: cinema.id == _selectedCinema.id
                              ? SavannahColors.goldInk
                              : SavannahColors.gold,
                        ),
                      ),
                      title: Text(
                        cinema.name,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(cinema.address),
                      trailing: cinema.id == _selectedCinema.id
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: SavannahColors.gold,
                            )
                          : const Icon(
                              Icons.chevron_right_rounded,
                              color: SavannahColors.muted,
                            ),
                      onTap: () => Navigator.of(sheetContext).pop(cinema),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );

    if (!mounted || selection == null) return;
    setState(() {
      _selectedCinema = selection;
      _activeCinemaId = selection.id;
    });
  }

  void _signOut() {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      drawerScrimColor: const Color(0xB806060A),
      drawerEdgeDragWidth: 34,
      drawer: SavannahMenuDrawer(
        onSelect: _handleMenuSelection,
        onSignOut: _signOut,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildSearch()),
              if (_query.isEmpty) SliverToBoxAdapter(child: _buildHero()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 27, 20, 13),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _query.isEmpty ? 'Trending now' : 'Search results',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      if (_query.isEmpty)
                        TextButton(
                          onPressed: () => _comingSoon('The full film list'),
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              color: SavannahColors.gold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (_filteredMovies.isEmpty)
                const SliverToBoxAdapter(child: _EmptySearch())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
                  sliver: SliverGrid.builder(
                    itemCount: _filteredMovies.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 22,
                          childAspectRatio: .58,
                        ),
                    itemBuilder: (context, index) => _MovieCard(
                      movie: _filteredMovies[index],
                      onTap: () => _comingSoon(
                        '${_filteredMovies[index].title} details',
                      ),
                    ),
                  ),
                ),
              if (_query.isEmpty) SliverToBoxAdapter(child: _buildExperience()),
              const SliverToBoxAdapter(child: SizedBox(height: 116)),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: MediaQuery.paddingOf(context).top + 12,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xD914141C), Color(0x0014141C)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FrostedBottomNavigation(
        selectedIndex: 0,
        onDestinationSelected: _selectBottomDestination,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 10,
        20,
        17,
      ),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.menu_rounded,
            tooltip: 'Menu',
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          const SizedBox(width: 8),
          const Expanded(child: BrandMark(compact: true)),
          const SizedBox(width: 8),
          InkWell(
            key: const Key('cinemaSelector'),
            borderRadius: BorderRadius.circular(30),
            onTap: _showCinemaPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
              decoration: BoxDecoration(
                color: SavannahColors.surface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    _selectedCinema.shortName,
                    style: const TextStyle(fontSize: 12.5),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 17),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        key: const Key('movieSearch'),
        controller: _searchController,
        onChanged: (value) => setState(() => _query = value),
        decoration: InputDecoration(
          hintText: 'Search films or genres',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      height: 330,
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF3A1A0D),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://image.tmdb.org/t/p/original/qeQJx07rK2xm8SD2sJxFKhE7gs0.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (_, _, _) => const _HeroFallback(),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x18000000),
                  Color(0x22000000),
                  Color(0xF514141C),
                ],
                stops: [0, .38, 1],
              ),
            ),
          ),
          const Positioned(top: 16, left: 16, child: _Pill(label: 'IMAX')),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Spider-Man:\nBrand New Day',
                  style: TextStyle(
                    fontSize: 35,
                    height: .96,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.1,
                  ),
                ),
                const SizedBox(height: 11),
                const Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _Rating(label: '7.9'),
                    _Pill(label: 'Action'),
                    _Pill(label: '2h 10m'),
                    _Pill(label: 'PG-13'),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _comingSoon('Ticket booking'),
                        icon: const Icon(
                          Icons.confirmation_num_outlined,
                          size: 19,
                        ),
                        label: const Text('Book tickets'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0x33FFFFFF),
                          foregroundColor: SavannahColors.text,
                        ),
                        tooltip: _saved
                            ? 'Remove from watchlist'
                            : 'Add to watchlist',
                        onPressed: () => setState(() => _saved = !_saved),
                        icon: Icon(
                          _saved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperience() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Watch it bigger',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 14),
          Container(
            height: 176,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF22223A),
                  Color(0xFF332248),
                  Color(0xFF5A2B3F),
                ],
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  right: -46,
                  top: -48,
                  child: _ExperienceRings(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'IMAX and\nDolby Atmos',
                      style: TextStyle(
                        fontSize: 24,
                        height: 1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Bigger screens. Deeper sound.',
                      style: TextStyle(color: Color(0xFFC5C2D6), fontSize: 13),
                    ),
                    const Spacer(),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(142, 42),
                        maximumSize: const Size(142, 42),
                      ),
                      onPressed: () => _comingSoon('Cinema finder'),
                      child: const Text('Find a cinema'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  const _MovieCard({required this.movie, required this.onTap});
  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: SavannahColors.surfaceRaised),
                  Image.network(
                    movie.poster,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        _PosterFallback(title: movie.title),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _Rating(label: movie.rating.toStringAsFixed(1)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Expanded(
                child: Text(
                  movie.genre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SavannahColors.muted,
                    fontSize: 12.5,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.star_rounded,
                color: SavannahColors.gold,
                size: 15,
              ),
              Text(
                movie.rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: SavannahColors.gold,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 21),
      style: IconButton.styleFrom(
        backgroundColor: SavannahColors.surface,
        foregroundColor: SavannahColors.text,
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x35FFFFFF),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xCC14141C),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: SavannahColors.gold, size: 14),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              color: SavannahColors.gold,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroFallback extends StatelessWidget {
  const _HeroFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1608), Color(0xFFB4581E), SavannahColors.gold],
        ),
      ),
      child: Align(
        alignment: Alignment(.72, -.55),
        child: Icon(
          Icons.blur_circular_rounded,
          size: 180,
          color: Color(0x44FFE3A6),
        ),
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      alignment: Alignment.bottomLeft,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF302449), Color(0xFF8E4A1E)],
        ),
      ),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 20,
          height: .95,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ExperienceRings extends StatelessWidget {
  const _ExperienceRings();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 190,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0x99EDAA3B), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0x18EDAA3B), spreadRadius: 18),
          BoxShadow(color: Color(0x0DEDDA3B), spreadRadius: 38),
        ],
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(36, 35, 36, 80),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 52, color: SavannahColors.gold),
          SizedBox(height: 14),
          Text(
            'No films found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 6),
          Text(
            'Try a film title or a genre like action.',
            textAlign: TextAlign.center,
            style: TextStyle(color: SavannahColors.muted),
          ),
        ],
      ),
    );
  }
}
