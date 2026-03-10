import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants/api_constants.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  
  late IO.Socket _socket;
  
  // Callbacks
  Function(dynamic)? onOrderUpdated;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  void connect() {
    _socket = IO.io(
      ApiConstants.socketUrl,
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
    );

    _socket.connect();

    _socket.on('connect', (_) {
      print('🟢 Socket connected');
    });

    _socket.on('orderUpdated', (data) {
      print('📢 Order updated from socket: $data');
      if (onOrderUpdated != null) {
        onOrderUpdated!(data);
      }
    });

    _socket.on('disconnect', (_) {
      print('🔴 Socket disconnected');
    });

    _socket.on('error', (error) {
      print('❌ Socket error: $error');
    });
  }

  void disconnect() {
    _socket.disconnect();
  }

  IO.Socket get socket => _socket;

  bool get isConnected => _socket.connected;
}
