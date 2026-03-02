import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitease_test/core/models/dummy_data.dart';
import 'package:splitease_test/core/services/admin_service.dart';
import 'package:splitease_test/core/services/auth_service.dart';
import 'package:splitease_test/core/theme/app_theme.dart';
import 'package:splitease_test/admin/widgets/admin_stat_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 2; // Default to Dashboard (center)

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.adminBgDark;

    // List of screens for the navigation (5 items now)
    final screens = [
      _AdminUsersList(),
      _AdminWhatsAppList(),
      _buildMainDashboard(context), // Center item: Dashboard
      _AdminAlertsScreen(),
      _AdminSettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: AppColors.adminBgDark),
            child: SafeArea(
              bottom: false,
              child: IndexedStack(index: _currentIndex, children: screens),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: _buildFloatingBottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomNav() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.adminSurfaceDark,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: AppColors.adminSurfaceVariantDark,
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.adminAccent.withValues(alpha: 0.1),
              offset: const Offset(0, 8),
              blurRadius: 24,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(0, Icons.people_outline_rounded),
            _buildNavItem(1, Icons.message_outlined),
            _buildNavItem(2, Icons.dashboard_outlined),
            _buildNavItem(3, Icons.notifications_none_rounded),
            _buildNavItem(4, Icons.settings_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? Color(0xFF0A1628)
        : AppColors.darkSubtext; // Dark navy for selected icon

    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: 50,
        height: 50,
        transform: isSelected
            ? Matrix4.translationValues(0.0, -8.0, 0.0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.adminPrimary : Colors.transparent,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.adminPrimary.withValues(alpha: 0.4),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            if (index == 3 && !isSelected) // Badge for alerts
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF43F5E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainDashboard(BuildContext context) {
    final totalUsers = DummyData.totalUsers.toDouble();
    final activeUsers = DummyData.activeUsersCount.toString();
    final inactiveUsers = DummyData.inactiveUsersCount.toString();

    // Red tint for balance card if there are more inactive than active users (just as an example derived from User UI)
    List<Color> cardGradient;
    if (DummyData.inactiveUsersCount > DummyData.activeUsersCount) {
      cardGradient = const [
        Color(0xFF5E3535),
        Color(0xFF4A2525),
        Color(0xFF3A1B1B),
        Color(0xFF291010),
      ];
    } else {
      cardGradient = const [
        Color(0xFF1E525E),
        Color(0xFF133F4A),
        Color(0xFF0F323A),
        Color(0xFF082229),
      ];
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top App Bar ──────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/app_logo.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Admin Panel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).toggle,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.adminSurfaceDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.adminSurfaceVariantDark,
                      ),
                    ),
                    child: Icon(
                      Icons.light_mode_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // ── Balance Card ─────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: cardGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: cardGradient.last.withValues(alpha: 0.3),
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
                      Text(
                        'Total Users',
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
                        child: CustomPaint(painter: _AdminSparklinePainter()),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: totalUsers),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          final formattedValue = value
                              .toInt()
                              .toString()
                              .replaceAllMapped(
                                RegExp(r'\B(?=(\d{3})+(?!\d))'),
                                (Match m) => ',',
                              );
                          return Text(
                            formattedValue,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      _adminStat(
                        Icons.arrow_upward_rounded,
                        'Active',
                        activeUsers,
                        Color(0xFF45F5E4),
                      ),
                      SizedBox(width: 32),
                      // Divider
                      Container(width: 1, height: 30, color: Colors.white24),
                      SizedBox(width: 32),
                      _adminStat(
                        Icons.arrow_downward_rounded,
                        'Inactive',
                        inactiveUsers,
                        Color(0xFFE56A6A),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),
          // ── Quick Actions ─────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                // Premium Banner Full Width
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.alphaBlend(
                          AppColors.adminPrimary.withValues(alpha: 0.55),
                          const Color(0xFF0D1F2D),
                        ),
                        Color.alphaBlend(
                          AppColors.adminPrimary.withValues(alpha: 0.25),
                          const Color(0xFF081520),
                        ),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.adminPrimary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.security_rounded,
                          color: AppColors.adminAccent,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Server Status',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'All Systems Live',
                              style: TextStyle(
                                color: AppColors.adminAccent,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white54,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          // ── Search Bar ────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.adminSurfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.adminSurfaceVariantDark),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: TextField(
                style: TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  icon: Icon(
                    Icons.search,
                    color: AppColors.adminPrimary,
                    size: 20,
                  ),
                  hintText: 'Search Users or Reports',
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                  isDense: true,
                ),
              ),
            ),
          ),

          SizedBox(height: 24),

          // ── Activity Header ──────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: AppColors.adminPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),
          // Stats Grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: AdminStatCard(
                    label: 'Total Users',
                    value: '${DummyData.totalUsers}',
                    icon: Icons.people_outline_rounded,
                    iconColor: AppColors.adminAccent,
                    iconBgColor: AppColors.adminAccent.withValues(alpha: 0.1),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: AdminStatCard(
                    label: 'Active Users',
                    value: '${DummyData.activeUsersCount}',
                    icon: Icons.person_add_alt_1_outlined,
                    iconColor: AppColors.paid,
                    iconBgColor: AppColors.paidBg,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: AdminStatCard(
                    label: 'Inactive Users',
                    value: '${DummyData.inactiveUsersCount}',
                    icon: Icons.person_off_outlined,
                    iconColor: AppColors.error,
                    iconBgColor: AppColors.error.withValues(alpha: 0.1),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: AdminStatCard(
                    label: 'WhatsApp Users',
                    value: '${DummyData.whatsappUsersCount}',
                    icon: Icons.message_outlined,
                    iconColor: Color(0xFF25D366),
                    iconBgColor: Color(0xFF25D366).withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 140),
        ],
      ),
    );
  }

  static Widget _adminStat(
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
            SizedBox(width: 4),
            Text(label, style: TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
        SizedBox(height: 4),
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
}

class _AdminWhatsAppList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;
    final surfaceColor = AppColors.adminSurfaceDark;
    final borderColor = AppColors.adminSurfaceVariantDark;
    final whatsappUsers = DummyData.users
        .where((u) => u.isUsingWhatsApp)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'WhatsApp Connections',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: whatsappUsers.length,
            itemBuilder: (context, index) {
              final dynamic user = whatsappUsers[index];
              final String name = user.name?.toString() ?? 'Unknown User';
              final String phone =
                  user.phoneNumber?.toString() ?? '+91 00000 00000';
              final String initials = user.avatarInitials?.toString() ?? '??';

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF25D366).withValues(alpha: 0.1),
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: Color(0xFF25D366),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            phone,
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF25D366).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'CONNECTED',
                        style: TextStyle(
                          color: Color(0xFF25D366),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AdminAlertsScreen extends StatefulWidget {
  @override
  State<_AdminAlertsScreen> createState() => _AdminAlertsScreenState();
}

class _AdminAlertsScreenState extends State<_AdminAlertsScreen> {
  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _charCount = _controller.text.length;
      });
    });
  }

  void _addTag(String tag) {
    final text = _controller.text;
    final selection = _controller.selection;
    final newText = text.replaceRange(selection.start, selection.end, tag);
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + tag.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;
    final surfaceColor = AppColors.adminSurfaceDark;
    final borderColor = AppColors.adminSurfaceVariantDark;
    final accentColor = AppColors.adminAccent;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.adminGradient),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '⚡ Notifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Compose Message',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _tagButton('{name}', () => _addTag('{name}')),
                    _tagButton('{mobile}', () => _addTag('{mobile}')),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: borderColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Stack(
                    children: [
                      TextField(
                        controller: _controller,
                        maxLines: null,
                        expands: true,
                        style: TextStyle(color: textColor, fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: 'Type your message here...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          contentPadding: EdgeInsets.all(16),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 16,
                        child: Text(
                          '$_charCount chars',
                          style: TextStyle(
                            color: Colors.grey.withValues(alpha: 0.5),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: AppColors.adminGradient),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      final selectedUser = DummyData.users[1];
                      final finalMsg = _controller.text.replaceAll(
                        '{name}',
                        selectedUser.name,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: accentColor,
                          content: Text('Message: $finalMsg'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send_rounded, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Send to User',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _tagButton(String label, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.adminAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.adminAccent.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.adminAccent,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;
    final surfaceColor = AppColors.adminSurfaceDark;
    final borderColor = AppColors.adminSurfaceVariantDark;

    // Demo API Data
    final apis = [
      {
        'name': 'User Authentication API',
        'status': 'Healthy',
        'latency': '45ms',
        'icon': Icons.lock_outline_rounded,
      },
      {
        'name': 'Supabase Database',
        'status': 'Healthy',
        'latency': '12ms',
        'icon': Icons.storage_rounded,
      },
      {
        'name': 'WhatsApp Business API',
        'status': 'Healthy',
        'latency': '124ms',
        'icon': Icons.message_rounded,
      },
      {
        'name': 'Push Notification Service',
        'status': 'Healthy',
        'latency': '68ms',
        'icon': Icons.notifications_active_outlined,
      },
      {
        'name': 'Expense Engine API',
        'status': 'Healthy',
        'latency': '22ms',
        'icon': Icons.calculate_outlined,
      },
      {
        'name': 'Media Storage (S3)',
        'status': 'Healthy',
        'latency': '34ms',
        'icon': Icons.cloud_done_outlined,
      },
      {
        'name': 'Analytics Webhook',
        'status': 'Healthy',
        'latency': '15ms',
        'icon': Icons.analytics_outlined,
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'System Settings',
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF22C55E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color(0xFF22C55E).withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF22C55E),
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'All Systems Live',
                      style: TextStyle(
                        color: Color(0xFF22C55E),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'API HEALTH MONITOR',
            style: TextStyle(
              color: textColor.withValues(alpha: 0.5),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: apis.length,
            itemBuilder: (context, index) {
              final api = apis[index];
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            (api['icon'] as IconData == Icons.message_rounded
                                    ? Color(0xFF25D366)
                                    : AppColors.adminAccent)
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        api['icon'] as IconData,
                        size: 20,
                        color: api['icon'] as IconData == Icons.message_rounded
                            ? Color(0xFF25D366)
                            : AppColors.adminAccent,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            api['name'] as String,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Latency: ${api['latency']}',
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          api['status'] as String,
                          style: TextStyle(
                            color: Color(0xFF22C55E),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Color(0xFF22C55E).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 32,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Color(0xFF22C55E),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 30),
          // Additional Settings placeholder
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
              gradient: LinearGradient(
                colors: [surfaceColor, surfaceColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.adminAccent),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'More administrative controls and configuration options will be available here soon.',
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.7),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),

          GestureDetector(
            onTap: () async {
              await AuthService.logout();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
            },
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFEF4444)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFEF4444).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _AdminSparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF45F5E4).withValues(alpha: 0.5)
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
        // connect with dots instead of lines
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
  bool shouldRepaint(_AdminSparklinePainter oldDelegate) => false;
}

class _AdminUsersList extends StatefulWidget {
  @override
  State<_AdminUsersList> createState() => _AdminUsersListState();
}

class _AdminUsersListState extends State<_AdminUsersList> {
  String _searchQuery = '';
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    final res = await AdminService.fetchUsers();
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (res.success && res.data != null) {
          _users = res.data['users'] ?? [];
        } else {
          _users = [];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;
    final subColor = Colors.white70;
    final surfaceColor = AppColors.adminSurfaceDark;
    final borderColor = AppColors.adminSurfaceVariantDark;
    final accentColor = AppColors.adminAccent;

    List<dynamic> filteredUsers = [];
    try {
      filteredUsers = _users.where((user) {
        if (user == null) return false;
        final name = (user['full_name']?.toString() ?? '').toLowerCase();
        final email = (user['email']?.toString() ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || email.contains(query);
      }).toList();
    } catch (_) {
      filteredUsers = [];
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.adminGradient),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '⚡ App Users',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'User Management',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: TextStyle(color: textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                hintStyle: TextStyle(color: subColor, fontSize: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                icon: Icon(Icons.search_rounded, color: accentColor, size: 20),
              ),
            ),
          ),
          SizedBox(height: 24),
          // User List
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(color: AppColors.adminPrimary),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                if (index >= filteredUsers.length) return SizedBox();

                final dynamic user = filteredUsers[index];
                if (user == null) return SizedBox();

                String name = 'User';
                String email = 'No Email';
                String initials = '??';
                String totalSplits = '0';
                bool isAdmin = false;

                try {
                  name = user['full_name']?.toString() ?? 'User';
                  if (name.isEmpty) {
                    name = user['username']?.toString() ?? 'User';
                  }
                  email = user['email']?.toString() ?? 'No Email';

                  final n = name.trim();
                  initials = n.isNotEmpty
                      ? n.substring(0, 1).toUpperCase()
                      : '?';

                  totalSplits =
                      '0'; // API doesn't return total splits right now
                  isAdmin = user['role']?.toString() == 'admin';
                } catch (_) {}

                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    onTap: () => _showEditUserSheet(context, user),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isAdmin
                              ? AppColors.adminGradient
                              : AppColors.adminGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      name,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      email,
                      style: TextStyle(color: subColor, fontSize: 12),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          totalSplits,
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Splits',
                          style: TextStyle(color: subColor, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  void _showEditUserSheet(BuildContext context, dynamic user) {
    final surfaceColor = AppColors.adminSurfaceDark;
    final textColor = Colors.white;
    final subColor = Colors.white70;
    final accentColor = AppColors.adminAccent;

    final nameCtrl = TextEditingController(
      text: user['full_name']?.toString() ?? '',
    );
    final emailCtrl = TextEditingController(
      text: user['email']?.toString() ?? '',
    );
    final phoneCtrl = TextEditingController(
      text: user['mobile_number']?.toString() ?? '',
    );
    final passCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: subColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final res = await AdminService.updateUserRole(
                      user['id'],
                      'admin',
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res.message),
                        backgroundColor: res.success
                            ? AppColors.adminPrimary
                            : AppColors.error,
                      ),
                    );
                    if (res.success) {
                      Navigator.pop(context);
                      _fetchUsers();
                    }
                  },
                  icon: Icon(
                    Icons.admin_panel_settings,
                    color: AppColors.adminPrimary,
                  ),
                  tooltip: 'Make Admin',
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildEditField('Full Name', nameCtrl, Icons.person_outline),
            SizedBox(height: 16),
            _buildEditField('Email Address', emailCtrl, Icons.email_outlined),
            SizedBox(height: 16),
            _buildEditField('Phone Number', phoneCtrl, Icons.phone_outlined),
            SizedBox(height: 16),
            _buildEditField(
              'New Password',
              passCtrl,
              Icons.lock_outline_rounded,
              isPassword: true,
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.adminGradient),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await AdminService.updateUser(user['id'], {
                          'full_name': nameCtrl.text,
                          'email': emailCtrl.text,
                          'mobile_number': phoneCtrl.text,
                        });

                        if (passCtrl.text.isNotEmpty) {
                          await AdminService.resetUserPassword(
                            user['id'],
                            passCtrl.text,
                          );
                        }

                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(res.message),
                            backgroundColor: res.success
                                ? accentColor
                                : AppColors.error,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        if (res.success) _fetchUsers();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.5),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete User?'),
                          content: const Text(
                            'Are you sure you want to delete this user?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.error,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        final res = await AdminService.deleteUser(user['id']);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(res.message),
                            backgroundColor: res.success
                                ? AppColors.adminPrimary
                                : AppColors.error,
                          ),
                        );
                        if (res.success) _fetchUsers();
                      }
                    },
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isPassword = false,
  }) {
    final subColor = Colors.white70;
    final textColor = Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: subColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: subColor.withValues(alpha: 0.1)),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: textColor, fontSize: 14),
            obscureText: isPassword,
            decoration: InputDecoration(
              icon: Icon(icon, size: 18, color: subColor),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
