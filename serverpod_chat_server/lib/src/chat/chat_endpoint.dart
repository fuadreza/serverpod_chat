import 'package:serverpod/serverpod.dart';
import 'package:serverpod_chat_server/src/generated/protocol.dart';

class ChatEndpoint extends Endpoint {
  Future<void> sendMessage(Session session, ChatMessage message) async {
    await ChatMessage.db.insertRow(session, message);

    session.messages.postMessage('channel_${message.channelId}', message);
  }

  Future<List<ChatMessage>> getChatHistory(
      Session session, int channelId) async {
    return await ChatMessage.db
        .find(session, where: (t) => t.channelId.equals(channelId));
  }

  Stream<ChatMessage> observeChannel(Session session, int channelId) async* {
    final eventSteam =
        session.messages.createStream<ChatMessage>('channel_$channelId');
    await for (var message in eventSteam) {
      yield message;
    }
  }
}
