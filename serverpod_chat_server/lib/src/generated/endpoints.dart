/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../channel/channel_endpoint.dart' as _i2;
import '../chat/chat_endpoint.dart' as _i3;
import 'package:serverpod_chat_server/src/generated/chat/chat_message.dart'
    as _i4;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'channel': _i2.ChannelEndpoint()
        ..initialize(
          server,
          'channel',
          null,
        ),
      'chat': _i3.ChatEndpoint()
        ..initialize(
          server,
          'chat',
          null,
        ),
    };
    connectors['channel'] = _i1.EndpointConnector(
      name: 'channel',
      endpoint: endpoints['channel']!,
      methodConnectors: {
        'createChannel': _i1.MethodConnector(
          name: 'createChannel',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['channel'] as _i2.ChannelEndpoint).createChannel(
            session,
            params['name'],
          ),
        ),
        'joinChannel': _i1.MethodConnector(
          name: 'joinChannel',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['channel'] as _i2.ChannelEndpoint).joinChannel(
            session,
            params['name'],
          ),
        ),
      },
    );
    connectors['chat'] = _i1.EndpointConnector(
      name: 'chat',
      endpoint: endpoints['chat']!,
      methodConnectors: {
        'sendMessage': _i1.MethodConnector(
          name: 'sendMessage',
          params: {
            'message': _i1.ParameterDescription(
              name: 'message',
              type: _i1.getType<_i4.ChatMessage>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['chat'] as _i3.ChatEndpoint).sendMessage(
            session,
            params['message'],
          ),
        ),
        'observeChannel': _i1.MethodStreamConnector(
          name: 'observeChannel',
          params: {
            'channelId': _i1.ParameterDescription(
              name: 'channelId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['chat'] as _i3.ChatEndpoint).observeChannel(
            session,
            params['channelId'],
          ),
        ),
      },
    );
  }
}
