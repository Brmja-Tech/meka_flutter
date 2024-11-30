sealed class EndPoints {
  //base
  static const String baseUrl = 'https://app.mekansim.com/api/';

  //auth
  static const String login = 'login';
  static const String register = 'register';
  static const String logout = 'logout';
  static const String verifyOTP = 'verify';
  static const String sendOTP = 'otp';
  static const String socialLogin = 'social-login';
  static const String forgetPassword = 'forget-password';
  static const String resetPassword = 'reset-password';
  static const String getProfile = 'profile';
  static const String updateProfile = 'profile';

  //chat
  static const String createRoom = 'chats';

  static const String getRooms = 'chats';

  static String sendMessage(String id) => 'chats/$id/replies';

  static String getMessages(String id) => 'chats/$id/replies';
}
