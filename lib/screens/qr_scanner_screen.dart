import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'awaiting_authorization_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnimation;
  MobileScannerController? _scannerController;
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

    // Inicializar o controller da câmera
    _initializeScanner();
  }

  void _initializeScanner() {
    _scannerController = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture barcodeCapture) {
    final List<Barcode> barcodes = barcodeCapture.barcodes;

    if (barcodes.isNotEmpty && _isScanning) {
      setState(() {
        _isScanning = false;
      });

      _scanLineController.stop();
      HapticFeedback.lightImpact();

      final barcode = barcodes.first;
      final qrData = barcode.rawValue ?? '';

      // Criar dados do participante baseado no QR Code escaneado
      final scannedData = {
        'qrCode': qrData,
        'participantId': qrData.isNotEmpty ? qrData : '12345',
        'name': 'Rafael Lindo',
        'event': 'Evento Militar - FortAccess',
        'scanTime': DateTime.now().toString(),
      };

      // Navegar para tela de aguardando autorização
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AwaitingAuthorizationScreen(scannedData: scannedData),
        ),
      ).then((_) {
        // Quando voltar, reiniciar o scanner
        _restartScan();
      });
    }
  }

  void _restartScan() {
    setState(() {
      _isScanning = true;
    });
    _scanLineController.repeat();
  }

  void _toggleFlash() {
    _scannerController?.toggleTorch();
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
            image: AssetImage('assets/images/img-principal.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.5),
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
                        // Câmera dentro do container
                        if (_scannerController != null && _isScanning)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: MobileScanner(
                              controller: _scannerController,
                              onDetect: _onDetect,
                            ),
                          )
                        else
                          // Fundo quando não está escaneando
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white54,
                                size: 60,
                              ),
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
                                top: BorderSide(
                                  color: AppColors.lightGreen,
                                  width: 4,
                                ),
                                left: BorderSide(
                                  color: AppColors.lightGreen,
                                  width: 4,
                                ),
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
                                top: BorderSide(
                                  color: AppColors.lightGreen,
                                  width: 4,
                                ),
                                right: BorderSide(
                                  color: AppColors.lightGreen,
                                  width: 4,
                                ),
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
                                  color: AppColors.lightGreen,
                                  width: 4,
                                ),
                                left: BorderSide(
                                  color: AppColors.lightGreen,
                                  width: 4,
                                ),
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
                                  color: AppColors.lightGreen,
                                  width: 4,
                                ),
                                right: BorderSide(
                                  color: AppColors.lightGreen,
                                  width: 4,
                                ),
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
                                        AppColors.lightGreen,
                                        AppColors.lightGreen.withOpacity(0.8),
                                        AppColors.lightGreen,
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.lightGreen.withOpacity(
                                          0.5,
                                        ),
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
                    onPressed: _isScanning ? _toggleFlash : _restartScan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 4,
                    ),
                    icon: Icon(
                      _isScanning ? Icons.flash_on : Icons.refresh,
                      size: 20,
                    ),
                    label: Text(
                      _isScanning ? 'ATIVAR FLASH' : 'ESCANEAR NOVAMENTE',
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
                            color: _isScanning
                                ? AppColors.lightGreen
                                : Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isScanning
                                ? 'Procurando QR Code...'
                                : 'QR Code detectado!',
                            style: TextStyle(
                              color: _isScanning
                                  ? AppColors.lightGreen
                                  : Colors.green,
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
                    selectedItemColor: AppColors.lightGreen,
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
