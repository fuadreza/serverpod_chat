import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_chat_server/src/generated/channel/channel.dart';

class ChannelEndpoint extends Endpoint {
  Future<Channel> createChannel(Session session, String name) async {
    final roomNumber =
        '${Random().nextInt(9)}${Random().nextInt(9)}${Random().nextInt(9)}${Random().nextInt(9)}';
    final channelWithId = await Channel.db.insertRow(
      session,
      Channel(
        name: 'ROOM-$roomNumber',
      ),
    );
    return channelWithId;
  }

  Future<Channel?> joinChannel(Session session, String name) async {
    final channelWithId = await Channel.db.findFirstRow(
      session,
      where: (t) => t.name.equals(name),
    );
    return channelWithId;
  }
}
