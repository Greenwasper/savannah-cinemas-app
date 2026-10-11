import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme.dart';
import '../widgets/brand_mark.dart';
import '../widgets/frosted_bottom_navigation.dart';
import '../widgets/savannah_menu_drawer.dart';

enum MainDestination { events, offers, account }

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key, required this.destination});

  final MainDestination destination;

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int get _selectedIndex => switch (widget.destination) {
    MainDestination.events => 1,
    MainDestination.offers => 2,
    MainDestination.account => 3,
  };

  String get _title => switch (widget.destination) {
    MainDestination.events => 'Events',
    MainDestination.offers => 'Offers',
    MainDestination.account => 'Your account',
  };

  void _showMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature will be added in the next build.')),
    );
  }

  void _handleMenuSelection(String destination) {
    final route = routeForDrawerDestination(destination);
    if (route != null) {
      if (route == AppRoutes.account &&
          widget.destination == MainDestination.account) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(route);
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showMessage(destination);
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
        selectedDestination: widget.destination == MainDestination.account
            ? 'Profile'
            : '',
        onSelect: _handleMenuSelection,
        onSignOut: _signOut,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            sliver: SliverToBoxAdapter(
              child: widget.destination == MainDestination.account
                  ? _AccountContent(onSelect: _handleMenuSelection)
                  : _ComingSoonContent(destination: widget.destination),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FrostedBottomNavigation(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => openPrimaryDestination(
          context,
          currentIndex: _selectedIndex,
          destinationIndex: index,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 10,
        20,
        12,
      ),
      child: Row(
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
              _title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const BrandMark(compact: true),
        ],
      ),
    );
  }
}

class _ComingSoonContent extends StatelessWidget {
  const _ComingSoonContent({required this.destination});

  final MainDestination destination;

  @override
  Widget build(BuildContext context) {
    final isEvents = destination == MainDestination.events;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 280,
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isEvents
                  ? const [Color(0xFF30213C), Color(0xFF772F49)]
                  : const [Color(0xFF3A2815), Color(0xFF8B4B20)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -14,
                top: -18,
                child: Icon(
                  isEvents ? Icons.star_rounded : Icons.local_offer_rounded,
                  size: 155,
                  color: const Color(0x22FFFFFF),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isEvents
                          ? Icons.star_outline_rounded
                          : Icons.local_offer_outlined,
                      color: SavannahColors.gold,
                      size: 34,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      isEvents ? 'More than movies' : 'A little extra',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      isEvents
                          ? 'Premieres, live screenings and cinema experiences are coming soon.'
                          : 'Member rewards, ticket bundles and seasonal offers are coming soon.',
                      style: const TextStyle(
                        color: Color(0xFFD2CEDA),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Text(
          'Nothing to show just yet',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'Check back soon. New experiences will appear here as they become available.',
          style: TextStyle(color: SavannahColors.muted, height: 1.5),
        ),
      ],
    );
  }
}

class _AccountContent extends StatelessWidget {
  const _AccountContent({required this.onSelect});

  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    const shortcuts = [
      (Icons.confirmation_num_outlined, 'My bookings'),
      (Icons.history_rounded, 'Watch history'),
      (Icons.emoji_events_outlined, 'My trophies'),
      (Icons.bookmark_border_rounded, 'Watchlist'),
      (Icons.settings_outlined, 'Settings'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF292434), Color(0xFF472B2A)],
            ),
            border: Border.all(color: SavannahColors.line),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 31,
                backgroundColor: SavannahColors.gold,
                child: Icon(
                  Icons.person_rounded,
                  size: 34,
                  color: SavannahColors.goldInk,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cinema lover',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Bronze member  •  0 points',
                      style: TextStyle(
                        color: SavannahColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text('Your account', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Material(
          color: SavannahColors.surface,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < shortcuts.length; i++) ...[
                ListTile(
                  leading: Icon(shortcuts[i].$1, color: SavannahColors.gold),
                  title: Text(
                    shortcuts[i].$2,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => onSelect(shortcuts[i].$2),
                ),
                if (i != shortcuts.length - 1)
                  const Divider(height: 1, indent: 56),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
