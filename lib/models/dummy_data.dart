import 'member_model.dart';
import 'split_model.dart';
import 'user_model.dart';
import 'message_model.dart';

class DummyData {
  // ─── Users ───────────────────────────────────────────────────────────────
  static final List<UserModel> users = [
    UserModel(
      id: 'u0',
      name: 'Admin',
      email: 'admin@splitease.app',
      role: UserRole.admin,
      avatarInitials: 'AD',
      joinDate: DateTime(2024, 1, 1),
      totalSplits: 42,
    ),
    UserModel(
      id: 'u1',
      name: 'Dharmik Patel',
      email: 'dharmik@example.com',
      role: UserRole.user,
      avatarInitials: 'DP',
      joinDate: DateTime(2024, 3, 15),
      totalSplits: 12,
    ),
    UserModel(
      id: 'u2',
      name: 'Riya Shah',
      email: 'riya@example.com',
      role: UserRole.user,
      avatarInitials: 'RS',
      joinDate: DateTime(2024, 4, 20),
      totalSplits: 8,
    ),
    UserModel(
      id: 'u3',
      name: 'Arjun Mehta',
      email: 'arjun@example.com',
      role: UserRole.user,
      avatarInitials: 'AM',
      joinDate: DateTime(2024, 5, 10),
      totalSplits: 15,
    ),
    UserModel(
      id: 'u4',
      name: 'Priya Nair',
      email: 'priya@example.com',
      role: UserRole.user,
      avatarInitials: 'PN',
      joinDate: DateTime(2024, 6, 5),
      totalSplits: 6,
    ),
  ];

  // Dummy current logged-in user (regular)
  static UserModel get currentUser => users[1];

  // ─── Splits ──────────────────────────────────────────────────────────────
  static final List<SplitModel> splits = [
    SplitModel(
      id: 's1',
      title: 'Goa Trip 🏖️',
      category: 'Travel',
      totalAmount: 12500,
      creatorId: 'u1',
      date: DateTime(2026, 2, 20),
      status: SplitStatus.pending,
      members: [
        const MemberModel(
          id: 'm1',
          name: 'Dharmik Patel',
          avatarInitials: 'DP',
          amountOwed: 3125,
          isPaid: true,
        ),
        const MemberModel(
          id: 'm2',
          name: 'Riya Shah',
          avatarInitials: 'RS',
          amountOwed: 3125,
          isPaid: false,
        ),
        const MemberModel(
          id: 'm3',
          name: 'Arjun Mehta',
          avatarInitials: 'AM',
          amountOwed: 3125,
          isPaid: false,
        ),
        const MemberModel(
          id: 'm4',
          name: 'Priya Nair',
          avatarInitials: 'PN',
          amountOwed: 3125,
          isPaid: true,
        ),
      ],
      messages: [
        MessageModel(
          id: 'msg1',
          text: 'Super excited for the trip guyss!',
          senderId: 'u1',
          senderName: 'Dharmik Patel',
          timestamp: DateTime(2026, 2, 21, 10, 30),
        ),
        MessageModel(
          id: 'msg2',
          text: 'Payment has been settled by Dharmik Patel',
          senderId: 'system',
          senderName: 'System',
          timestamp: DateTime(2026, 2, 21, 10, 31),
          isSystemMessage: true,
        ),
        MessageModel(
          id: 'msg3',
          text: 'Yess! Please clear the leftovers soon',
          senderId: 'u4',
          senderName: 'Priya Nair',
          timestamp: DateTime(2026, 2, 21, 11, 45),
        ),
      ],
    ),
    SplitModel(
      id: 's2',
      title: 'Dinner at Spice Garden 🍽️',
      category: 'Food',
      totalAmount: 2400,
      creatorId: 'u1',
      date: DateTime(2026, 2, 22),
      status: SplitStatus.paid,
      members: [
        const MemberModel(
          id: 'm5',
          name: 'Dharmik Patel',
          avatarInitials: 'DP',
          amountOwed: 800,
          isPaid: true,
        ),
        const MemberModel(
          id: 'm6',
          name: 'Riya Shah',
          avatarInitials: 'RS',
          amountOwed: 800,
          isPaid: true,
        ),
        const MemberModel(
          id: 'm7',
          name: 'Arjun Mehta',
          avatarInitials: 'AM',
          amountOwed: 800,
          isPaid: true,
        ),
      ],
    ),
    SplitModel(
      id: 's3',
      title: 'Monthly Rent 🏠',
      category: 'Bills',
      totalAmount: 18000,
      creatorId: 'u2',
      date: DateTime(2026, 2, 1),
      status: SplitStatus.pending,
      members: [
        const MemberModel(
          id: 'm8',
          name: 'Dharmik Patel',
          avatarInitials: 'DP',
          amountOwed: 6000,
          isPaid: false,
        ),
        const MemberModel(
          id: 'm9',
          name: 'Riya Shah',
          avatarInitials: 'RS',
          amountOwed: 6000,
          isPaid: true,
        ),
        const MemberModel(
          id: 'm10',
          name: 'Priya Nair',
          avatarInitials: 'PN',
          amountOwed: 6000,
          isPaid: false,
        ),
      ],
    ),
    SplitModel(
      id: 's4',
      title: 'Netflix Subscription 📺',
      category: 'Entertainment',
      totalAmount: 649,
      creatorId: 'u3',
      date: DateTime(2026, 2, 15),
      status: SplitStatus.paid,
      members: [
        const MemberModel(
          id: 'm11',
          name: 'Dharmik Patel',
          avatarInitials: 'DP',
          amountOwed: 217,
          isPaid: true,
        ),
        const MemberModel(
          id: 'm12',
          name: 'Arjun Mehta',
          avatarInitials: 'AM',
          amountOwed: 217,
          isPaid: true,
        ),
        const MemberModel(
          id: 'm13',
          name: 'Priya Nair',
          avatarInitials: 'PN',
          amountOwed: 215,
          isPaid: true,
        ),
      ],
    ),
    SplitModel(
      id: 's5',
      title: 'Weekend Groceries 🛒',
      category: 'Food',
      totalAmount: 1800,
      creatorId: 'u1',
      date: DateTime(2026, 2, 25),
      status: SplitStatus.pending,
      members: [
        const MemberModel(
          id: 'm14',
          name: 'Dharmik Patel',
          avatarInitials: 'DP',
          amountOwed: 600,
          isPaid: true,
        ),
        const MemberModel(
          id: 'm15',
          name: 'Riya Shah',
          avatarInitials: 'RS',
          amountOwed: 600,
          isPaid: false,
        ),
        const MemberModel(
          id: 'm16',
          name: 'Arjun Mehta',
          avatarInitials: 'AM',
          amountOwed: 600,
          isPaid: false,
        ),
      ],
    ),
  ];

