/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_chat_client/src/protocol/channel/channel.dart' as _i3;
import 'package:serverpod_chat_client/src/protocol/chat/chat_message.dart'
    as _i4;
import 'package:serverpod_chat_client/src/protocol/user/user.dart' as _i5;
import 'protocol.dart' as _i6;

/// {@category Endpoint}
class EndpointChannel extends _i1.EndpointRef {
  EndpointChannel(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'channel';

  _i2.Future<_i3.Channel> createChannel(String name) =>
      caller.callServerEndpoint<_i3.Channel>(
        'channel',
        'createChannel',
        {'name': name},
      );

  _i2.Future<_i3.Channel?> joinChannel(String name) =>
      caller.callServerEndpoint<_i3.Channel?>(
        'channel',
        'joinChannel',
        {'name': name},
      );
}

/// {@category Endpoint}
class EndpointChat extends _i1.EndpointRef {
  EndpointChat(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'chat';

  _i2.Future<void> sendMessage(_i4.ChatMessage message) =>
      caller.callServerEndpoint<void>(
        'chat',
        'sendMessage',
        {'message': message},
      );

  _i2.Future<List<_i4.ChatMessage>> getChatHistory(int channelId) =>
      caller.callServerEndpoint<List<_i4.ChatMessage>>(
        'chat',
        'getChatHistory',
        {'channelId': channelId},
      );

  _i2.Stream<_i4.ChatMessage> observeChannel(int channelId) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i4.ChatMessage>,
          _i4.ChatMessage>(
        'chat',
        'observeChannel',
        {'channelId': channelId},
        {},
      );
}

/// {@category Endpoint}
class EndpointUser extends _i1.EndpointRef {
  EndpointUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  _i2.Future<String> signUp(_i5.User user) => caller.callServerEndpoint<String>(
        'user',
        'signUp',
        {'user': user},
      );

  _i2.Future<_i5.User> signIn(_i5.User user) =>
      caller.callServerEndpoint<_i5.User>(
        'user',
        'signIn',
        {'user': user},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i6.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    channel = EndpointChannel(this);
    chat = EndpointChat(this);
    user = EndpointUser(this);
  }

  late final EndpointChannel channel;

  late final EndpointChat chat;

  late final EndpointUser user;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'channel': channel,
        'chat': chat,
        'user': user,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
