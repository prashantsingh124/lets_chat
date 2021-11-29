import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
  static String sharedPreferenceLoggedInKey="ISLOGGEDIN";
  static String sharedPreferenceUserName="USERNAMEKEY";
  static String sharedPreferenceUserEmailKey="USEREMAILKEY";

  //saving data to shared preference...
static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async {
SharedPreferences pref= await SharedPreferences.getInstance();
return await pref.setBool(sharedPreferenceLoggedInKey, isUserLoggedIn);
}
  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    return await pref.setString(sharedPreferenceUserName, userName);
  }
  static Future<bool> saveUserEmailKeySharedPreference(String userEmail) async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    return await pref.setString(sharedPreferenceUserEmailKey,userEmail);
  }

  //getting data from shred SharedPreferences

  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    return  pref.getBool(sharedPreferenceLoggedInKey);
  }
  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    return  pref.getString(sharedPreferenceUserName);
  }
  static Future<String> getUserEmailKeySharedPreference() async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    return  pref.getString(sharedPreferenceUserEmailKey);
  }
}



