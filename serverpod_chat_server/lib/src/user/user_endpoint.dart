import 'package:serverpod/serverpod.dart';
import 'package:serverpod_chat_server/src/generated/exception/exception.dart';
import 'package:serverpod_chat_server/src/generated/user/user.dart';

class UserEndpoint extends Endpoint {
  Future<String> signUp(Session session, User user) async {
    await User.db.insertRow(session, user);
    return 'User created successfully';
  }

  Future<User> signIn(Session session, User user) async {
    final existingUser = await User.db
        .findFirstRow(session, where: (u) => u.email.equals(user.email));
    if (existingUser != null) {
      if (existingUser.password == user.password) {
        return existingUser;
      } else {
        throw ServerException(message: 'Incorrect password');
      }
    } else {
      throw ServerException(message: 'User not found');
    }
  }
}
