import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user_model.dart';
import '../../models/health_record.dart';
import '../../models/chat_message.dart';
import '../config/constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Box<UserModel>? _userBox;
  Box<HealthRecord>? _healthBox;
  Box<ChatMessage>? _chatBox;

  // Initialize Hive database
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(HealthRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(HealthRecordTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ChatMessageAdapter());
    }

    // Open boxes
    _userBox = await Hive.openBox<UserModel>(AppConstants.userBoxName);
    _healthBox = await Hive.openBox<HealthRecord>(AppConstants.healthBoxName);
    _chatBox = await Hive.openBox<ChatMessage>(AppConstants.chatBoxName);
  }

  // User Operations
  Future<void> saveUser(UserModel user) async {
    await _userBox?.put(user.id, user);
  }

  UserModel? getUser(String userId) {
    return _userBox?.get(userId);
  }

  List<UserModel> getAllUsers() {
    return _userBox?.values.toList() ?? [];
  }

  Future<void> deleteUser(String userId) async {
    await _userBox?.delete(userId);
  }

  UserModel? getUserByUsername(String username) {
    return _userBox?.values.firstWhere(
      (user) => user.username.toLowerCase() == username.toLowerCase(),
      orElse: () => throw Exception('User not found'),
    );
  }

  // Health Record Operations
  Future<void> saveHealthRecord(HealthRecord record) async {
    await _healthBox?.put(record.id, record);
  }

  HealthRecord? getHealthRecord(String recordId) {
    return _healthBox?.get(recordId);
  }

  List<HealthRecord> getUserHealthRecords(String userId) {
    return _healthBox?.values
            .where((record) => record.userId == userId)
            .toList() ??
        [];
  }

  List<HealthRecord> getUserHealthRecordsByType(
    String userId,
    HealthRecordType type,
  ) {
    return _healthBox?.values
            .where((record) => record.userId == userId && record.type == type)
            .toList() ??
        [];
  }

  Future<void> deleteHealthRecord(String recordId) async {
    await _healthBox?.delete(recordId);
  }

  // Chat Message Operations
  Future<void> saveChatMessage(ChatMessage message) async {
    await _chatBox?.put(message.id, message);
  }

  ChatMessage? getChatMessage(String messageId) {
    return _chatBox?.get(messageId);
  }

  List<ChatMessage> getUserChatMessages(String userId) {
    final messages =
        _chatBox?.values
            .where((message) => message.userId == userId)
            .toList() ??
        [];
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  Future<void> deleteChatMessage(String messageId) async {
    await _chatBox?.delete(messageId);
  }

  Future<void> deleteAllUserChats(String userId) async {
    final userMessages = getUserChatMessages(userId);
    for (var message in userMessages) {
      await deleteChatMessage(message.id);
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _userBox?.clear();
    await _healthBox?.clear();
    await _chatBox?.clear();
  }

  // Close boxes
  Future<void> close() async {
    await _userBox?.close();
    await _healthBox?.close();
    await _chatBox?.close();
  }
}
