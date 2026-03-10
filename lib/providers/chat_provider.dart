import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get messages => _messages;

  /// Thêm tin nhắn
  void addMessage(Map<String, dynamic> message) {
    _messages.add(message);
    notifyListeners();
  }

  /// Thêm nhiều tin nhắn
  void addMessages(List<Map<String, dynamic>> messages) {
    _messages.addAll(messages);
    notifyListeners();
  }

  /// Xóa tất cả tin nhắn (khi đổi bàn)
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  /// Lấy số tin nhắn
  int get messageCount => _messages.length;
}
