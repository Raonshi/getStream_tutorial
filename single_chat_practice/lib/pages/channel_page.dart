import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatelessWidget {
  const ChannelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChannelHeader(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MessageListView(
                threadBuilder: (_, parent) => ThreadPage(parent: parent),
              ),
            ),
            const MessageInput(),
          ],
        ),
      ),
    );
  }
}

class ThreadPage extends StatelessWidget {
  const ThreadPage({Key? key, this.parent}) : super(key: key);

  final Message? parent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThreadHeader(parent: parent!),
      body: Column(
        children: [
          Expanded(
            child: MessageListView(
              parentMessage: parent,
            ),
          ),
          MessageInput(
            parentMessage: parent,
          ),
        ],
      ),
    );
  }
}