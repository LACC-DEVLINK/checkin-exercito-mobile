import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Configurações do sistema
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _autoSync = true;
  bool _offlineMode = false;
  bool _biometricLogin = false;

  // Configurações de câmera
  String _cameraQuality = 'HD';
  bool _flashEnabled = false;
  bool _autoFocus = true;

  // Configurações de dados
  String _backupFrequency = 'Diário';
  bool _wifiOnlySync = true;

  void _showAbout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade800, Colors.cyan],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.info, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Sobre o App',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sistema Check-in COP 30',
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Versão: 1.0.0', style: TextStyle(color: Colors.white70)),
              Text(
                'Build: 2025.10.03',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 16),
              Text(
                'Aplicativo para controle de acesso inteligente em eventos. Desenvolvido para facilitar o check-in de participantes através de QR codes.',
                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar', style: TextStyle(color: Colors.cyan)),
            ),
          ],
        );
      },
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 32),
              const SizedBox(width: 12),
              const Text(
                'Resetar Configurações',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Tem certeza que deseja resetar todas as configurações para os valores padrão?\n\nEsta ação não pode ser desfeita.',
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _notificationsEnabled = true;
                  _soundEnabled = true;
                  _vibrationEnabled = true;
                  _autoSync = true;
                  _offlineMode = false;
                  _biometricLogin = false;
                  _cameraQuality = 'HD';
                  _flashEnabled = false;
                  _autoFocus = true;
                  _backupFrequency = 'Diário';
                  _wifiOnlySync = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configurações resetadas com sucesso'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                'Resetar',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  void _exportSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configurações exportadas com sucesso'),
        backgroundColor: Colors.green,
      ),
    );
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
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'CONFIGURAÇÕES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _exportSettings,
                        icon: const Icon(
                          Icons.download,
                          color: Colors.cyan,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista de configurações
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Seção Sistema
                      _buildSectionHeader('Sistema'),
                      _buildSettingCard([
                        _buildSwitchTile(
                          'Notificações',
                          'Receber notificações do sistema',
                          Icons.notifications,
                          _notificationsEnabled,
                          (value) =>
                              setState(() => _notificationsEnabled = value),
                        ),
                        _buildSwitchTile(
                          'Sons',
                          'Reproduzir sons de alerta',
                          Icons.volume_up,
                          _soundEnabled,
                          (value) => setState(() => _soundEnabled = value),
                        ),
                        _buildSwitchTile(
                          'Vibração',
                          'Vibrar em notificações',
                          Icons.vibration,
                          _vibrationEnabled,
                          (value) => setState(() => _vibrationEnabled = value),
                        ),
                      ]),

                      const SizedBox(height: 16),

                      // Seção Segurança
                      _buildSectionHeader('Segurança'),
                      _buildSettingCard([
                        _buildSwitchTile(
                          'Login Biométrico',
                          'Usar impressão digital ou Face ID',
                          Icons.fingerprint,
                          _biometricLogin,
                          (value) => setState(() => _biometricLogin = value),
                        ),
                        _buildSwitchTile(
                          'Modo Offline',
                          'Trabalhar sem conexão com internet',
                          Icons.cloud_off,
                          _offlineMode,
                          (value) => setState(() => _offlineMode = value),
                        ),
                      ]),

                      const SizedBox(height: 16),

                      // Seção Câmera
                      _buildSectionHeader('Câmera & Scanner'),
                      _buildSettingCard([
                        _buildDropdownTile(
                          'Qualidade da Câmera',
                          'Resolução para captura de QR codes',
                          Icons.camera_alt,
                          _cameraQuality,
                          ['HD', 'Full HD', '4K'],
                          (value) => setState(() => _cameraQuality = value!),
                        ),
                        _buildSwitchTile(
                          'Flash Automático',
                          'Usar flash em ambientes escuros',
                          Icons.flash_auto,
                          _flashEnabled,
                          (value) => setState(() => _flashEnabled = value),
                        ),
                        _buildSwitchTile(
                          'Foco Automático',
                          'Focar automaticamente no QR code',
                          Icons.center_focus_strong,
                          _autoFocus,
                          (value) => setState(() => _autoFocus = value),
                        ),
                      ]),

                      const SizedBox(height: 16),

                      // Seção Dados
                      _buildSectionHeader('Dados & Sincronização'),
                      _buildSettingCard([
                        _buildSwitchTile(
                          'Sincronização Automática',
                          'Sincronizar dados automaticamente',
                          Icons.sync,
                          _autoSync,
                          (value) => setState(() => _autoSync = value),
                        ),
                        _buildDropdownTile(
                          'Frequência de Backup',
                          'Quando fazer backup dos dados',
                          Icons.backup,
                          _backupFrequency,
                          ['Manual', 'Diário', 'Semanal', 'Mensal'],
                          (value) => setState(() => _backupFrequency = value!),
                        ),
                        _buildSwitchTile(
                          'Apenas Wi-Fi',
                          'Sincronizar apenas via Wi-Fi',
                          Icons.wifi,
                          _wifiOnlySync,
                          (value) => setState(() => _wifiOnlySync = value),
                        ),
                      ]),

                      const SizedBox(height: 24),

                      // Botões de ação
                      _buildSectionHeader('Ações'),
                      _buildActionCard([
                        _buildActionTile(
                          'Sobre o Aplicativo',
                          'Informações da versão e desenvolvedor',
                          Icons.info_outline,
                          Colors.cyan,
                          _showAbout,
                        ),
                        _buildActionTile(
                          'Resetar Configurações',
                          'Voltar aos valores padrão',
                          Icons.restore,
                          Colors.orange,
                          _resetSettings,
                        ),
                        _buildActionTile(
                          'Sair do Aplicativo',
                          'Fazer logout e voltar ao login',
                          Icons.exit_to_app,
                          Colors.red,
                          () {
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
                        ),
                      ]),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.cyan,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildActionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: Colors.cyan, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.cyan,
        activeTrackColor: Colors.cyan.withOpacity(0.3),
        inactiveThumbColor: Colors.white54,
        inactiveTrackColor: Colors.white24,
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    IconData icon,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: Colors.cyan, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        dropdownColor: Colors.grey.shade800,
        style: const TextStyle(color: Colors.cyan),
        underline: Container(),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon, color: color, size: 24),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: color.withOpacity(0.7),
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
