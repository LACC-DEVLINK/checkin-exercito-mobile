import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/mock_authorization_service.dart';
import '../utils/websocket_service.dart';
import 'participant_details_screen.dart';

class AwaitingAuthorizationScreen extends StatefulWidget {
  final Map<String, dynamic> scannedData;

  const AwaitingAuthorizationScreen({super.key, required this.scannedData});

  @override
  State<AwaitingAuthorizationScreen> createState() =>
      _AwaitingAuthorizationScreenState();
}

class _AwaitingAuthorizationScreenState
    extends State<AwaitingAuthorizationScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _loadingController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _loadingAnimation;

  final MockAuthorizationService _authService = MockAuthorizationService();
  StreamSubscription? _messageSubscription;
  String? _requestId;
  bool _isWaiting = true;
  String _status = 'Enviando solicitação para a central...';

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
    _loadingController.repeat();

    _initializeWebSocket();
  }

  Future<void> _initializeWebSocket() async {
    try {
      // Tentar usar WebSocket real primeiro
      await _initializeRealWebSocket();
    } catch (e) {
      print('WebSocket real falhou, usando mock service: $e');
      // Fallback para o serviço mock
      _initializeMockService();
    }

    // Timeout após 30 segundos
    Timer(const Duration(seconds: 30), () {
      if (_isWaiting && mounted) {
        _handleTimeout();
      }
    });
  }

  Future<void> _initializeRealWebSocket() async {
    final wsService = WebSocketService();
    await wsService.connect();

    _messageSubscription = wsService.messageStream.listen((message) {
      _handleWebSocketMessage(message);
    });

    // Enviar solicitação via WebSocket real
    final requestId = 'req_${DateTime.now().millisecondsSinceEpoch}';
    _requestId = requestId;

    setState(() {
      _status = 'Conectando com a central...';
    });

    wsService.sendQRScanRequest(
      requestId: requestId,
      qrCode: widget.scannedData['qrCode'] ?? 'QR001',
      participantId: widget.scannedData['participantId'] ?? '1',
      scannerLocation: 'Portão Principal - Terminal Mobile',
    );

    setState(() {
      _status = 'Aguardando autorização da central...';
    });
  }

  void _initializeMockService() {
    _messageSubscription = _authService.authorizationStream.listen((message) {
      _handleWebSocketMessage(message);
    });

    // Enviar solicitação via mock service
    _sendAuthorizationRequest();
  }

  Future<void> _sendAuthorizationRequest() async {
    setState(() {
      _status = 'Aguardando autorização da central...';
    });

    _requestId = await _authService.requestAuthorization(
      participantId: widget.scannedData['participantId'] ?? '1',
      qrCode: widget.scannedData['qrCode'] ?? 'QR001',
      participantName: widget.scannedData['name'] ?? 'Participante',
    );
  }

  void _handleWebSocketMessage(Map<String, dynamic> message) {
    if (message['requestId'] != _requestId) return;

    setState(() {
      switch (message['type']) {
        case 'authorization_response':
          _isWaiting = false;
          if (message['approved'] == true) {
            _handleApproved(message);
          } else {
            _handleDenied(message);
          }
          break;
        default:
          break;
      }
    });
  }

  void _handleApproved(Map<String, dynamic> message) {
    _pulseController.stop();
    _loadingController.stop();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ParticipantDetailsScreen(
          participantData: {
            'name': widget.scannedData['name'] ?? 'Participante',
            'id': widget.scannedData['participantId'] ?? '12345',
            'event': 'Evento Militar - FortAccess',
            'access': 'Autorizado',
            'approvedBy': message['approvedBy'] ?? 'Sistema',
            'timestamp':
                message['timestamp'] ?? DateTime.now().toIso8601String(),
          },
        ),
      ),
    );
  }

  void _handleDenied(Map<String, dynamic> message) {
    _pulseController.stop();
    _loadingController.stop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.cancel, color: Colors.red, size: 32),
              const SizedBox(width: 12),
              const Text(
                'Acesso Negado',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'A solicitação de entrada foi negada pela central.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 12),
              if (message['reason'] != null)
                Text(
                  'Motivo: ${message['reason']}',
                  style: TextStyle(color: Colors.red.shade300, fontSize: 14),
                ),
              const SizedBox(height: 8),
              Text(
                'Negado por: ${message['deniedBy'] ?? 'Sistema'}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar dialog
                Navigator.of(context).pop(); // Voltar para scanner
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleTimeout() {
    _pulseController.stop();
    _loadingController.stop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.access_time, color: Colors.orange, size: 32),
              const SizedBox(width: 12),
              const Text(
                'Tempo Esgotado',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'A solicitação de autorização expirou. Tente escanear o QR Code novamente.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar dialog
                Navigator.of(context).pop(); // Voltar para scanner
              },
              child: const Text(
                'Tentar Novamente',
                style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _loadingController.dispose();
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/imagcapa.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.9),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Aguardando Autorização',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const Spacer(),

                // Ícone de autorização animado
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange.withOpacity(0.2),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.security,
                          size: 60,
                          color: Colors.orange,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Título
                const Text(
                  'AGUARDANDO AUTORIZAÇÃO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Status
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    _status,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 40),

                // Loading indicator
                if (_isWaiting)
                  AnimatedBuilder(
                    animation: _loadingAnimation,
                    builder: (context, child) {
                      return SizedBox(
                        width: 200,
                        height: 4,
                        child: LinearProgressIndicator(
                          value: _loadingAnimation.value,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 60),

                // Informações do participante (se disponível)
                if (widget.scannedData['name'] != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DADOS DO PARTICIPANTE',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.scannedData['name'] ?? 'Nome não disponível',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.scannedData['id'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'ID: ${widget.scannedData['id']}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Botão cancelar
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.2),
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(
                          color: Colors.red.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'CANCELAR SOLICITAÇÃO',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
