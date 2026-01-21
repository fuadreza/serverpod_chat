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

abstract class ChatMessage implements _i1.SerializableModel {
  ChatMessage._({
    this.id,
    required this.channelId,
    required this.senderId,
    required this.message,
    required this.timeSent,
    this.senderName,
  });

  factory ChatMessage({
    int? id,
    required int channelId,
    required int senderId,
    required String message,
    required DateTime timeSent,
    String? senderName,
  }) = _ChatMessageImpl;

  factory ChatMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessage(
      id: jsonSerialization['id'] as int?,
      channelId: jsonSerialization['channelId'] as int,
      senderId: jsonSerialization['senderId'] as int,
      message: jsonSerialization['message'] as String,
      timeSent:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timeSent']),
      senderName: jsonSerialization['senderName'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int channelId;

  int senderId;

  String message;

  DateTime timeSent;

  String? senderName;

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatMessage copyWith({
    int? id,
    int? channelId,
    int? senderId,
    String? message,
    DateTime? timeSent,
    String? senderName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'channelId': channelId,
      'senderId': senderId,
      'message': message,
      'timeSent': timeSent.toJson(),
      if (senderName != null) 'senderName': senderName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatMessageImpl extends ChatMessage {
  _ChatMessageImpl({
    int? id,
    required int channelId,
    required int senderId,
    required String message,
    required DateTime timeSent,
    String? senderName,
  }) : super._(
          id: id,
          channelId: channelId,
          senderId: senderId,
          message: message,
          timeSent: timeSent,
          senderName: senderName,
        );

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatMessage copyWith({
    Object? id = _Undefined,
    int? channelId,
    int? senderId,
    String? message,
    DateTime? timeSent,
    Object? senderName = _Undefined,
  }) {
    return ChatMessage(
      id: id is int? ? id : this.id,
      channelId: channelId ?? this.channelId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      timeSent: timeSent ?? this.timeSent,
      senderName: senderName is String? ? senderName : this.senderName,
    );
  }
}
