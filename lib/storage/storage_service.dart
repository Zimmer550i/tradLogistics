import 'package:shared_preferences/shared_preferences.dart';

import 'storage_keys.dart';

class StorageService {
  static late StorageService _instance;
  static bool _initialized = false;

  late final SharedPreferences _prefs;

  StorageService._(this._prefs);

  factory StorageService() {
    assert(_initialized, 'StorageService.init() must be called first');
    return _instance;
  }

  static Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    _instance = StorageService._(prefs);
    _initialized = true;
  }

  // Token
  String? getToken() => _prefs.getString(StorageKeys.token);

  Future<void> saveToken(String value) =>
      _prefs.setString(StorageKeys.token, value);

  Future<void> removeToken() => _prefs.remove(StorageKeys.token);

  // Role
  String? getRole() => _prefs.getString(StorageKeys.role);
  Future<void> saveRole(String role) => _prefs.setString(StorageKeys.role, role);

  // Theme
  bool getThemeMode() => _prefs.getBool(StorageKeys.themeMode) ?? false;

  Future<void> saveThemeMode(bool isDark) =>
      _prefs.setBool(StorageKeys.themeMode, isDark);

  // Locale
  String? getLanguageCode() => _prefs.getString(StorageKeys.locale);

  Future<void> saveLanguageCode(String code) =>
      _prefs.setString(StorageKeys.locale, code);

  // Driver withdraw bank info
  String? getWithdrawBankName() => _prefs.getString(StorageKeys.withdrawBankName);
  Future<void> saveWithdrawBankName(String value) =>
      _prefs.setString(StorageKeys.withdrawBankName, value);

  String? getWithdrawBranch() => _prefs.getString(StorageKeys.withdrawBranch);
  Future<void> saveWithdrawBranch(String value) =>
      _prefs.setString(StorageKeys.withdrawBranch, value);

  String? getWithdrawSwiftCode() => _prefs.getString(StorageKeys.withdrawSwiftCode);
  Future<void> saveWithdrawSwiftCode(String value) =>
      _prefs.setString(StorageKeys.withdrawSwiftCode, value);

  String? getWithdrawAccountNumber() =>
      _prefs.getString(StorageKeys.withdrawAccountNumber);
  Future<void> saveWithdrawAccountNumber(String value) =>
      _prefs.setString(StorageKeys.withdrawAccountNumber, value);

  String? getWithdrawAccountType() =>
      _prefs.getString(StorageKeys.withdrawAccountType);
  Future<void> saveWithdrawAccountType(String value) =>
      _prefs.setString(StorageKeys.withdrawAccountType, value);

  // Auth
  bool get isLoggedIn {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clear() => _prefs.clear();
}
