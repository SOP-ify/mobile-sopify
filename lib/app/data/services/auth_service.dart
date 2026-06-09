import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';

/// App-wide auth state: persists the bearer token and current user, and exposes
/// reactive login state. Registered once (see `main.dart`) and resolved with
/// `AuthService.to`.
class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  final GetStorage _box = GetStorage();
  static const String _kToken = 'access_token';
  static const String _kUser = 'user';

  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  String? _token;

  String? get token => _token;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  Future<AuthService> init() async {
    _token = _box.read<String>(_kToken);
    final dynamic storedUser = _box.read(_kUser);
    if (storedUser is Map) {
      currentUser.value =
          UserModel.fromJson(Map<String, dynamic>.from(storedUser));
    }
    return this;
  }

  Future<void> saveSession({required String token, UserModel? user}) async {
    _token = token;
    await _box.write(_kToken, token);
    if (user != null) {
      currentUser.value = user;
      await _box.write(_kUser, user.toJson());
    }
  }

  Future<void> setUser(UserModel user) async {
    currentUser.value = user;
    await _box.write(_kUser, user.toJson());
  }

  Future<void> clear() async {
    _token = null;
    currentUser.value = null;
    await _box.remove(_kToken);
    await _box.remove(_kUser);
  }
}
