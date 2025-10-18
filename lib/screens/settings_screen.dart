import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                    colors: [AppColors.primaryGreen, AppColors.lightGreen],
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
                  color: AppColors.lightGreen,
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
              child: const Text(
                'Fechar',
                style: TextStyle(color: AppColors.lightGreen),
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
                          color: AppColors.lightGreen,
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
                      // Botões de ação
                      _buildSectionHeader('Ações'),
                      _buildActionCard([
                        _buildActionTile(
                          'Sobre o Aplicativo',
                          'Informações da versão e desenvolvedor',
                          Icons.info_outline,
                          AppColors.lightGreen,
                          _showAbout,
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
          color: AppColors.lightGreen,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
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
