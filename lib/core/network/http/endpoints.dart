sealed class EndPoints {
  //base
  static const String baseUrl = 'https://app.mekansim.com/api/';

  //auth
  static const String login = 'login';
  static const String register = 'register';
  static const String logout = 'logout';

  //chat
  static const String createRoom = 'chats';

  static const  String getRooms = 'chats';
  static  String sendMessage(String id) => 'chats/$id/replies';

  static String getMessages(String id) => 'chats/$id/replies';
}
