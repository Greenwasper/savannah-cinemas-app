import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/frosted_bottom_navigation.dart';
import '../widgets/savannah_menu_drawer.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'tickets_screen.dart';

class CinemaBranch {
  const CinemaBranch({
    required this.name,
    required this.address,
    required this.distance,
    required this.formats,
    required this.screens,
    required this.hours,
  });

  final String name;
  final String address;
  final String distance;
  final List<String> formats;
  final int screens;
  final String hours;
}

const _branches = [
  CinemaBranch(
    name: 'Accra Mall Cinema',
    address: 'Accra Mall, Spintex Road',
    distance: '2.4 km',
    formats: ['IMAX', 'Dolby Atmos', 'VIP', 'Standard'],
    screens: 8,
    hours: 'Open until 11:30 PM',
  ),
  CinemaBranch(
    name: 'Tema Shopping Cinema',
    address: 'Tema Community 25',
    distance: '28.6 km',
    formats: ['Dolby Atmos', 'VIP', 'Standard'],
    screens: 4,
    hours: 'Open until 10:45 PM',
  ),
  CinemaBranch(
    name: 'Kumasi City Cinema',
    address: 'Kumasi City Mall, Lake Road',
    distance: '202 km',
    formats: ['IMAX', 'Dolby Atmos', 'VIP', 'Standard'],
    screens: 6,
    hours: 'Open until 11:00 PM',
  ),
];

class CinemasScreen extends StatefulWidget {
  const CinemasScreen({super.key});

  @override
  State<CinemasScreen> createState() => _CinemasScreenState();
}

class _CinemasScreenState extends State<CinemasScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  String _filter = 'Nearest';
  String _query = '';
  bool _searching = false;

  List<CinemaBranch> get _visibleBranches {
    return _branches.where((branch) {
      final matchesFilter =
          _filter == 'Nearest' || branch.formats.contains(_filter);
      final needle = _query.trim().toLowerCase();
      final matchesQuery =
          needle.isEmpty ||
          branch.name.toLowerCase().contains(needle) ||
          branch.address.toLowerCase().contains(needle);
      return matchesFilter && matchesQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$message will be added in the next build.')),
    );
  }

  void _openFilms() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  void _handleMenuSelection(String destination) {
    if (destination == 'Cinemas') return;
    if (destination == 'Now showing') {
      _openFilms();
      return;
    }
    if (destination == 'My bookings') {
      _openTickets();
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showMessage(destination);
    });
  }

  void _selectBottomDestination(int index) {
    if (index == 0) {
      _openFilms();
    } else if (index == 2) {
      _openTickets();
    } else if (index != 1) {
      _showMessage(['Films', 'Cinemas', 'Tickets', 'Account'][index]);
    }
  }

  void _openTickets() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const TicketsScreen()),
    );
  }

  void _signOut() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final branches = _visibleBranches;
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      drawerScrimColor: const Color(0xB806060A),
      drawerEdgeDragWidth: 34,
      drawer: SavannahMenuDrawer(
        selectedDestination: 'Cinemas',
        onSelect: _handleMenuSelection,
        onSignOut: _signOut,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildFilters()),
              const SliverToBoxAdapter(child: _CinemaMap()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 27, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _query.isNotEmpty
                              ? 'Search results'
                              : _filter == 'Nearest'
                              ? 'Near you'
                              : _filter,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Text(
                        '${branches.length} ${branches.length == 1 ? 'cinema' : 'cinemas'}',
                        style: const TextStyle(
                          color: SavannahColors.muted,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (branches.isEmpty)
                const SliverToBoxAdapter(child: _NoCinemas())
              else
                SliverList.builder(
                  itemCount: branches.length,
                  itemBuilder: (context, index) => _CinemaCard(
                    branch: branches[index],
                    onDirections: () => _showMessage('Directions'),
                    onShowtimes: () => _showMessage('Showtimes'),
                  ),
                ),
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
        selectedIndex: 1,
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
        15,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: _searching
            ? Row(
                key: const ValueKey('search'),
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('cinemaSearch'),
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (value) => setState(() => _query = value),
                      decoration: const InputDecoration(
                        hintText: 'Search cinemas',
                        prefixIcon: Icon(Icons.search_rounded),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _query = '';
                        _searching = false;
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              )
            : Row(
                key: const ValueKey('title'),
                children: [
                  IconButton.filled(
                    tooltip: 'Menu',
                    style: IconButton.styleFrom(
                      backgroundColor: SavannahColors.surface,
                    ),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.menu_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Cinemas',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton.filled(
                    tooltip: 'Search cinemas',
                    style: IconButton.styleFrom(
                      backgroundColor: SavannahColors.surface,
                    ),
                    onPressed: () => setState(() => _searching = true),
                    icon: const Icon(Icons.search_rounded),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFilters() {
    const filters = ['Nearest', 'IMAX', 'Dolby Atmos', 'VIP'];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = filters[index];
          final selected = label == _filter;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => setState(() => _filter = label),
            showCheckmark: false,
            side: BorderSide.none,
            backgroundColor: SavannahColors.surface,
            selectedColor: SavannahColors.gold,
            labelStyle: TextStyle(
              color: selected ? SavannahColors.goldInk : SavannahColors.muted,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
          );
        },
      ),
    );
  }
}

class _CinemaMap extends StatelessWidget {
  const _CinemaMap();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF181824),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: SavannahColors.line),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              const Positioned.fill(child: CustomPaint(painter: _MapPainter())),
              Positioned(
                left: constraints.maxWidth * .43,
                top: constraints.maxHeight * .35,
                child: const _MapPin(label: 'Accra Mall', primary: true),
              ),
              Positioned(
                left: constraints.maxWidth * .69,
                top: constraints.maxHeight * .18,
                child: const _MapPin(label: 'Tema'),
              ),
              Positioned(
                left: constraints.maxWidth * .12,
                top: constraints.maxHeight * .59,
                child: const _MapPin(label: 'Kumasi'),
              ),
              Positioned(
                left: 13,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xD914141C),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.my_location_rounded,
                        color: SavannahColors.gold,
                        size: 14,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Greater Accra',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final water = Paint()..color = const Color(0xFF14202E);
    final waterPath = Path()
      ..moveTo(0, size.height * .78)
      ..cubicTo(
        size.width * .22,
        size.height * .56,
        size.width * .32,
        size.height,
        size.width * .58,
        size.height * .73,
      )
      ..cubicTo(
        size.width * .75,
        size.height * .54,
        size.width * .86,
        size.height * .42,
        size.width,
        size.height * .55,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(waterPath, water);

    final mainRoad = Paint()
      ..color = const Color(0xFF2A2A3C)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final road = Paint()
      ..color = const Color(0xFF35354B)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(
      Path()
        ..moveTo(-10, size.height * .28)
        ..lineTo(size.width * .36, size.height * .42)
        ..lineTo(size.width * .62, size.height * .18)
        ..lineTo(size.width + 10, size.height * .34),
      mainRoad,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * .3, -10)
        ..lineTo(size.width * .36, size.height * .48)
        ..lineTo(size.width * .31, size.height + 10),
      mainRoad,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * .72, -10)
        ..lineTo(size.width * .64, size.height * .31)
        ..lineTo(size.width * .76, size.height + 10),
      mainRoad,
    );
    canvas.drawLine(
      Offset(-10, size.height * .55),
      Offset(size.width + 10, size.height * .66),
      road,
    );
    canvas.drawLine(
      Offset(size.width * .17, -10),
      Offset(size.width * .23, size.height + 10),
      road,
    );
    canvas.drawLine(
      Offset(size.width * .88, -10),
      Offset(size.width * .9, size.height + 10),
      road,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.label, this.primary = false});
  final String label;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final color = primary ? SavannahColors.gold : SavannahColors.surfaceRaised;
    return FractionalTranslation(
      translation: const Offset(-.5, -1),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: primary ? SavannahColors.goldInk : SavannahColors.text,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(width: 2, height: 8, color: color),
        ],
      ),
    );
  }
}

