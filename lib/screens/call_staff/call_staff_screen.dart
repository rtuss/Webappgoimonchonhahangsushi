import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../core/constants/api_constants.dart';
import '../../providers/order_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/menu_provider.dart';

class CallStaffScreen extends StatefulWidget {
  const CallStaffScreen({super.key});

  @override
  State<CallStaffScreen> createState() => _CallStaffScreenState();
}

class _CallStaffScreenState extends State<CallStaffScreen> {
  final Dio _dio = Dio();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late IO.Socket _socket;
  late int banId;
  late int _lastBanId;

  @override
  void initState() {
    super.initState();
    // 📌 Lấy số bàn từ MenuProvider (guaranteed to be set)
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    
    banId = menuProvider.tableNumber; // Từ MenuProvider (đã set trong table_number_screen)
    _lastBanId = banId;
    print("📍 Chat loaded for bàn: $banId");
    
    _connectSocket();
    _loadHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 🔄 Kiểm tra xem bàn có thay đổi không
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final newBanId = orderProvider.currentSoBan ?? 1;
    
    if (newBanId != _lastBanId) {
      print("🔄 BÀN THAY ĐỔI: $_lastBanId → $newBanId");
      
      // 🧹 CLEAR CHAT NGAY
      context.read<ChatProvider>().clearMessages();
      
      _lastBanId = newBanId;
      banId = newBanId;
      
      // ♻️ Leave room cũ, join room mới
      _socket.emit("leaveRoom", _lastBanId);
      _socket.emit("joinRoom", banId);
      
      // 📥 Load lịch sử bàn mới
      _loadHistory();
    }
  }

  // ---------------------- LOAD LỊCH SỬ ----------------------
  Future<void> _loadHistory() async {
    try {
      final res =
      await _dio.get("${ApiConstants.baseUrl}/chat/$banId/messages");

      if (res.data["success"] == true) {
        final messages = (res.data["data"] as List).map((m) => {
          "from": m["nguoiGui"],
          "text": m["noiDung"],
          "time": m["thoiGian"],
        }).toList();
        
        // 💬 Add to ChatProvider (thay vì local state)
        context.read<ChatProvider>().addMessages(messages);
        _scrollToBottom();
      }
    } catch (e) {
      print("Lỗi load lịch sử: $e");
    }
  }

  // ---------------------- SOCKET ----------------------
  void _connectSocket() {
    _socket = IO.io(
      ApiConstants.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      print("🟢 Socket connected");
      // Join đúng phòng bàn khi vừa connect
      _socket.emit("joinRoom", banId);
    });

    // Khi socket bị mất kết nối rồi tự reconnect lại -> join room lại
    _socket.onReconnect((_) {
      print("♻️ Socket reconnect — join room lại");
      _socket.emit("joinRoom", banId);
    });

    // Nhận tin nhắn realtime từ server
    _socket.on("receiveMessage", (msg) {
      // Không phải tin của bàn này thì bỏ
      if (msg["banId"].toString() != banId.toString()) return;

      final bool isMe = msg["nguoiGui"] == "khach";

      // Nếu là tin mình vừa gửi, client đã push vào UI rồi -> bỏ để tránh nhân đôi
      if (isMe) return;

      // 💬 Add to ChatProvider
      context.read<ChatProvider>().addMessage({
        "from": msg["nguoiGui"],
        "text": msg["noiDung"],
        "time": msg["thoiGian"],
      });

      _scrollToBottom();
    });

    // 🧹 Khi đơn hoàn tất -> xóa chat lịch sử
    _socket.on("orderUpdated", (data) {
      if (data["order"] != null && data["order"]["trangThai"] == "hoan_tat") {
        if (data["order"]["soBan"].toString() == banId.toString()) {
          print("🧹 Order hoàn tất - clear chat");
          context.read<ChatProvider>().clearMessages();
        }
      }
    });
  }

  // ---------------------- GỬI TIN NHẮN ----------------------
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final msg = {
      "banId": banId,
      "noiDung": text,
      "nguoiGui": "khach",
      "thoiGian": DateTime.now().toIso8601String(),
    };

    // Emit socket cho server
    _socket.emit("sendMessage", msg);

    // 💬 Push to ChatProvider ngay để khách thấy tin của mình liền
    context.read<ChatProvider>().addMessage({"from": "khach", "text": text});
    _messageController.clear();

    _scrollToBottom();
  }

  // ---------------------- SCROLL XUỐNG CUỐI LIST ----------------------
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _socket.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------------- UI ----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),

          // NÚT GỌI NHÂN VIÊN
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                final player = AudioPlayer();
                await player.play(AssetSource('sounds/ting.mp3'));
              },
              icon: const Icon(Icons.notifications, color: Colors.white),
              label: const Text("GỌI NHÂN VIÊN"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),

          // KHUNG CHAT + HÌNH NỀN
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://i.pinimg.com/1200x/b4/58/c9/b458c973cb1a424ce6b9218d89b56f97.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  final messages = chatProvider.messages;
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final msg = messages[i];
                      final isMe = msg["from"] == "khach";

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          constraints: const BoxConstraints(maxWidth: 260),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.tealAccent.shade100.withOpacity(0.9)
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMe ? 16 : 0),
                              bottomRight: Radius.circular(isMe ? 0 : 16),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Text(
                            msg["text"],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Ô NHẬP TIN NHẮN
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      filled: true,
                      fillColor: const Color(0xFFF0F2F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 25,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
