import 'package:get/get.dart';
import 'package:template/controllers/base_controller.dart';
import 'package:template/models/user_profile_model.dart';
import 'package:template/network/api_endpoints.dart';
import 'package:template/network/base_api_service.dart';

class UserProfileController extends BaseController {
  final _api = BaseApiService();

  final Rx<UserProfileModel?> userProfile = Rx(null);

  @override
  void onInit() {
    super.onInit();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    await apiCall(() async {
      final data = await _api.get(ApiEndpoints.getUserProfile);
      userProfile.value = UserProfileModel.fromJson(data['data']);
    });
  }
}
