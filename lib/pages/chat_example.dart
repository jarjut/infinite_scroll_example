import 'package:flutter/material.dart';
import 'package:infinite_scroll/item.dart';

/// Example infinite scrolling with two slivers method for chat app.
class ChatExamplePage extends StatefulWidget {
  const ChatExamplePage({Key? key}) : super(key: key);

  @override
  State<ChatExamplePage> createState() => _ChatExamplePageState();
}

class _ChatExamplePageState extends State<ChatExamplePage> {
  final _scrollController = ScrollController();

  bool showScrollToBottom = false;

  List<Message> olderList = [];
  List<Message> newerList = [];

  @override
  void initState() {
    olderList = Message.dummyMessages();
    olderList.sort((a, b) => b.date.compareTo(a.date));
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    checkScrolltoBottom();
  }

  void checkScrolltoBottom() {
    var position = _scrollController.position;
    if (position.pixels > position.minScrollExtent + 60) {
      if (!showScrollToBottom) setState(() => showScrollToBottom = true);
    } else {
      if (showScrollToBottom) setState(() => showScrollToBottom = false);
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var position = _scrollController.position;
      var maxScroll = 600;
      if (position.pixels - position.minScrollExtent > maxScroll) {
        _scrollController.jumpTo(position.minScrollExtent + maxScroll);
      }
      _scrollController.animateTo(
        position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void addNewMessage() {
    newerList.add(Message(
      text: 'New Message',
      date: DateTime.now(),
      isMe: newerList.isEmpty ? false : !newerList.last.isMe,
    ));
    setState(() {});
    if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const centerKey = ValueKey('center-list');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addNewMessage,
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        center: centerKey,
        reverse: true,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final message = newerList[index];
                return ChatBubble(
                  message: message.text,
                  isMe: message.isMe,
                  date: message.date,
                );
              },
              childCount: newerList.length,
            ),
          ),
          SliverList(
            key: centerKey,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final message = olderList[index];
                return ChatBubble(
                  message: message.text,
                  isMe: message.isMe,
                  date: message.date,
                );
              },
              childCount: olderList.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 18)),
        ],
      ),
      floatingActionButton: showScrollToBottom
          ? FloatingActionButton(
              onPressed: scrollToBottom,
              child: const Icon(Icons.keyboard_arrow_down),
            )
          : null,
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.message,
    this.isMe = true,
    required this.date,
  }) : super(key: key);

  final String message;
  final bool isMe;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, bottom: 12),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isMe ? Colors.lightBlue.shade100 : Colors.grey.shade200,
            ),
            child: Text(message),
          ),
        ),
      ],
    );
  }
}
