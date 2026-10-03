import 'package:flutter/material.dart';

import '../theme.dart';
import 'brand_mark.dart';

class SavannahMenuDrawer extends StatelessWidget {
  const SavannahMenuDrawer({
    super.key,
    required this.onSelect,
    required this.onSignOut,
    this.selectedDestination = 'Now showing',
  });

  final ValueChanged<String> onSelect;
  final VoidCallback onSignOut;
  final String selectedDestination;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * .86,
      backgroundColor: SavannahColors.background,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 12, 13),
              child: Row(
                children: [
                  const BrandMark(compact: true),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Close menu',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: SavannahColors.line),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 18),
                children: [
                  const _MemberCard(),
                  const SizedBox(height: 15),
                  _MenuTile(
                    icon: Icons.local_movies_rounded,
                    label: 'Now showing',
                    selected: selectedDestination == 'Now showing',
                    onTap: () => _choose(context, 'Now showing'),
                  ),
                  _MenuTile(
                    icon: Icons.calendar_month_outlined,
                    label: 'Coming soon',
                    selected: selectedDestination == 'Coming soon',
                    onTap: () => _choose(context, 'Coming soon'),
                  ),
                  _MenuTile(
                    icon: Icons.location_on_outlined,
                    label: 'Cinemas',
                    selected: selectedDestination == 'Cinemas',
                    onTap: () => _choose(context, 'Cinemas'),
                  ),
                  _MenuTile(
                    icon: Icons.star_border_rounded,
                    label: 'Events',
                    selected: selectedDestination == 'Events',
                    onTap: () => _choose(context, 'Events'),
                  ),
                  _MenuTile(
                    icon: Icons.local_offer_outlined,
                    label: 'Offers',
                    selected: selectedDestination == 'Offers',
                    onTap: () => _choose(context, 'Offers'),
                  ),
                  _MenuTile(
                    icon: Icons.info_outline_rounded,
                    label: 'About',
                    selected: selectedDestination == 'About',
                    onTap: () => _choose(context, 'About'),
                  ),
                  const _SectionLabel('Your account'),
                  _MenuTile(
                    icon: Icons.confirmation_num_outlined,
                    label: 'My bookings',
                    selected: selectedDestination == 'My bookings',
                    onTap: () => _choose(context, 'My bookings'),
                  ),
                  _MenuTile(
                    icon: Icons.history_rounded,
                    label: 'Watch history',
                    selected: selectedDestination == 'Watch history',
                    onTap: () => _choose(context, 'Watch history'),
                  ),
                  _MenuTile(
                    icon: Icons.emoji_events_outlined,
                    label: 'My trophies',
                    selected: selectedDestination == 'My trophies',
                    onTap: () => _choose(context, 'My trophies'),
                  ),
                  _MenuTile(
                    icon: Icons.bookmark_border_rounded,
                    label: 'Watchlist',
                    selected: selectedDestination == 'Watchlist',
                    onTap: () => _choose(context, 'Watchlist'),
                  ),
                  _MenuTile(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    selected: selectedDestination == 'Settings',
                    onTap: () => _choose(context, 'Settings'),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: SavannahColors.line),
                  _MenuTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Help and support',
                    onTap: () => _choose(context, 'Help and support'),
                  ),
                  _MenuTile(
                    icon: Icons.logout_rounded,
                    label: 'Sign out',
                    danger: true,
                    onTap: () {
                      Navigator.of(context).pop();
                      onSignOut();
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Text(
                '© 2026 Savannah Cinemas',
                style: TextStyle(color: SavannahColors.muted, fontSize: 11.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _choose(BuildContext context, String destination) {
    Navigator.of(context).pop();
    onSelect(destination);
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SavannahColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SavannahColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF4C25E), Color(0xFFD2512F)],
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.person_rounded,
              color: SavannahColors.goldInk,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cinema lover',
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 3),
                Text(
                  'Bronze member  •  0 points',
                  style: TextStyle(
                    color: SavannahColors.gold,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: SavannahColors.muted),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 22, 12, 7),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: SavannahColors.muted,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.35,
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger
        ? const Color(0xFFF09479)
        : selected
        ? SavannahColors.gold
        : SavannahColors.text;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        minTileHeight: 47,
        leading: Icon(
          icon,
          color: selected ? SavannahColors.gold : color,
          size: 21,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14.5,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        trailing: selected
            ? const SizedBox(
                width: 7,
                height: 7,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: SavannahColors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
        selected: selected,
        selectedTileColor: const Color(0x1FEDAA3B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }
}
