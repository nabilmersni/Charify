// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:charify/features/main/domain/entity/donation_entity.dart';

enum HistoryStatus {
  initial,
  loading,
  success,
  error,
}

class HistoryState {
  final HistoryStatus status;
  final List<DonationEntity>? donations;
  final String? errorMessage;
  final int page;

  HistoryState._({
    required this.status,
    this.donations,
    this.errorMessage,
    this.page = 1,
  });

  factory HistoryState.initial() =>
      HistoryState._(status: HistoryStatus.initial);

  HistoryState copyWith({
    HistoryStatus? status,
    List<DonationEntity>? donations,
    String? errorMessage,
    int? page,
  }) {
    return HistoryState._(
      status: status ?? this.status,
      donations: donations ?? this.donations,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
    );
  }
}
