import 'package:get/get.dart';
import 'package:template/controllers/base_controller.dart';
import 'package:template/network/api_endpoints.dart';
import 'package:template/network/base_api_service.dart';
import 'package:template/storage/storage_service.dart';
import 'package:template/views/app.dart';
import 'package:template/views/screens/auth/driver_personal_information.dart';
import 'package:template/views/screens/auth/get_started.dart';
import 'package:template/views/screens/auth/user_personal_information.dart';
import 'package:template/views/screens/auth/user_welcome.dart';
import 'package:template/views/screens/auth/verification.dart';

class AuthController extends BaseController {
  final _api = BaseApiService();
  final _storage = StorageService();

  Future<void> login(String number, bool isUser) async {
    await apiCall(() async {
      final data = await _api.post(
        ApiEndpoints.login,
        body: {"phone": number, "role": isUser ? "customer" : "driver"},
      );
      if (data['status'] == 'success') {
        Get.to(() => Verification(number: number, isDriver: !isUser));
      }
    }, showOverlay: true);
  }

  verifiyation(String otp, String number) async {
    await apiCall(() async {
      final data = await _api.post(
        ApiEndpoints.verifyOtp,
        body: {"phone": number, "code": otp},
      );
      if (data['status'] == 'success') {
        _storage.saveToken(data['access_token']);
        _storage.saveRole(data['data']['role']);
        if (data['data']['role'] == 'customer') {
          if(data['data']['first_name'] !=null){
          Get.off(() => App(isUser: true));
          } else {
            Get.off(() => UserPersonalInformation());
          }
        } else {
            if(data['data']['created'] == true){
          Get.off(() => App(isUser: false));
          } else {  
          Get.off(() => DriverPersonalInformation());
          }
        }
        
      }
    }, showOverlay: true);
  }

  updateUserProfile(Map<String, dynamic> profileData) async {
    await apiCall(() async {
      final data = await _api.patch(
        ApiEndpoints.updateUserProfile,
        body: profileData,
      );
      if (data['status'] == 'success') {
       Get.off(()=>UserWelcome());
      }
    }, showOverlay: true);
  } 

  


  Future<void> logout() async {
    await _storage.removeToken();
    Get.offAll(() => const GetStarted());
  }
}
