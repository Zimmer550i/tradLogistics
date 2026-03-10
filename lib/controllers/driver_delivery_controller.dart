import 'package:get/get.dart';
import 'package:template/controllers/base_controller.dart';
import 'package:template/controllers/user_profile_controller.dart';
import 'package:template/network/api_endpoints.dart';
import 'package:template/network/base_api_service.dart';

class DriverDeliveryController extends BaseController {
  final _api = BaseApiService();
  final user = Get.find<UserProfileController>();

  RxBool isOnline = RxBool(false);

  Future<void> toggleAvailability() async {
    await apiCall(() async {
      final data = await _api.multipart(
        'PATCH',
        ApiEndpoints.updateUserProfile,
        fields: {'is_online': "${!isOnline.value}"},
      );

      user.data.isOnline = data['data']['is_online'];
      isOnline.value = data['data']['is_online'];
    }, showOverlay: true);
  }
}
