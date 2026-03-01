import 'package:flutter/material.dart';
import 'package:splitease_test/core/theme/app_theme.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    AppColors.bgGradientDarkTop,
                    AppColors.bgGradientDarkTop,
                    AppColors.bgGradientDarkBottom,
                    AppColors.darkBg,
                  ]
                : [
                    const Color(0xFF45F5E4), // Bright aqua top
                    const Color(0xFF9FFDF2), // Mid light aqua
                    const Color(0xFFE5FFFC), // Very light
                    const Color(0xFFFFFFFF), // White at the bottom
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top App Bar ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.currency_rupee_rounded,
                              color: isDark
                                  ? AppColors.primary
                                  : const Color(0xFF0D2A3E),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'SplitEase',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkText
                                  : const Color(0xFF0D2A3E),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _topIconBtn(Icons.person_outline_rounded, isDark),
                          const SizedBox(width: 10),
                          _topIconBtn(Icons.menu_rounded, isDark),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Balance Card ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1E525E), // Teal-grey
                          Color(0xFF133F4A), // Darker teal
                          Color(0xFF0F323A), // Even darker
                          Color(0xFF082229), // Deep dark teal/navy
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 0.3, 0.7, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0B2F36).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Balance',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Mini sparkline decoration
                            SizedBox(
                              width: 80,
                              height: 30,
                              child: CustomPaint(painter: _SparklinePainter()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              '₹',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              '24,450',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            _balanceStat(
                              Icons.arrow_upward_rounded,
                              'You Owe',
                              '₹12,000',
                              const Color(0xFFE56A6A),
                            ),
                            const SizedBox(width: 32),
                            // Divider
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white24,
                            ),
                            const SizedBox(width: 32),
                            _balanceStat(
                              Icons.arrow_downward_rounded,
                              'You Get',
                              '₹6,350',
                              const Color(0xFF45F5E4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24), // Added spacer to prevent collision
                // ── Quick Actions ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Premium Banner Full Width
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF144D59), Color(0xFF0D2A3E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF144D59,
                              ).withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.workspace_premium_rounded,
                                color: Color(0xFF45F5E4),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Prestige Plan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Active Premium Member',
                                    style: TextStyle(
                                      color: Color(0xFF45F5E4),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white54,
                              size: 24,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Small History & Friends Options
                      Row(
                        children: [
                          _smallAction(
                            Icons.history_rounded,
                            'History',
                            isDark,
                          ),
                          const SizedBox(width: 16),
                          _smallAction(Icons.group_rounded, 'Friends', isDark),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── Search Bar ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.lightSurfaceVariant,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        icon: const Icon(
                          Icons.search,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        hintText: 'Search Groups or Persons',
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppColors.darkSubtext
                              : const Color(0xFF8EB8C8),
                          fontSize: 14,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Active Splits Header ──────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkText
                              : const Color(0xFF1D3A44),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFF1CB0A0),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Active Splits List ────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildSplitTile(
                        icon: Icons.add,
                        title: 'Goa Trip',
                        subtitle: '2/4 Paid',
                        amount: '₹12.5K',
                        iconColor: const Color(0xFF144D59),
                        iconBg: const Color(0xFFD4EBEB),
                        isDark: isDark,
                      ),
                      _buildSplitTile(
                        icon: Icons.restaurant_rounded,
                        title: 'Dinner',
                        subtitle: '• Paid',
                        amount: '₹2.4K',
                        iconColor: const Color(0xFF1CB0A0),
                        iconBg: const Color(0xFFE5FFFC),
                        isSubtitleColored: true,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120), // Space for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _topIconBtn(IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isDark ? AppColors.darkText : const Color(0xFF0D2A3E),
        size: 18,
      ),
    );
  }

  static Widget _balanceStat(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  static Widget _smallAction(IconData icon, String label, bool isDark) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkSurfaceVariant : Colors.transparent,
            width: isDark ? 1 : 0,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isDark ? AppColors.primary : const Color(0xFF144D59),
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? AppColors.darkText : const Color(0xFF144D59),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildSplitTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required Color iconColor,
    required Color iconBg,
    bool isSubtitleColored = false,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkSurfaceVariant : Colors.transparent,
          width: isDark ? 1 : 0,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : iconBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.primary : iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkText
                        : const Color(0xFF1D3A44),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isSubtitleColored
                        ? (isDark ? AppColors.primary : const Color(0xFF1CB0A0))
                        : (isDark
                              ? AppColors.darkSubtext
                              : const Color(0xFF5E7A81)),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: isDark ? AppColors.darkText : const Color(0xFF1D3A44),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Icon(
                Icons.more_vert_rounded,
                color: isDark ? AppColors.darkSubtext : const Color(0xFF1CB0A0),
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF45F5E4).withValues(alpha: 0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.7),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width, size.height * 0.1),
    ];

    // Draw little dotted lines
    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 1.5, paint);
      if (i < points.length - 1) {
        // connect with dots instead of lines? The image shows tiny dots.
        // We'll draw a few dots between the points
        final int dots = 3;
        for (int j = 1; j <= dots; j++) {
          final t = j / (dots + 1);
          final p = Offset(
            points[i].dx + (points[i + 1].dx - points[i].dx) * t,
            points[i].dy + (points[i + 1].dy - points[i].dy) * t,
          );
          canvas.drawCircle(p, 1, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) => false;
}
