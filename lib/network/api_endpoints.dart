class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/accounts/app/login/';
  static const String verifyOtp = '/accounts/phone/verify-otp/';
  static const String updateUserProfile = '/accounts/profile/';
  static const String getUserProfile = '/accounts/profile/';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Users
  static const String users = '/users';

  // Driver
  static const String driverVehicles = '/driver/vehicles/';
  static const String driverDocuments = '/driver/documents/';

  // Products
  static const String products = '/products/';
  static String userById(int id) => '/users/$id';
}
