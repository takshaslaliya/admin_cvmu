import 'package:flutter/material.dart';
import 'package:splitease_test/core/theme/app_theme.dart';
import 'package:splitease_test/core/services/admin_service.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  String _search = '';
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
      if (res.success && res.data != null) {
        setState(() {
          _users = res.data['users'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _users = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleDelete(dynamic user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User?'),
        content: const Text(
          'Are you sure you want to delete this user? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final res = await AdminService.deleteUser(user['id']);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.message),
          backgroundColor: res.success
              ? AppColors.adminPrimary
              : AppColors.error,
        ),
      );
      if (res.success) {
        Navigator.pop(context); // Close details modal
        _fetchUsers();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkSubtext : AppColors.lightSubtext;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;

    final filtered = _users.where((user) {
      if (user == null) return false;
      final name = (user['full_name']?.toString() ?? '').toLowerCase();
      final email = (user['email_or_mobile']?.toString() ?? '').toLowerCase();
      return name.contains(_search.toLowerCase()) ||
          email.contains(_search.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back_rounded, color: textColor, size: 20),
          ),
        ),
        title: Text(
          'All Users',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: TextStyle(color: subColor),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: subColor,
                ),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          size: 18,
                          color: subColor,
                        ),
                        onPressed: () => setState(() => _search = ''),
                      )
                    : null,
                filled: true,
                fillColor: surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.adminPrimary),
            )
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 80),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                final user = filtered[index];

                final name = user['full_name']?.toString() ?? 'User';
                final email = user['email_or_mobile']?.toString() ?? 'No Email';
                final n = name.trim();
                final initials = n.isNotEmpty
                    ? n.substring(0, 1).toUpperCase()
                    : '?';
                final isAdmin = user['role']?.toString() == 'admin';
                final splits = user['total_splits']?.toString() ?? '0';

                return GestureDetector(
                  onTap: () => _showUserDetails(
                    context,
                    user,
                    isDark,
                    textColor,
                    subColor,
                    surfaceColor,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadius,
                      ),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.lightSurfaceVariant,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isAdmin
                                  ? AppColors.adminGradient
                                  : AppColors.primaryGradient,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  _RoleBadge(isAdmin: isAdmin),
                                ],
                              ),
                              SizedBox(height: 2),
                              Text(
                                email,
                                style: TextStyle(color: subColor, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              splits,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'splits',
                              style: TextStyle(color: subColor, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showUserDetails(
    BuildContext context,
    dynamic baseUser,
    bool isDark,
    Color textColor,
    Color subColor,
    Color surfaceColor,
  ) async {
    // Show modal immediately with loading or partial data, then fetch full data
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _UserDetailsModal(
        userId: baseUser['id'],
        baseUser: baseUser,
        isDark: isDark,
        textColor: textColor,
        subColor: subColor,
        surfaceColor: surfaceColor,
        onRefresh: _fetchUsers,
        onDelete: () => _handleDelete(baseUser),
      ),
    );
  }
}

class _UserDetailsModal extends StatefulWidget {
  final String userId;
  final dynamic baseUser;
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final Color surfaceColor;
  final VoidCallback onRefresh;
  final VoidCallback onDelete;

  const _UserDetailsModal({
    required this.userId,
    required this.baseUser,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.surfaceColor,
    required this.onRefresh,
    required this.onDelete,
  });

  @override
  State<_UserDetailsModal> createState() => _UserDetailsModalState();
}

class _UserDetailsModalState extends State<_UserDetailsModal> {
  bool _isLoading = true;
  dynamic _fullUser;

  @override
  void initState() {
    super.initState();
    _fetchFullUserDetails();
  }

  Future<void> _fetchFullUserDetails() async {
    final res = await AdminService.fetchUserById(widget.userId);
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (res.success && res.data != null) {
          _fullUser = res.data;
        } else {
          _fullUser = widget.baseUser; // Fallback to base user data
        }
      });
    }
  }

  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.surfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _EditUserSheet(
        userData: _fullUser ?? widget.baseUser,
        textColor: widget.textColor,
        subColor: widget.subColor,
        surfaceColor: widget.surfaceColor,
        onUserUpdated: (updatedUser) {
          setState(() {
            _fullUser = updatedUser;
          });
          widget.onRefresh();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.adminPrimary),
        ),
      );
    }

    final user = _fullUser ?? widget.baseUser;

    final name = user['full_name']?.toString() ?? 'User';
    final email = user['email_or_mobile']?.toString() ?? 'No Email';
    final n = name.trim();
    final initials = n.isNotEmpty ? n.substring(0, 1).toUpperCase() : '?';
    final isAdmin = user['role']?.toString() == 'admin';
    final splits = user['total_splits']?.toString() ?? '0';
    final joinDateRaw = user['created_at']?.toString() ?? '';
    final isWhatsapp = user['whatsapp_connected'] == true;

    String joinDate = 'Unknown';
    if (joinDateRaw.isNotEmpty) {
      try {
        final parsed = DateTime.parse(joinDateRaw);
        joinDate = '${parsed.day}/${parsed.month}/${parsed.year}';
      } catch (_) {}
    }

    final List<dynamic> achievements = user['achievements'] ?? [];

    return Padding(
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
                color: widget.isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isAdmin
                        ? AppColors.adminGradient
                        : AppColors.primaryGradient,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _RoleBadge(isAdmin: isAdmin),
                  ],
                ),
              ),
              IconButton(
                onPressed: widget.onDelete,
                icon: Icon(Icons.delete_outline, color: AppColors.error),
              ),
            ],
          ),
          SizedBox(height: 20),
          _DetailRow(
            label: 'Email / Mobile',
            value: email,
            textColor: widget.textColor,
            subColor: widget.subColor,
          ),
          _DetailRow(
            label: 'Total Splits',
            value: splits,
            textColor: widget.textColor,
            subColor: widget.subColor,
          ),
          _DetailRow(
            label: 'Joined',
            value: joinDate,
            textColor: widget.textColor,
            subColor: widget.subColor,
          ),
          _DetailRow(
            label: 'WhatsApp Connected',
            value: isWhatsapp ? 'Yes' : 'No',
            textColor: isWhatsapp ? Color(0xFF25D366) : widget.subColor,
            subColor: widget.subColor,
          ),

          if (achievements.isNotEmpty) ...[
            SizedBox(height: 16),
            Text(
              'Unlocked Achievements (${achievements.length})',
              style: TextStyle(
                color: widget.textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(maxHeight: 150),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: achievements.length,
                itemBuilder: (context, idx) {
                  final ach = achievements[idx];
                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? AppColors.darkSurfaceVariant
                          : AppColors.lightSurfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ach['title']?.toString() ?? 'Achievement',
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ach['description']?.toString() ?? '',
                          style: TextStyle(
                            color: widget.subColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],

          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final newRole = isAdmin ? 'user' : 'admin';
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Change Role?'),
                        content: Text(
                          'Are you sure you want to make this user an $newRole?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      final res = await AdminService.updateUserRole(
                        user['id'],
                        newRole,
                      );
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res.message),
                          backgroundColor: res.success
                              ? AppColors.adminPrimary
                              : AppColors.error,
                        ),
                      );
                      if (res.success) {
                        _fetchFullUserDetails(); // Refetch Data
                        widget.onRefresh(); // Refetch parent list
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAdmin
                        ? AppColors.darkSurfaceVariant
                        : AppColors.adminPrimary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(isAdmin ? 'Revoke Admin' : 'Make Admin'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _showEditSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Edit Profile'),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _EditUserSheet extends StatefulWidget {
  final dynamic userData;
  final Color textColor;
  final Color subColor;
  final Color surfaceColor;
  final Function(dynamic) onUserUpdated;

  const _EditUserSheet({
    required this.userData,
    required this.textColor,
    required this.subColor,
    required this.surfaceColor,
    required this.onUserUpdated,
  });

  @override
  State<_EditUserSheet> createState() => _EditUserSheetState();
}

class _EditUserSheetState extends State<_EditUserSheet> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.userData['full_name']?.toString() ?? '',
    );
    phoneController = TextEditingController(
      text:
          widget.userData['mobile_number']?.toString() ??
          widget.userData['email_or_mobile']?.toString() ??
          '',
    );
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: widget.subColor, fontSize: 12)),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(color: widget.textColor, fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.subColor.withValues(alpha: 0.2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit User Details',
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded, color: widget.subColor),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField('Full Name', nameController),
          SizedBox(height: 12),
          _buildTextField('Mobile / Email', phoneController),
          SizedBox(height: 12),
          _buildTextField(
            'New Password (Optional)',
            passwordController,
            isPassword: true,
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                bool updated = false;

                // Show loading could be added here, but awaiting handles it.
                // Update details
                final updateRes =
                    await AdminService.updateUser(widget.userData['id'], {
                      'full_name': nameController.text.trim(),
                      'mobile_number': phoneController.text.trim(),
                    });

                if (updateRes.success) updated = true;

                // Update password if provided
                if (passwordController.text.isNotEmpty) {
                  final passRes = await AdminService.resetUserPassword(
                    widget.userData['id'],
                    passwordController.text,
                  );
                  if (!passRes.success) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Details updated, but password reset failed.',
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return; // Return early if issue occurs
                  }
                  updated = true;
                }

                if (!mounted) return;

                if (updated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('User updated successfully!'),
                      backgroundColor: AppColors.adminPrimary,
                    ),
                  );
                  Navigator.pop(context);
                  widget.onUserUpdated(updateRes.data ?? widget.userData);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(updateRes.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final bool isAdmin;
  const _RoleBadge({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isAdmin
            ? AppColors.adminAccent.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAdmin ? 'Admin' : 'User',
        style: TextStyle(
          color: isAdmin ? AppColors.adminAccent : AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final Color subColor;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: subColor, fontSize: 13)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
