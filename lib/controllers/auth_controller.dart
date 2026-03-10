import 'dart:io';
import 'package:get/get.dart';
import 'package:template/controllers/base_controller.dart';
import 'package:template/controllers/user_profile_controller.dart';
import 'package:template/network/api_endpoints.dart';
import 'package:template/network/base_api_service.dart';
import 'package:template/storage/storage_service.dart';
import 'package:template/views/app.dart';
import 'package:template/views/screens/auth/driver_personal_information.dart';
import 'package:template/views/screens/auth/driver_document_review.dart';
import 'package:template/views/screens/auth/driver_document_upload.dart';
import 'package:template/views/screens/auth/driver_vehicle_information.dart';
import 'package:template/views/screens/auth/get_started.dart';
import 'package:template/views/screens/auth/user_personal_information.dart';
import 'package:template/views/screens/auth/user_welcome.dart';
import 'package:template/views/screens/auth/verification.dart';

class AuthController extends BaseController {
  final _api = BaseApiService();
  final _storage = StorageService();

  /// Splash থেকে call হবে — token দিয়ে profile check করে correct screen এ নিয়ে যাবে
  Future<void> checkAuthAndNavigate() async {
    try {
      final data = await _api.get(ApiEndpoints.getUserProfile);
      if (data == null || data['status'] != 'success') {
        _goToLogin();
        return;
      }

      final profile = data['data'];
      final role = _storage.getRole();

      if (role == 'customer') {
        if (profile['first_name'] == null) {
          Get.offAll(() => UserPersonalInformation());
        } else {
          Get.offAll(() => App(isUser: true));
        }
      } else {
        // Driver — step by step check
        if (data['data']['d_type'] == "gas") {
          Get.offAll(() => App(isUser: false));
        } else if (profile['first_name'] == null) {
          Get.offAll(() => DriverPersonalInformation());
        } else if (profile['vehicle'] == null) {
          Get.offAll(() => DriverVehicleInformation());
        } else if (profile['document'] == null) {
          Get.offAll(() => DriverDocumentUpload());
        } else if (profile['is_verified'] == false) {
          Get.offAll(() => DriverDocumentReview());
        } else {
          Get.offAll(() => App(isUser: false));
        }
      }
    } catch (_) {
      _goToLogin();
    }
  }

  void _goToLogin() {
    _storage.removeToken();
    Get.offAll(() => const GetStarted());
  }

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

  Future<void> verifiyation(String otp, String number) async {
    await apiCall(() async {
      final data = await _api.post(
        ApiEndpoints.verifyOtp,
        body: {"phone": number, "code": otp},
      );
      if (data['status'] == 'success') {
        _storage.saveToken(data['access_token']);
        _storage.saveRole(data['data']['role']);
        Get.find<UserProfileController>().getUserProfile();
        if (data['data']['role'] == 'customer') {
          if (data['data']['first_name'] != null) {
            Get.off(() => App(isUser: true));
          } else {
            Get.off(() => UserPersonalInformation());
          }
        } else {
          if (data['data']['d_type'] == "gas") {
            Get.offAll(() => App(isUser: false));
          } else if (data['data']['first_name'] == null) {
            Get.offAll(() => DriverPersonalInformation());
          } else if (data['data']['vehicle'] == null) {
            Get.offAll(() => DriverVehicleInformation());
          } else if (data['data']['document'] == null) {
            Get.offAll(() => DriverDocumentUpload());
          } else if (data['data']['is_verified'] == false) {
            Get.offAll(() => DriverDocumentReview());
          } else {
            Get.offAll(() => App(isUser: false));
          }
        }
      }
    }, showOverlay: true);
  }

  // User — JSON only (first_name, last_name)
  Future<void> updateUserProfile(Map<String, dynamic> profileData) async {
    await apiCall(() async {
      final data = await _api.patch(
        ApiEndpoints.updateUserProfile,
        body: profileData,
      );
      if (data['status'] == 'success') {
        Get.off(() => UserWelcome());
      }
    }, showOverlay: true);
  }

  // Driver — multipart (fields + optional files)
  Future<void> updateDriverProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String address,
    required String lat,
    required String long,
    File? proofOfAddress,
    File? policeRecord,
    File? profilePicture,
  }) async {
    await apiCall(() async {
      final data = await _api.multipart(
        'PATCH',
        ApiEndpoints.updateUserProfile,
        fields: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'address_text': address,
          'location_lat': lat,
          'location_long': long,
        },
        files: {
          if (proofOfAddress != null) 'proof_of_address': proofOfAddress,
          if (policeRecord != null) 'police_record': policeRecord,
          if (profilePicture != null) 'profile_image': profilePicture,
        },
      );
      if (data['status'] == 'success') {
        Get.off(() => DriverVehicleInformation());
      }
    }, showOverlay: true);
  }

  // Driver — upload documents (multipart, files only)
  Future<void> uploadDocuments({
    required File drivingLicenseFront,
    required File drivingLicenseBack,
    required File vehicleRegistration,
    File? nationalIdFront,
    File? nationalIdBack,
  }) async {
    await apiCall(() async {
      final data = await _api.multipart(
        'POST',
        ApiEndpoints.driverDocuments,
        files: {
          'driving_license_front': drivingLicenseFront,
          'driving_license_back': drivingLicenseBack,
          'vehicle_registration': vehicleRegistration,
          if (nationalIdFront != null) 'national_id_front': nationalIdFront,
          if (nationalIdBack != null) 'national_id_back': nationalIdBack,
        },
      );
      if (data['status'] == 'success') {
        Get.off(() => DriverDocumentReview());
      }
    }, showOverlay: true);
  }

  // Driver — add vehicle (multipart)
  Future<void> addVehicle({
    required String vehicleType,
    required String brand,
    required String model,
    required String color,
    required String registrationNumber,
    File? image,
  }) async {
    await apiCall(() async {
      final data = await _api.multipart(
        'POST',
        ApiEndpoints.driverVehicles,
        fields: {
          'vehicle_type': vehicleType,
          'brand': brand,
          'model': model,
          'color': color,
          'registration_number': registrationNumber,
        },
        files: {if (image != null) 'image': image},
      );
      if (data['status'] == 'success') {
        Get.off(() => DriverDocumentUpload());
      }
    }, showOverlay: true);
  }

  Future<void> logout() async {
    await _storage.removeToken();
    Get.offAll(() => const GetStarted());
  }
}
