import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'ai_service.dart';
import 'models/message.dart';
import 'models/user.dart';
import 'theme/app_colors.dart';
import 'widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final User currentUser;
  
  const ChatScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(Message(
        text: "愿主的平安与你同在，我是约翰牧师，很高兴能遇见你。请告诉我，我能为你做什么？",
        isUser: false,
      ));
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      _messages.add(Message(
        text: text,
        isUser: true,
        sender: widget.currentUser,
      ));
      _controller.clear();
      _isLoading = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      final response = await AiService.getResponse(text);
      setState(() {
        _messages.add(Message(
          text: response,
          isUser: false,
        ));
        _isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      setState(() {
        _messages.add(Message(
          text: "抱歉，发生了一些错误。让我们一起祷告寻求主的帮助。",
          isUser: false,
        ));
        _isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('以马内利'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: AppColors.backgroundPrimary,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                itemCount: _messages.length,
                itemBuilder: (context, i) => MessageBubble(message: _messages[i]),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundElevated,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -1),
                  blurRadius: 8,
                  color: AppColors.shadow,
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  if (_isLoading)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const CupertinoActivityIndicator(
                        radius: 10,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: '分享你的想法...',
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _sendMessage,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
} 