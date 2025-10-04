import 'package:flutter/material.dart';

class ParticipantsListScreen extends StatefulWidget {
  const ParticipantsListScreen({super.key});

  @override
  State<ParticipantsListScreen> createState() => _ParticipantsListScreenState();
}

class _ParticipantsListScreenState extends State<ParticipantsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Todos';

  // Lista simulada de participantes
  final List<Map<String, dynamic>> _allParticipants = [
    {
      'id': '001',
      'name': 'João Silva',
      'email': 'joao.silva@email.com',
      'accessLevel': 'Autoridade',
      'status': 'Check-in Realizado',
      'checkinTime': '08:30',
      'avatar': Icons.person,
      'statusColor': Colors.green,
    },
    {
      'id': '002',
      'name': 'Maria Santos',
      'email': 'maria.santos@email.com',
      'accessLevel': 'Delegado',
      'status': 'Pendente',
      'checkinTime': '--:--',
      'avatar': Icons.person,
      'statusColor': Colors.orange,
    },
    {
      'id': '003',
      'name': 'Carlos Oliveira',
      'email': 'carlos.oliveira@email.com',
      'accessLevel': 'Imprensa',
      'status': 'Check-in Realizado',
      'checkinTime': '09:15',
      'avatar': Icons.person,
      'statusColor': Colors.green,
    },
    {
      'id': '004',
      'name': 'Ana Costa',
      'email': 'ana.costa@email.com',
      'accessLevel': 'Observador',
      'status': 'Ausente',
      'checkinTime': '--:--',
      'avatar': Icons.person,
      'statusColor': Colors.red,
    },
    {
      'id': '005',
      'name': 'Pedro Almeida',
      'email': 'pedro.almeida@email.com',
      'accessLevel': 'Autoridade',
      'status': 'Check-in Realizado',
      'checkinTime': '07:45',
      'avatar': Icons.person,
      'statusColor': Colors.green,
    },
    {
      'id': '006',
      'name': 'Lucia Ferreira',
      'email': 'lucia.ferreira@email.com',
      'accessLevel': 'Delegado',
      'status': 'Check-in Realizado',
      'checkinTime': '08:50',
      'avatar': Icons.person,
      'statusColor': Colors.green,
    },
  ];

  List<Map<String, dynamic>> get _filteredParticipants {
    var filtered = _allParticipants.where((participant) {
      final matchesSearch =
          participant['name'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          participant['email'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesFilter =
          _selectedFilter == 'Todos' ||
          participant['status'] == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();

    return filtered;
  }

  int get _totalParticipants => _allParticipants.length;
  int get _checkedInCount =>
      _allParticipants.where((p) => p['status'] == 'Check-in Realizado').length;
  int get _pendingCount =>
      _allParticipants.where((p) => p['status'] == 'Pendente').length;

  void _showParticipantDetails(Map<String, dynamic> participant) {
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
              CircleAvatar(
                backgroundColor: Colors.cyan,
                child: Icon(participant['avatar'], color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  participant['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('ID:', participant['id']),
              _buildDetailRow('E-mail:', participant['email']),
              _buildDetailRow('Nível:', participant['accessLevel']),
              _buildDetailRow(
                'Status:',
                participant['status'],
                color: participant['statusColor'],
              ),
              _buildDetailRow('Check-in:', participant['checkinTime']),
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

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color ?? Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
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
                        'LISTA DE PARTICIPANTES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // Atualizar lista
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lista atualizada'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.cyan,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                // Estatísticas
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Total',
                        _totalParticipants.toString(),
                        Colors.cyan,
                      ),
                      _buildStatCard(
                        'Check-in',
                        _checkedInCount.toString(),
                        Colors.green,
                      ),
                      _buildStatCard(
                        'Pendente',
                        _pendingCount.toString(),
                        Colors.orange,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Barra de pesquisa
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar participante...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Filtros
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          [
                            'Todos',
                            'Check-in Realizado',
                            'Pendente',
                            'Ausente',
                          ].map((filter) {
                            final isSelected = _selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(
                                  filter,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                backgroundColor: Colors.white.withOpacity(0.1),
                                selectedColor: Colors.cyan,
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.cyan
                                      : Colors.white.withOpacity(0.3),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Lista de participantes
                Expanded(
                  child: _filteredParticipants.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'Nenhum participante encontrado'
                                    : 'Nenhum participante no filtro selecionado',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredParticipants.length,
                          itemBuilder: (context, index) {
                            final participant = _filteredParticipants[index];
                            return _buildParticipantCard(participant);
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

  Widget _buildStatCard(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantCard(Map<String, dynamic> participant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: participant['statusColor'],
          child: Icon(participant['avatar'], color: Colors.white),
        ),
        title: Text(
          participant['name'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              participant['email'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: participant['statusColor'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: participant['statusColor'],
                      width: 1,
                    ),
                  ),
                  child: Text(
                    participant['status'],
                    style: TextStyle(
                      color: participant['statusColor'],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (participant['checkinTime'] != '--:--')
                  Text(
                    participant['checkinTime'],
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white.withOpacity(0.5),
          size: 16,
        ),
        onTap: () => _showParticipantDetails(participant),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
