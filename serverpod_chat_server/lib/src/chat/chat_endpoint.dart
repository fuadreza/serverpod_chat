import 'package:serverpod/serverpod.dart';
import 'package:serverpod_chat_server/src/generated/protocol.dart';

class ChatEndpoint extends Endpoint {
  Future<void> sendMessage(Session session, ChatMessage message) async {
    await ChatMessage.db.insertRow(session, message);

    session.messages.postMessage('channel_${message.channelId}', message);
  }

  Future<List<ChatMessage>> getChatHistory(
      Session session, int channelId) async {
    final result = await session.db.unsafeQuery('''
SELECT chat_message.*, users.name as "senderName" FROM chat_message 
LEFT JOIN users ON "chat_message"."senderId" = users.id
WHERE "channelId" = @channelId 
ORDER BY "timeSent" ASC
''', parameters: QueryParameters.named({'channelId': channelId}));
    return result.map((e) => ChatMessage.fromJson(e.toColumnMap())).toList();
  }

  Stream<ChatMessage> observeChannel(Session session, int channelId) async* {
    final eventSteam =
        session.messages.createStream<ChatMessage>('channel_$channelId');
    await for (var message in eventSteam) {
      final sender = await User.db.findById(session, message.senderId);
      yield message.copyWith(
        senderName: sender?.name,
      );
    }
  }
}