  // ─── Participant suggestions ──────────────────────────────────────────────
  static const List<String> participantSuggestions = [
    'Riya Shah',
    'Arjun Mehta',
    'Priya Nair',
    'Karan Desai',
    'Sneha Joshi',
    'Vivek Rao',
    'Meera Pillai',
  ];

  // ─── Finance summary ──────────────────────────────────────────────────────
  static double get totalBalance => 24350;
  static double get youOwe => 12000;
  static double get youGet => 6250;

  // ─── Admin stats ─────────────────────────────────────────────────────────
  static int get totalUsers => users.length;
  static int get activeSplits =>
      splits.where((s) => s.status == SplitStatus.pending).length;
  static double get totalSettled => 21849;
  static double get totalPending => 30500;

  // ─── Monthly bar chart data (for admin analytics) ────────────────────────
  static const List<Map<String, dynamic>> monthlyData = [
    {'month': 'Sep', 'amount': 15200.0},
    {'month': 'Oct', 'amount': 22800.0},
    {'month': 'Nov', 'amount': 18400.0},
    {'month': 'Dec', 'amount': 35600.0},
    {'month': 'Jan', 'amount': 28900.0},
    {'month': 'Feb', 'amount': 41200.0},
  ];

  // ─── Admin activity feed ──────────────────────────────────────────────────
  static const List<Map<String, String>> recentActivity = [
    {
      'user': 'Dharmik Patel',
      'action': 'Created split "Goa Trip"',
      'time': '2h ago',
      'icon': '✈️',
    },
    {
      'user': 'Riya Shah',
      'action': 'Marked ₹3,125 as paid',
      'time': '4h ago',
      'icon': '✅',
    },
    {
      'user': 'Arjun Mehta',
      'action': 'Joined "Netflix Subscription"',
      'time': '6h ago',
      'icon': '📺',
    },
    {
      'user': 'Priya Nair',
      'action': 'Created split "Weekend Groceries"',
      'time': '1d ago',
      'icon': '🛒',
    },
    {
      'user': 'Karan Desai',
      'action': 'Signed up',
      'time': '2d ago',
      'icon': '👋',
    },
  ];

  // ─── Admin login check ────────────────────────────────────────────────────
  static bool isAdminEmail(String email) =>
      email.trim().toLowerCase() == 'admin@splitease.app';
}
