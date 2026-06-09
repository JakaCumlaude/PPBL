import 'package:flutter/material.dart';
import 'package:tangankebaikan/screens/models/volunteer_local_model.dart';
import '../../database/db_helper.dart';
import 'volunteer_local_form_page.dart';

class VolunteerLocalListPage extends StatefulWidget {
  const VolunteerLocalListPage({super.key});

  @override
  State<VolunteerLocalListPage> createState() => _VolunteerLocalListPageState();
}

class _VolunteerLocalListPageState extends State<VolunteerLocalListPage> {
  List<VolunteerLocal> _volunteers = [];
  bool _isLoading = true;

  get DBHelper => null;

  @override
  void initState() {
    super.initState();
    _loadVolunteers();
  }

  Future<void> _loadVolunteers() async {
    setState(() => _isLoading = true);
    final data = await DBHelper.getAllVolunteers();
    setState(() {
      _volunteers = data.map((e) => VolunteerLocal.fromMap(e)).toList();
      _isLoading = false;
    });
  }

  Future<void> _delete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Relawan'),
        content: const Text('Yakin ingin menghapus data relawan ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await DBHelper.deleteVolunteer(id);
      _loadVolunteers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Relawan Lokal'),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VolunteerLocalFormPage()),
          );
          _loadVolunteers();
        },
        backgroundColor: const Color(0xFF4A90E2),
        icon: const Icon(Icons.add, color: Colors.white),
        label:
            const Text('Tambah Relawan', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _volunteers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline,
                          size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('Belum ada data relawan lokal',
                          style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadVolunteers,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: _volunteers.length,
                    itemBuilder: (context, index) {
                      final v = _volunteers[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(14),
                          leading: CircleAvatar(
                            backgroundColor:
                                const Color(0xFF4A90E2).withOpacity(0.12),
                            child: Text(
                              v.name.isNotEmpty ? v.name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                  color: Color(0xFF4A90E2),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(v.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(children: [
                                const Icon(Icons.location_on,
                                    size: 13, color: Colors.red),
                                const SizedBox(width: 4),
                                Text(v.location,
                                    style: const TextStyle(fontSize: 12)),
                              ]),
                              const SizedBox(height: 2),
                              Text(
                                v.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (val) async {
                              if (val == 'edit') {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        VolunteerLocalFormPage(volunteer: v),
                                  ),
                                );
                                _loadVolunteers();
                              } else if (val == 'delete') {
                                _delete(v.id!);
                              }
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(children: [
                                    Icon(Icons.edit, size: 18),
                                    SizedBox(width: 8),
                                    Text('Edit')
                                  ])),
                              const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(children: [
                                    Icon(Icons.delete,
                                        size: 18, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Hapus',
                                        style: TextStyle(color: Colors.red))
                                  ])),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
