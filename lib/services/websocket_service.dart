import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  String? _currentRequestId;

  // URL do WebSocket - ajuste conforme sua configuração
  // Para Android Emulator use: ws://10.0.2.2:3001
  // Para dispositivo físico use o IP da sua máquina
  static const String _wsUrl = 'ws://10.0.2.2:3001';

  Stream<Map<String, dynamic>> get messageStream =>
      _messageController?.stream ?? const Stream.empty();

  bool get isConnected => _channel != null;

  Future<void> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      _messageController = StreamController<Map<String, dynamic>>.broadcast();

      _channel!.stream.listen(
        (data) {
          try {
            final message = json.decode(data);
            _messageController?.add(message);
          } catch (e) {
            print('Erro ao decodificar mensagem WebSocket: $e');
          }
        },
        onError: (error) {
          print('Erro no WebSocket: $error');
          _reconnect();
        },
        onDone: () {
          print('Conexão WebSocket fechada');
          _reconnect();
        },
      );

      print('WebSocket conectado com sucesso');
    } catch (e) {
      print('Erro ao conectar WebSocket: $e');
      // Tentar reconectar após 3 segundos
      Timer(const Duration(seconds: 3), _reconnect);
    }
  }

  Future<void> _reconnect() async {
    await disconnect();
    await Future.delayed(const Duration(seconds: 3));
    await connect();
  }

  Future<void> disconnect() async {
    _currentRequestId = null;
    await _channel?.sink.close(status.normalClosure);
    _channel = null;
    await _messageController?.close();
    _messageController = null;
  }

  void sendQRScanRequest({
    required String requestId,
    required String qrCode,
    required String participantId,
    required String scannerLocation,
  }) {
    _currentRequestId = requestId;

    final message = {
      'type': 'qr_scan_request',
      'requestId': requestId,
      'qrCode': qrCode,
      'participantId': participantId,
      'scannerLocation': scannerLocation,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _sendMessage(message);
  }

  void _sendMessage(Map<String, dynamic> message) {
    if (_channel?.sink != null) {
      _channel!.sink.add(json.encode(message));
      print('Mensagem enviada: ${json.encode(message)}');
    } else {
      print('WebSocket não está conectado');
    }
  }

  String? get currentRequestId => _currentRequestId;

  void clearCurrentRequest() {
    _currentRequestId = null;
  }
}
