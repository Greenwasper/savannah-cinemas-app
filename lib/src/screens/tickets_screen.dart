import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme.dart';
import '../widgets/frosted_bottom_navigation.dart';
import '../widgets/savannah_menu_drawer.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _segment = 0;

  void _showMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature will be added in the next build.')),
    );
  }

  void _selectBottomDestination(int index) {
    openPrimaryDestination(context, currentIndex: 3, destinationIndex: index);
  }

  void _handleMenuSelection(String destination) {
    if (destination == 'My bookings') return;
    final route = routeForDrawerDestination(destination);
    if (route != null) {
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
        selectedDestination: 'My bookings',
        onSelect: _handleMenuSelection,
        onSignOut: _signOut,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildSegments()),
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: _segment == 0
                      ? _UpcomingTickets(
                          key: const ValueKey('upcoming'),
                          onViewTicket: () =>
                              _showMessage('Full-screen ticket'),
                          onAddToWallet: () => _showMessage('Apple Wallet'),
                        )
                      : const _PastTickets(key: ValueKey('past')),
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
        selectedIndex: 3,
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
              'Tickets',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          IconButton.filled(
            tooltip: 'Ticket help',
            style: IconButton.styleFrom(
              backgroundColor: SavannahColors.surface,
            ),
            onPressed: () => _showMessage('Ticket help'),
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildSegments() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: SavannahColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _SegmentButton(
              label: 'Upcoming',
              count: 1,
              selected: _segment == 0,
              onTap: () => setState(() => _segment = 0),
            ),
            _SegmentButton(
              label: 'Past',
              count: 3,
              selected: _segment == 1,
              onTap: () => setState(() => _segment = 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? SavannahColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? SavannahColors.goldInk
                      : SavannahColors.muted,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 7),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0x281B1204)
                      : SavannahColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: selected
                        ? SavannahColors.goldInk
                        : SavannahColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingTickets extends StatelessWidget {
  const _UpcomingTickets({
    super.key,
    required this.onViewTicket,
    required this.onAddToWallet,
  });
  final VoidCallback onViewTicket;
  final VoidCallback onAddToWallet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your next show',
            style: TextStyle(
              fontSize: 13,
              color: SavannahColors.gold,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          _PaperTicket(onViewTicket: onViewTicket),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onAddToWallet,
                  icon: const Icon(Icons.wallet_outlined, size: 18),
                  label: const Text('Add to Wallet'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SavannahColors.text,
                    side: const BorderSide(color: SavannahColors.line),
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: onViewTicket,
                  child: const Text('View ticket'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: SavannahColors.surface,
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0x22EDAA3B),
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: SavannahColors.gold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'We’ll remind you',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Two hours before your film starts.',
                        style: TextStyle(
                          color: SavannahColors.muted,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaperTicket extends StatelessWidget {
  const _PaperTicket({required this.onViewTicket});
  final VoidCallback onViewTicket;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TicketClipper(),
      child: Material(
        color: SavannahColors.text,
        child: InkWell(
          onTap: onViewTicket,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 17, 17, 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 76,
                      height: 108,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF0A2140),
                            Color(0xFF3C92CF),
                            Color(0xFFBFE6FF),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(9),
                      alignment: Alignment.bottomLeft,
                      child: const Text(
                        'VOLTA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          height: .9,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Volta',
                            style: TextStyle(
                              color: SavannahColors.goldInk,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -.6,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'IMAX  •  PG-13',
                            style: TextStyle(
                              color: Color(0xFF6E6A60),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFF6E6A60),
                                size: 16,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  'Savannah Accra Mall',
                                  style: TextStyle(
                                    color: Color(0xFF6E6A60),
                                    fontSize: 12.5,
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
              ),
              const CustomPaint(
                size: Size(double.infinity, 2),
                painter: _DashedLinePainter(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 15, 17, 16),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: _TicketFact(label: 'DATE', value: 'Fri 2 Oct'),
                        ),
                        Expanded(
                          child: _TicketFact(label: 'TIME', value: '9:15 PM'),
                        ),
                        Expanded(
                          child: _TicketFact(label: 'HALL', value: 'IMAX 1'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _TicketFact(
                                  label: 'SEATS',
                                  value: 'H4, H5',
                                ),
                              ),
                              Expanded(
                                child: _TicketFact(
                                  label: 'BOOKING CODE',
                                  value: 'SVN-9M2XD',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: CustomPaint(painter: _QrPainter()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketFact extends StatelessWidget {
  const _TicketFact({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7A766B),
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: .35,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: SavannahColors.goldInk,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const notch = 10.0;
    final split = size.height * .48;
    return Path()
      ..moveTo(18, 0)
      ..quadraticBezierTo(0, 0, 0, 18)
      ..lineTo(0, split - notch)
      ..arcToPoint(
        Offset(0, split + notch),
        radius: const Radius.circular(notch),
        clockwise: true,
      )
      ..lineTo(0, size.height - 18)
      ..quadraticBezierTo(0, size.height, 18, size.height)
      ..lineTo(size.width - 18, size.height)
      ..quadraticBezierTo(size.width, size.height, size.width, size.height - 18)
      ..lineTo(size.width, split + notch)
      ..arcToPoint(
        Offset(size.width, split - notch),
        radius: const Radius.circular(notch),
        clockwise: true,
      )
      ..lineTo(size.width, 18)
      ..quadraticBezierTo(size.width, 0, size.width - 18, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCDC4B1)
      ..strokeWidth = 1.4;
    for (double x = 15; x < size.width - 15; x += 9) {
      canvas.drawLine(
        Offset(x, 1),
        Offset(math.min(x + 5, size.width - 15), 1),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QrPainter extends CustomPainter {
  const _QrPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 13;
    final paint = Paint()..color = SavannahColors.goldInk;
    const pattern = [
      0,
      1,
      2,
      4,
      6,
      8,
      10,
      11,
      12,
      14,
      17,
      19,
      21,
      24,
      27,
      29,
      31,
      33,
      35,
      38,
      40,
      42,
      46,
      49,
      52,
      54,
      56,
      59,
      61,
      63,
      67,
      69,
      72,
      74,
      78,
      81,
      83,
      86,
      88,
      91,
      94,
      96,
      99,
      101,
      104,
      107,
      109,
      112,
      115,
      117,
      120,
      124,
      127,
      130,
      132,
      135,
      139,
      142,
      145,
      148,
      151,
      154,
      157,
      160,
      164,
      166,
      168,
    ];
    for (final index in pattern) {
      final x = index % 13;
      final y = index ~/ 13;
      canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PastTickets extends StatelessWidget {
  const _PastTickets({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your ticket stubs',
            style: TextStyle(
              fontSize: 13,
              color: SavannahColors.gold,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10),
          _PastTicketCard(
            title: 'Kente Kings',
            date: 'Fri 21 Aug, 8:00 PM',
            cinema: 'Savannah West Hills',
            seats: 'D6',
            reference: 'SVN-3T8LB',
            color: Color(0xFFD9A21E),
          ),
          SizedBox(height: 11),
          _PastTicketCard(
            title: 'Accra Midnight',
            date: 'Sat 25 Jul, 9:00 PM',
            cinema: 'Savannah West Hills',
            seats: 'E5, E6',
            reference: 'SVN-2H6PA',
            color: Color(0xFFC9462F),
          ),
          SizedBox(height: 11),
          _PastTicketCard(
            title: 'The Last Drummer',
            date: 'Sat 13 Jun, 3:30 PM',
            cinema: 'Savannah Achimota',
            seats: 'C3, C4',
            reference: 'SVN-5N8QZ',
            color: Color(0xFF2F9E78),
          ),
        ],
      ),
    );
  }
}

class _PastTicketCard extends StatelessWidget {
  const _PastTicketCard({
    required this.title,
    required this.date,
    required this.cinema,
    required this.seats,
    required this.reference,
    required this.color,
  });
  final String title;
  final String date;
  final String cinema;
  final String seats;
  final String reference;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SavannahColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x66353549)),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 88,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(7),
            child: Text(
              title.toUpperCase(),
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                height: .95,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: const TextStyle(
                    color: SavannahColors.muted,
                    fontSize: 12,
                  ),
                ),
                Text(
                  cinema,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SavannahColors.muted,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Seats $seats',
                  style: const TextStyle(
                    color: SavannahColors.muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  reference,
                  style: const TextStyle(
                    color: SavannahColors.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .4,
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
