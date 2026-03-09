import 'package:get/get.dart';
import 'package:template/controllers/base_controller.dart';
import 'package:template/models/wallet_model.dart';
import 'package:template/network/api_endpoints.dart';
import 'package:template/network/base_api_service.dart';
import 'package:template/utils/app_constants.dart';

class WalletController extends BaseController {
  final _api = BaseApiService();
  final Rx<EarningsDashboardModel?> earningsDashboard = Rx(null);
  final Rx<WalletSummaryModel?> walletSummary = Rx(null);
  final Rx<EarningsSummaryModel?> earningsSummary = Rx(null);

  Future<void> requestWithdraw({
    required num amount,
    required String accountName,
    required String accountNumber,
    required String bankName,
    required String branch,
    required String accountType,
    required String swiftCode,
  }) async {
    await apiCall(() async {
      final data = await _api.post(
        ApiEndpoints.driverWithdraw,
        body: {
          'amount': amount,
          'account_name': accountName,
          'account_number': accountNumber,
          'bank_name': bankName,
          'branch': branch,
          'account_type': accountType,
          'swift_code': swiftCode,
        },
      );
      if (data['status'] == 'success') {
        await Future.wait([
          getWalletSummary(),
          getEarningsSummary(),
          getEarningsDashboard(),
        ]);
      }
    }, showOverlay: true);
  }

  Future<void> getEarningsDashboard({
    int page = 1,
    int pageSize = AppConstants.paginationLimit,
  }) async {
    await apiCall(() async {
      final data = await _api.get(
        ApiEndpoints.driverEarningsDashboard,
        queryParams: {
          'page': page,
          'page_size': pageSize,
        },
      );
      if (data['status'] == 'success' && data['data'] is Map<String, dynamic>) {
        final nextPageData = EarningsDashboardModel.fromJson(data['data']);
        if (page <= 1 || earningsDashboard.value == null) {
          earningsDashboard.value = nextPageData;
          return;
        }

        final current = earningsDashboard.value!;
        earningsDashboard.value = EarningsDashboardModel(
          summary: nextPageData.summary,
          deliveryHistory: [
            ...current.deliveryHistory,
            ...nextPageData.deliveryHistory,
          ],
          withdrawHistory: [
            ...current.withdrawHistory,
            ...nextPageData.withdrawHistory,
          ],
          paging: nextPageData.paging,
          filters: nextPageData.filters,
        );
      }
    });
  }

  Future<void> processWithdraw({
    required int withdrawId,
    required String action,
  }) async {
    await apiCall(() async {
      await _api.post(
        ApiEndpoints.adminWithdrawProcess(withdrawId),
        body: {'action': action},
      );
    }, showOverlay: true);
  }

  Future<void> getWalletSummary() async {
    await apiCall(() async {
      final data = await _api.get(ApiEndpoints.driverWalletSummary);
      if (data['status'] == 'success' && data['data'] is Map<String, dynamic>) {
        walletSummary.value = WalletSummaryModel.fromJson(data['data']);
      }
    });
  }

  Future<void> getEarningsSummary() async {
    await apiCall(() async {
      final data = await _api.get(ApiEndpoints.driverEarningsSummary);
      if (data['status'] == 'success' && data['data'] is Map<String, dynamic>) {
        earningsSummary.value = EarningsSummaryModel.fromJson(data['data']);
      }
    });
  }
}
