import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {

  /// Session manager instance
  SharedPreferences _prefs;

  final String _userId = "userId";
  final String _userName = "userName";
  final String _userType = "userType";
  final String _imageName = "imageName";
  final String _authToken = "authToken";
  final String _accessToken = "accessToken";
  final String _isUserLoggedIn = "isLogged_in";
  final String _isApproved = "isApproved";
  final String _accountLocked = "accountLocked";
  final String _enabled = "enabled";

  PrefsManager() {
    getSharedPreferences();
  }

  void getSharedPreferences() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  //set data into shared preferences like this
  void setUserLoggedIn(bool isUserLoggedIn) {
    _prefs.setBool(this._isUserLoggedIn, isUserLoggedIn);
  }

  //get value from shared preferences
  bool isUserLoggedIn() {
    return _prefs.getBool(this._isUserLoggedIn) ?? false;
  }

  void setUserId(int userId) async {
    _prefs.setInt(this._userId, userId);
  }

  int getUserId() {
    return _prefs.getInt(this._userId) ?? 0;
  }

  void setUserName(String username) {
    _prefs.setString(this._userName, username);
  }

  String getUserName() {
    return _prefs.getString(this._userName) ?? null;
  }

  void setUserType(String userType) {
    _prefs.setString(this._userType, userType);
  }

  String getUserType() {
    return _prefs.getString(this._userType) ?? null;
  }

  void setProfileImage(String imageName) {
    _prefs.setString(this._imageName, imageName);
  }

  String getProfileImage() {
    return _prefs.getString(this._imageName) ?? null;
  }

  void setIsApproved(bool isApproved) {
    _prefs.setBool(this._isApproved, isApproved);
  }

  bool getIsApproved() {
    return _prefs.getString(this._isApproved) ?? false;
  }

  void setAccountLocked(bool accountLocked) {
    _prefs.setBool(this._accountLocked, accountLocked);
  }

  bool getAccountLocked() {
    return _prefs.getString(this._accountLocked) ?? true;
  }

  void setEnabled(bool enabled) {
    _prefs.setBool(this._enabled, enabled);
  }

  bool getEnabled() {
    return _prefs.getString(this._enabled) ?? false;
  }
}
