import 'dart:async';
import 'package:flutter/material.dart';
import 'package:serverpod_chat_client/serverpod_chat_client.dart';
import 'package:serverpod_chat_flutter/main.dart';
import 'chat_screen.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

enum ChatRoomState {
  selection,
  joining,
  joined,
  creating,
  created,
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _controller = TextEditingController();
  ChatRoomState _state = ChatRoomState.selection;
  String? _generatedCode;
  int _countdown = 3;
  Timer? _timer;

  Channel? _channel;

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onJoin() async {
    if (_controller.text.isNotEmpty) {
      debugPrint('Joining room with code: ${_controller.text}');
      final channel = await client.channel.joinChannel(_controller.text);
      if (channel != null) {
        setState(() {
          _channel = channel;
          _generatedCode = channel.name;
          _state = ChatRoomState.joined;
        });
        _startCountdown();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Channel not found'),
            ),
          );
        }
      }
    }
  }

  void _navigateToCreate() async {
    setState(() {
      _state = ChatRoomState.creating;
    });

    final channel = await client.channel.createChannel('');

    setState(() {
      _channel = channel;
      _generatedCode = channel.name;
      _state = ChatRoomState.created;
    });

    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                channel: _channel!,
              ),
            ),
          );
        }
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  void _onBack() {
    setState(() {
      _state = ChatRoomState.selection;
      _controller.clear();
      _generatedCode = null;
      _countdown = 3;
    });
    _timer?.cancel();
  }

  Widget _buildSelectionView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome to Serverpod Chat',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _navigateToCreate,
            icon: const Icon(Icons.add),
            label: const Text('Create Channel'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _state = ChatRoomState.joining;
              });
            },
            icon: const Icon(Icons.login),
            label: const Text('Join Channel'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJoiningView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Join a Channel',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please enter the chat room code to join:',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Chat Room Code',
            hintText: 'Enter code here',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.meeting_room),
          ),
          onSubmitted: (_) => _onJoin(),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _onJoin,
            child: const Text('Join Channel'),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _onBack,
          child: const Text('Back'),
        ),
      ],
    );
  }

  Widget _buildCreatingView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 24),
        Text(
          'Creating your channel...',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildCreatedView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 64),
        const SizedBox(height: 24),
        Text(
          'Channel Created!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _generatedCode ?? 'ERROR',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Redirecting to chat in $_countdown...',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            _timer?.cancel();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  channel: _channel!,
                ),
              ),
            );
          },
          child: const Text('Join Now'),
        ),
      ],
    );
  }

  Widget _buildJoinedView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 64),
        const SizedBox(height: 24),
        Text(
          'Joined Channel!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _generatedCode ?? 'ERROR',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Redirecting to chat in $_countdown...',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            _timer?.cancel();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  channel: _channel!,
                ),
              ),
            );
          },
          child: const Text('Join Now'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_state) {
      case ChatRoomState.selection:
        content = _buildSelectionView();
        break;
      case ChatRoomState.joining:
        content = _buildJoiningView();
        break;
      case ChatRoomState.creating:
        content = _buildCreatingView();
        break;
      case ChatRoomState.created:
        content = _buildCreatedView();
        break;
      case ChatRoomState.joined:
        content = _buildJoinedView();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Serverpod Chat'),
        leading: _state != ChatRoomState.selection
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _onBack,
              )
            : null,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
