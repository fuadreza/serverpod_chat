import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serverpod_chat_client/serverpod_chat_client.dart';
import 'package:serverpod_chat_flutter/main.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.channel,
    required this.user,
  });

  final Channel channel;
  final User user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  StreamSubscription<ChatMessage>? _sub;
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  int senderId = 1;

  @override
  void initState() {
    super.initState();
    senderId = widget.user.id!;
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    if (widget.channel.id == null) return;

    try {
      final history = await client.chat.getChatHistory(widget.channel.id!);

      setState(() {
        _messages.addAll(history.toList());
      });

      _startListening();
    } catch (e) {
      print("Error loading chat: $e");
    }
  }

  Future<void> _startListening() async {
    if (widget.channel.id != null) {
      while (true) {
        try {
          final stream = client.chat.observeChannel(widget.channel.id!);

          await for (final msg in stream) {
            setState(() {
              _messages.add(msg);
            });
          }
        } on MethodStreamException catch (_) {
          setState(() {
            _messages.clear();
          });
        }

        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  void _sendMessage() async {
    if (_controller.text.trim().isNotEmpty && widget.channel.id != null) {
      await client.chat.sendMessage(
        ChatMessage(
          channelId: widget.channel.id!,
          senderId: senderId,
          message: _controller.text.trim(),
          timeSent: DateTime.now(),
        ),
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            ChatHeader(channelName: widget.channel.name),
            Expanded(
              child: ChatList(messages: _messages, senderId: senderId),
            ),
            ChatInputField(
              controller: _controller,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key, required this.channelName});

  final String channelName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              'A',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                channelName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Online',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                    ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  final List<ChatMessage> messages;
  final int senderId;

  const ChatList({super.key, required this.messages, required this.senderId});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: messages.length,
      separatorBuilder: (_, __) {
        return const SizedBox(
          height: 4,
        );
      },
      itemBuilder: (context, index) {
        final isMe = messages[index].senderId == senderId;
        return ChatBubble(
          chatMessage: messages[index],
          isMe: isMe,
        );
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage chatMessage;
  final bool isMe;

  const ChatBubble({super.key, required this.chatMessage, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                chatMessage.senderName ?? '',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? colorScheme.primaryContainer
                  : colorScheme.secondaryContainer,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
            ),
            child: Text(
              chatMessage.message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isMe
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onSend,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.onPrimary,
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
