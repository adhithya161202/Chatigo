// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferenceHelper {
//   static String userIdKey="USERKEY";
//   static String userNameKey="USERNAMEKEY";
//   static String userEmailKey="USEREMAILKEY";
//   static String userPicKey="USERPICKEY";
//   static String userdisplayNameKey="UserDisplayName";


// Future<bool>saveUserId (String getUserId) async{
//   SharedPreferences prefs =await SharedPreferences.getInstance();
//   return prefs.setString(userIdKey, getUserId);
// }


// Future<bool>saveUserEmail(String getUserEmail) async{
//   SharedPreferences prefs =await SharedPreferences.getInstance();
//   return prefs.setString(userEmailKey, getUserEmail);
// }


// Future<bool>saveUserName(String getUserName) async{
//   SharedPreferences prefs =await SharedPreferences.getInstance();
//   return prefs.setString(userNameKey, getUserName);
// }

// Future<bool>saveUserPic(String getUserPic) async{
//   SharedPreferences prefs =await SharedPreferences.getInstance();
//   return prefs.setString(userPicKey, getUserPic);
// }

// Future<bool>saveUserDisplayName(String getUserDisplayName) async{
//   SharedPreferences prefs =await SharedPreferences.getInstance();
//   return prefs.setString(userdisplayNameKey, getUserDisplayName);
// }


// Future<String> getUserId()async{
//   SharedPreferences prefs= await SharedPreferences.getInstance();
//   return prefs.getString(userIdKey);
// }

// Future<String> getUserName()async{
//   SharedPreferences prefs= await SharedPreferences.getInstance();
//   return prefs.getString(userNameKey);
// }

// Future<String> getUserEmail()async{
//   SharedPreferences prefs= await SharedPreferences.getInstance();
//   return prefs.getString(userEmailKey);
// }

// Future<String> getUserPic()async{
//   SharedPreferences prefs= await SharedPreferences.getInstance();
//   return prefs.getString(userPicKey);
// }

// Future<String> getUserDisplayName()async{
//   SharedPreferences prefs= await SharedPreferences.getInstance();
//   return prefs.getString(userdisplayNameKey);
// }

// }
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const String userIdKey = "USERKEY";
  static const String userNameKey = "USERNAMEKEY";
  static const String userEmailKey = "USEREMAILKEY";
  static const String userPicKey = "USERPICKEY";
  static const String userDisplayNameKey = "USERDISPLAYNAME";
 // static const String userSearchKey = "USERSEARCHKEY";
  

  // Save user ID
  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  // Save user email
  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  // Save user name
  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  // Save user profile picture URL
  Future<bool> saveUserPic(String getUserPic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPicKey, getUserPic);
  }

  // Save user display name
  Future<bool> saveUserDisplayName(String getUserDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userDisplayNameKey, getUserDisplayName);
  }

  // Future<bool> saveSearchKey(String getUserSearchKey) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString(userSearchKey, getUserSearchKey);
  // }

  // Retrieve user ID
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  // Retrieve user name
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  // Retrieve user email
  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  // Retrieve user profile picture URL
  Future<String?> getUserPic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPicKey);
  }

  // Retrieve user display name
  Future<String?> getUserDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userDisplayNameKey);
  }

  // Future<String?> getUserSearchKey() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(userSearchKey);
  // }
}
