import 'package:serverpod/serverpod.dart';
import 'package:serverpod_chat_server/src/generated/protocol.dart';

class ChatEndpoint extends Endpoint {
  Future<void> sendMessage(Session session, ChatMessage message) async {
    session.messages.postMessage('channel_${message.channelId}', message);
  }

  Stream<ChatMessage> observeChannel(Session session, int channelId) async* {
    final eventSteam =
        session.messages.createStream<ChatMessage>('channel_$channelId');
    await for (var message in eventSteam) {
      yield message;
    }
  }
}
