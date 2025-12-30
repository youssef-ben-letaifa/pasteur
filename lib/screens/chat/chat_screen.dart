import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/gemini_service.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/chat_message.dart';
import '../../models/user_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _geminiService = GeminiService();
  final _authService = AuthService();
  final _databaseService = DatabaseService();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  List<ChatMessage> _messages = [];
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _currentUser = await _authService.getCurrentUser();
    if (_currentUser != null) {
      _messages = _databaseService.getUserChatMessages(_currentUser!.id);
    }

    setState(() => _isLoading = false);

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _currentUser == null) {
      return;
    }

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    // Add user message
    final userChatMessage = ChatMessage(
      id: '${DateTime.now().millisecondsSinceEpoch}_user',
      userId: _currentUser!.id,
      content: userMessage,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userChatMessage);
      _isSending = true;
    });

    await _databaseService.saveChatMessage(userChatMessage);
    _scrollToBottom();

    try {
      // Get AI response
      final response = await _geminiService.sendMessage(
        message: userMessage,
        user: _currentUser,
        conversationHistory: _messages,
      );

      // Add AI response
      final aiChatMessage = ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_ai',
        userId: _currentUser!.id,
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(aiChatMessage);
        _isSending = false;
      });

      await _databaseService.saveChatMessage(aiChatMessage);
      _scrollToBottom();
    } catch (e) {
      setState(() => _isSending = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Medical Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Chat'),
                  content: const Text(
                    'Are you sure you want to clear the chat history?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );

              if (confirm == true && _currentUser != null) {
                await _databaseService.deleteAllUserChats(_currentUser!.id);
                setState(() => _messages.clear());
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Messages List
                Expanded(
                  child: _messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.chat_bubble_outline,
                                size: 80,
                                color: AppTheme.lightBlue,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Start a conversation',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                child: Text(
                                  'Ask me about your symptoms, health concerns, or medical questions',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppTheme.textSecondary),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return _buildMessageBubble(_messages[index]);
                          },
                        ),
                ),

                // Typing  indicator
                if (_isSending)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: AppTheme.lightBlue,
                          child: Icon(
                            Icons.smart_toy,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI is typing...',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                    ),
                  ),

                // Input Field
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Describe your symptoms...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                color: AppTheme.lightBlue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                color: AppTheme.lightBlue,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                color: AppTheme.primaryBlue,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton(
                        onPressed: _isSending ? null : _sendMessage,
                        mini: true,
                        child: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.lightBlue,
              child: Icon(Icons.smart_toy, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppTheme.primaryBlue
                    : AppTheme.lightBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Text(
                message.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isUser ? Colors.white : AppTheme.textPrimary,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryBlue,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
