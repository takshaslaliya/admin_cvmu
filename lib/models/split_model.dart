import 'member_model.dart';
import 'message_model.dart';

enum SplitStatus { paid, pending }

class SplitModel {
  final String id;
  final String title;
  final String category;
  final double totalAmount;
  final List<MemberModel> members;
  final DateTime date;
  final SplitStatus status;
  final String creatorId;
  final List<MessageModel> messages;

  const SplitModel({
    required this.id,
    required this.title,
    required this.category,
    required this.totalAmount,
    required this.members,
    required this.date,
    required this.status,
    required this.creatorId,
    this.messages = const [],
  });

  double get paidAmount =>
      members.where((m) => m.isPaid).fold(0, (sum, m) => sum + m.amountOwed);

  double get progressPercent =>
      totalAmount > 0 ? (paidAmount / totalAmount).clamp(0, 1) : 0;

  int get paidCount => members.where((m) => m.isPaid).length;
}
