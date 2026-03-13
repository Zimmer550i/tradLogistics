class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/accounts/app/login/';
  static const String verifyOtp = '/accounts/phone/verify-otp/';
  static const String getUserProfile = '/accounts/profile/';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Users
  static const String users = '/users';
  static const String updateUserProfile = '/accounts/profile/';

  // Driver
  static const String driverVehicles = '/driver/vehicles/';
  static const String driverDocuments = '/driver/documents/';
  static const String driverWithdraw = '/transaction/driver/withdraw/';
  static const String driverEarningsDashboard =
      '/transaction/driver/earnings-dashboard/';
  static const String driverWalletSummary = '/transaction/driver/wallet-summary/';
  static const String driverEarningsSummary =
      '/transaction/driver/earnings-summary/';
  static String adminWithdrawProcess(int id) =>
      '/transaction/admin/withdraw/$id/process/';

  // Deliveries
  static const String userDeliveries = '/order/deliveries/';
  static const String ongoingDeliveries = '/order/deliveries/ongoing/';
  static const String driverAvailableDeliveries =
      '/order/driver/deliveries/available/';
  static const String driverDeliveries = '/order/driver/deliveries/';
  static String driverDeliveryAccept(int id) =>
      '/order/driver/deliveries/$id/accept/';

  // Products
  static const String products = '/products/';
  static String userById(int id) => '/users/$id';

  // App Info
  static const String termsAndConditions = '/settings/terms_conditions/';
  static const String aboutUs = '/settings/about_us/';
  static const String privacyPolicy = '/settings/privacy_policies/';
}
