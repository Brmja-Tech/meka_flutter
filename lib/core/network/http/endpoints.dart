sealed class EndPoints {
  //base
  static const String baseUrl = 'https://app.mekansim.com/api/';

  //auth
  static const String login = 'login';
  static const String register = 'register';
  static const String logout = 'logout';

  //chat
  static const String createRoom = 'chats';

  static String getRooms(String id) => 'chats/$id';
  static const String sendMessage = 'chats';

  static String getMessages(String id) => 'chats/$id/replies';
}
