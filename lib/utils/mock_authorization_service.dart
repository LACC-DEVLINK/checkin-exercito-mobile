import 'dart:async';
import 'dart:math';

class MockAuthorizationService {
  static final MockAuthorizationService _instance =
      MockAuthorizationService._internal();
  factory MockAuthorizationService() => _instance;
  MockAuthorizationService._internal();

  final StreamController<Map<String, dynamic>> _authorizationController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get authorizationStream =>
      _authorizationController.stream;

  // Simula uma requisição de autorização
  Future<String> requestAuthorization({
    required String participantId,
    required String qrCode,
    required String participantName,
  }) async {
    final requestId = 'req_${DateTime.now().millisecondsSinceEpoch}';

    // Simula envio para a central
    print('Enviando solicitação de autorização: $requestId');

    // Simula resposta da central após alguns segundos
    Timer(Duration(seconds: 2 + Random().nextInt(4)), () {
      _simulateAuthorizationResponse(requestId, participantId, participantName);
    });

    return requestId;
  }

  void _simulateAuthorizationResponse(
    String requestId,
    String participantId,
    String participantName,
  ) {
    // Simula uma decisão aleatória (80% aprovado, 20% negado)
    final isApproved =
        Random().nextBool() && Random().nextBool() || Random().nextBool();
    final adminNames = [
      'Admin Silva',
      'Coronel Santos',
      'Major Lima',
      'Sistema',
    ];
    final adminName = adminNames[Random().nextInt(adminNames.length)];

    Map<String, dynamic> response = {
      'type': 'authorization_response',
      'requestId': requestId,
      'participantId': participantId,
      'participantName': participantName,
      'approved': isApproved,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (isApproved) {
      response['approvedBy'] = adminName;
    } else {
      response['deniedBy'] = adminName;
      response['reason'] = _getRandomDenialReason();
    }

    _authorizationController.add(response);
  }

  String _getRandomDenialReason() {
    final reasons = [
      'Documento em análise',
      'Autorização pendente do comando',
      'Horário não autorizado',
      'Necessário agendamento prévio',
      'Participante não cadastrado no evento',
    ];
    return reasons[Random().nextInt(reasons.length)];
  }

  void dispose() {
    _authorizationController.close();
  }
}
