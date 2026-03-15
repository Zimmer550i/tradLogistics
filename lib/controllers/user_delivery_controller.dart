import 'package:get/get.dart';
import 'package:template/controllers/base_controller.dart';
import 'package:template/controllers/user_profile_controller.dart';
import 'package:template/models/delivery_model.dart';
import 'package:template/network/api_endpoints.dart';
import 'package:template/network/base_api_service.dart';

class UserDeliveryController extends BaseController {
  final _api = BaseApiService();
  final user = Get.find<UserProfileController>();

  final Rx<DeliveryModel?> currentDelivery = Rx(null);
  final RxList<DeliveryModel> ongoingDeliveries = <DeliveryModel>[].obs;
  final RxList<DeliveryModel> pastDeliveries = <DeliveryModel>[].obs;

  DeliveryModel get data => currentDelivery.value!;

  bool get isOngoing {
    final delivery = currentDelivery.value;
    if (delivery == null) {
      return false;
    }
    switch (delivery.status) {
      case Status.driverAssigned:
      case Status.pickedUp:
      case Status.inTransit:
        return true;
      case Status.pending:
      case Status.searching:
      case Status.delivered:
      case Status.cancelled:
        return false;
    }
  }

  Future<void> updateDelivery() async {
    final delivery = currentDelivery.value;
    if (delivery == null) {
      return;
    }
    await apiCall(() async {
      final endpoint = '${ApiEndpoints.userDeliveries}${delivery.id}/';
      final data = await _api.get(endpoint);
      currentDelivery.value = DeliveryModel.fromJson(data);
    });
  }

  Future<DeliveryModel?> createDelivery(Map<String, dynamic> body) async {
    return apiCall(() async {
      final data = await _api.post(ApiEndpoints.userDeliveries, body: body);
      final delivery = DeliveryModel.fromJson(data['data']);
      currentDelivery.value = delivery;
      return delivery;
    }, showOverlay: true);
  }

  Future<void> startSearching() async {
    final delivery = currentDelivery.value;
    if (delivery == null) {
      return;
    }
    return apiCall(() async {
      final endpoint =
          '${ApiEndpoints.userDeliveries.replaceAll("user/", "")}${delivery.id}/search-driver/';
      await _api.post(endpoint);
      currentDelivery.value?.status = Status.searching;
    }, showOverlay: true);
  }

  Future<void> cancelDelivery() async {
    final delivery = currentDelivery.value;
    if (delivery == null) {
      return;
    }
    return apiCall(() async {
      final endpoint = '${ApiEndpoints.userDeliveries}${delivery.id}/cancel/';
      await _api.post(endpoint);
      currentDelivery.value = null;
    }, showOverlay: true);
  }

  Future<void> fetchOngoingDeliveries() async {
    await apiCall(() async {
      final data = await _api.get('${ApiEndpoints.userDeliveries}ongoing/');
      ongoingDeliveries.assignAll(_parseDeliveryList(data));
    });
  }

  Future<void> fetchPastDeliveries() async {
    await apiCall(() async {
      final data = await _api.get('${ApiEndpoints.userDeliveries}past/');
      pastDeliveries.assignAll(_parseDeliveryList(data));
    });
  }

  List<DeliveryModel> _parseDeliveryList(dynamic data) {
    final payload = data is Map<String, dynamic> && data['data'] is List
        ? data['data']
        : data;
    if (payload is! List) {
      return const <DeliveryModel>[];
    }
    return payload
        .whereType<Map<String, dynamic>>()
        .map(DeliveryModel.fromJson)
        .toList();
  }
}
