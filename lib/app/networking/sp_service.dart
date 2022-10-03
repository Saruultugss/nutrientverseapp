import 'package:shared_preferences/shared_preferences.dart';

class SPService {
  static const String height = "height";
  static const String weight = "weight";
  static const String age = "age";
  static const String gender = "gender";
  static const String currentCountryId = "currentCountryId";
  static const String targetCountryId = "targetCountryId";
  static const String allergy = "allergy";
  static const String oneDayCalories = "oneDayCalories";
  static const String oneDayProtein = "oneDayProtein";
  static const String oneDayCarbs = "oneDayCarbs";
  static const String BMI = "BMI";
  static const String token = "token";
  static const String notifCount = "notifCount";
  static const String registrationComplete = "registrationComplete";

  void storeString({required String key, required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  void storeStringList(
      {required String key, required List<String> value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  Future<List<String>?> fetchStringList({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  Future<String?> fetchString({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  void removeValue({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<int?> fetchInt({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  void storeInt({required String key, required int value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<bool?> fetchBool({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  void storeBool({required String key, required bool value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }
}
