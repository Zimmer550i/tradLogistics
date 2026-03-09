import 'package:template/models/paging_model.dart';

class EarningsDashboardModel {
  final EarningsDashboardSummaryModel summary;
  final List<dynamic> deliveryHistory;
  final List<WithdrawHistoryModel> withdrawHistory;
  final PagingModel paging;
  final FiltersModel filters;

  EarningsDashboardModel({
    required this.summary,
    required this.deliveryHistory,
    required this.withdrawHistory,
    required this.paging,
    required this.filters,
  });

  factory EarningsDashboardModel.fromJson(Map<String, dynamic> json) {
    return EarningsDashboardModel(
      summary: EarningsDashboardSummaryModel.fromJson(json['summary']),
      deliveryHistory: (json['delivery_history'] as List?)?.toList() ?? [],
      withdrawHistory: (json['withdraw_history'] as List)
          .map((item) => WithdrawHistoryModel.fromJson(item))
          .toList(),
      paging: PagingModel.fromJson(json['paging']),
      filters: FiltersModel.fromJson(json['filters']),
    );
  }

  Map<String, dynamic> toJson() => {
    'summary': summary.toJson(),
    'delivery_history': deliveryHistory,
    'withdraw_history': withdrawHistory.map((e) => e.toJson()).toList(),
    'paging': paging.toJson(),
    'filters': filters.toJson(),
  };
}

class EarningsDashboardSummaryModel {
  final num? currentBalance;
  final num? totalEarnings;
  final int? tripsCompleted;
  final num? onlineHours;
  final Map<String, dynamic> raw;

  EarningsDashboardSummaryModel({
    this.currentBalance,
    this.totalEarnings,
    this.tripsCompleted,
    this.onlineHours,
    required this.raw,
  });

  factory EarningsDashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return EarningsDashboardSummaryModel(
      currentBalance: _toNum(json['current_balance']),
      totalEarnings: _toNum(json['total_earnings']),
      tripsCompleted: _toInt(json['trips_completed']),
      onlineHours: _toNum(json['online_hours']),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => raw;
}

class WithdrawHistoryModel {
  final int withdrawId;
  final num amount;
  final String status;
  final String bankName;
  final String branch;
  final String swiftCode;
  final String accountNumber;
  final String accountName;
  final String accountType;
  final String requestedAt;
  final String? processedAt;
  final String? processedBy;

  WithdrawHistoryModel({
    required this.withdrawId,
    required this.amount,
    required this.status,
    required this.bankName,
    required this.branch,
    required this.swiftCode,
    required this.accountNumber,
    required this.accountName,
    required this.accountType,
    required this.requestedAt,
    this.processedAt,
    this.processedBy,
  });

  factory WithdrawHistoryModel.fromJson(Map<String, dynamic> json) {
    return WithdrawHistoryModel(
      withdrawId: _toInt(json['withdraw_id']) ?? 0,
      amount: _toNum(json['amount']) ?? 0.0,
      status: json['status'] ?? '',
      bankName: json['bank_name'] ?? '',
      branch: json['branch'] ?? '',
      swiftCode: json['swift_code'] ?? '',
      accountNumber: json['account_number'] ?? '',
      accountName: json['account_name'] ?? '',
      accountType: json['account_type'] ?? '',
      requestedAt: json['requested_at'] ?? '',
      processedAt: json['processed_at'],
      processedBy: json['processed_by'],
    );
  }

  Map<String, dynamic> toJson() => {
    'withdraw_id': withdrawId,
    'amount': amount,
    'status': status,
    'bank_name': bankName,
    'branch': branch,
    'swift_code': swiftCode,
    'account_number': accountNumber,
    'account_name': accountName,
    'account_type': accountType,
    'requested_at': requestedAt,
    'processed_at': processedAt,
    'processed_by': processedBy,
  };
}

class FiltersModel {
  final String? startDate;
  final String? endDate;

  FiltersModel({this.startDate, this.endDate});

  factory FiltersModel.fromJson(Map<String, dynamic> json) {
    return FiltersModel(
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }

  Map<String, dynamic> toJson() => {
    'start_date': startDate,
    'end_date': endDate,
  };
}

class WalletSummaryModel {
  final num? currentBalance;
  final num? totalEarnings;
  final num? totalWithdrawn;
  final num? pendingWithdraw;
  final num? availableToWithdraw;
  final Map<String, dynamic> raw;

  WalletSummaryModel({
    this.currentBalance,
    this.totalEarnings,
    this.totalWithdrawn,
    this.pendingWithdraw,
    this.availableToWithdraw,
    required this.raw,
  });

  factory WalletSummaryModel.fromJson(Map<String, dynamic> json) {
    return WalletSummaryModel(
      currentBalance: _toNum(json['current_balance']),
      totalEarnings: _toNum(json['total_earnings']),
      totalWithdrawn: _toNum(json['total_withdrawn']),
      pendingWithdraw: _toNum(json['pending_withdraw']),
      availableToWithdraw: _toNum(json['available_to_withdraw']),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => raw;
}

class EarningsSummaryModel {
  final num? totalEarnings;
  final num? todayEarnings;
  final num? weeklyEarnings;
  final num? monthlyEarnings;
  final List<dynamic> history;
  final Map<String, dynamic> raw;

  EarningsSummaryModel({
    this.totalEarnings,
    this.todayEarnings,
    this.weeklyEarnings,
    this.monthlyEarnings,
    required this.history,
    required this.raw,
  });

  factory EarningsSummaryModel.fromJson(Map<String, dynamic> json) {
    return EarningsSummaryModel(
      totalEarnings: _toNum(json['total_earnings'] ?? json['total']),
      todayEarnings: _toNum(json['today_earnings'] ?? json['today']),
      weeklyEarnings: _toNum(json['weekly_earnings'] ?? json['weekly']),
      monthlyEarnings: _toNum(json['monthly_earnings'] ?? json['monthly']),
      history: (json['history'] as List?)?.toList() ?? const [],
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => raw;
}

num? _toNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  return num.tryParse(value.toString());
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