class _CinemaCard extends StatelessWidget {
  const _CinemaCard({
    required this.branch,
    required this.onDirections,
    required this.onShowtimes,
  });
  final CinemaBranch branch;
  final VoidCallback onDirections;
  final VoidCallback onShowtimes;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SavannahColors.surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0x77353549)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      branch.address,
                      style: const TextStyle(
                        color: SavannahColors.muted,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                branch.distance,
                style: const TextStyle(
                  color: SavannahColors.gold,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: branch.formats
                .map(
                  (format) =>
                      _FormatTag(label: format, highlighted: format == 'IMAX'),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 16,
                color: Color(0xFF4DB88A),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  branch.hours,
                  style: const TextStyle(
                    color: Color(0xFF8EDDB9),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${branch.screens} screens',
                style: const TextStyle(
                  color: SavannahColors.muted,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          const Divider(height: 1, color: SavannahColors.line),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDirections,
                  icon: const Icon(Icons.directions_outlined, size: 17),
                  label: const Text('Directions'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SavannahColors.text,
                    side: const BorderSide(color: SavannahColors.line),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: FilledButton(
                  onPressed: onShowtimes,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(42),
                  ),
                  child: const Text('Showtimes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormatTag extends StatelessWidget {
  const _FormatTag({required this.label, required this.highlighted});
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: highlighted
            ? const Color(0x29EDAA3B)
            : SavannahColors.surfaceRaised,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: highlighted ? SavannahColors.gold : SavannahColors.text,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _NoCinemas extends StatelessWidget {
  const _NoCinemas();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(30, 38, 30, 90),
      child: Column(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 48,
            color: SavannahColors.gold,
          ),
          SizedBox(height: 13),
          Text(
            'No cinemas found',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 6),
          Text(
            'Try another name, location or screen format.',
            textAlign: TextAlign.center,
            style: TextStyle(color: SavannahColors.muted),
          ),
        ],
      ),
    );
  }
}
