import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'participant_details_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnimation;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();

    // Animação da linha de scan
    _scanLineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );

    _scanLineController.repeat();

    // Simular resultado do scan após 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _simulateScanResult();
      }
    });
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    super.dispose();
  }

  void _simulateScanResult() {
    setState(() {
      _isScanning = false;
    });
    _scanLineController.stop();
    HapticFeedback.lightImpact();

    // Navegar para tela de detalhes do participante
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParticipantDetailsScreen(
          participantData: {
            'name': 'Rafael Lindo',
            'id': '12345',
            'event': 'COP 30',
            'access': 'Autoridade',
          },
        ),
      ),
    );
  }

  void _restartScan() {
    setState(() {
      _isScanning = true;
    });
    _scanLineController.repeat();

    // Simular novo resultado
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isScanning) {
        _simulateScanResult();
      }
    });
  }

  void _goBack() {
    Navigator.of(context).pop();
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
                // Header com botão voltar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _goBack,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Scanner QR Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 48,
                      ), // Espaço para balancear o layout
                    ],
                  ),
                ),

                const Spacer(),

                // Área do Scanner
                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    child: Stack(
                      children: [
                        // Fundo semi-transparente
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        // Cantos do scanner
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.cyan, width: 4),
                                left: BorderSide(color: Colors.cyan, width: 4),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.cyan, width: 4),
                                right: BorderSide(color: Colors.cyan, width: 4),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.cyan,
                                  width: 4,
                                ),
                                left: BorderSide(color: Colors.cyan, width: 4),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.cyan,
                                  width: 4,
                                ),
                                right: BorderSide(color: Colors.cyan, width: 4),
                              ),
                            ),
                          ),
                        ),

                        // Linha de scan animada
                        if (_isScanning)
                          AnimatedBuilder(
                            animation: _scanLineAnimation,
                            builder: (context, child) {
                              return Positioned(
                                top: 40 + (_scanLineAnimation.value * 200),
                                left: 20,
                                right: 20,
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.cyan,
                                        Colors.cyan.withOpacity(0.8),
                                        Colors.cyan,
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.cyan.withOpacity(0.5),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Botão Focar e Escanear
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton.icon(
                    onPressed: _isScanning ? null : _restartScan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 4,
                    ),
                    icon: Icon(
                      _isScanning ? Icons.search : Icons.refresh,
                      size: 20,
                    ),
                    label: Text(
                      _isScanning ? 'FOCAR E ESCANEAR' : 'ESCANEAR NOVAMENTE',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Status da Leitura
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'STATUS DO SCANNER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isScanning ? Icons.search : Icons.check_circle,
                            color: _isScanning ? Colors.cyan : Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isScanning
                                ? 'Procurando QR Code...'
                                : 'QR Code detectado!',
                            style: TextStyle(
                              color: _isScanning ? Colors.cyan : Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom Navigation Bar (igual ao dashboard)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard),
                        label: 'Dashboard',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.assessment),
                        label: 'Relatórios',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_circle),
                        label: 'Meu Perfil',
                      ),
                    ],
                    currentIndex: 0,
                    selectedItemColor: Colors.cyan,
                    unselectedItemColor: Colors.white54,
                    backgroundColor: Colors.transparent,
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    onTap: (index) {
                      if (index == 0) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
