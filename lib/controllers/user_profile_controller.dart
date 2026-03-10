import 'dart:io';
import 'package:get/get.dart';
import 'package:template/controllers/base_controller.dart';
import 'package:template/models/user_profile_model.dart';
import 'package:template/network/api_endpoints.dart';
import 'package:template/network/base_api_service.dart';

class UserProfileController extends BaseController {
  final _api = BaseApiService();

  final Rx<UserProfileModel?> userProfile = Rx(null);
  final RxMap<String, String> appInfo = RxMap();

  UserProfileModel get data => userProfile.value!;

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

  Future<void> editProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    File? profileImage,
  }) async {
    await apiCall(() async {
      final data = await _api.multipart(
        'PATCH',
        ApiEndpoints.updateUserProfile,
        fields: {
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'address_text': address,
        },
        files: {if (profileImage != null) 'profile_image': profileImage},
      );

      if (data['data'] is Map<String, dynamic>) {
        userProfile.value = UserProfileModel.fromJson(data['data']);
      } else {
        final refreshed = await _api.get(ApiEndpoints.getUserProfile);
        userProfile.value = UserProfileModel.fromJson(refreshed['data']);
      }
    }, showOverlay: true);
  }

  Future<void> fetchInfo(String endpoint) async {
    await apiCall(() async {
      final data = await _api.get(endpoint);

      appInfo[endpoint] = (data['data'] as List).first['content'];
    }, showLoading: true);
  }
}
