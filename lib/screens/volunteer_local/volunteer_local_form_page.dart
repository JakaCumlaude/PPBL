import 'package:flutter/material.dart';
import 'package:tangankebaikan/screens/models/volunteer_local_model.dart';
import '../../database/db_helper.dart';
import 'package:tangankebaikan/models/volunteer_local_model.dart';

class VolunteerLocalFormPage extends StatefulWidget {
  final VolunteerLocal? volunteer;

  const VolunteerLocalFormPage({super.key, this.volunteer});

  @override
  State<VolunteerLocalFormPage> createState() => _VolunteerLocalFormPageState();
}

class _VolunteerLocalFormPageState extends State<VolunteerLocalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _descC = TextEditingController();
  final _locationC = TextEditingController();
  final _imageC = TextEditingController();
  final _linkC = TextEditingController();
  bool _isLoading = false;

  bool get _isEdit => widget.volunteer != null;

  get DBHelper => null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _nameC.text = widget.volunteer!.name;
      _descC.text = widget.volunteer!.description;
      _locationC.text = widget.volunteer!.location;
      _imageC.text = widget.volunteer!.image;
      _linkC.text = widget.volunteer!.registrationLink;
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _descC.dispose();
    _locationC.dispose();
    _imageC.dispose();
    _linkC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final data = VolunteerLocal(
      id: widget.volunteer?.id,
      name: _nameC.text.trim(),
      description: _descC.text.trim(),
      location: _locationC.text.trim(),
      image: _imageC.text.trim(),
      registrationLink: _linkC.text.trim(),
    );

    if (_isEdit) {
      await DBHelper.updateVolunteer(data.id!, data.toMap());
    } else {
      await DBHelper.insertVolunteer(data.toMap());
    }

    setState(() => _isLoading = false);
    if (mounted) Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
    );
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF4A90E2);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Relawan' : 'Tambah Relawan'),
        centerTitle: true,
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameC,
                      decoration: _inputDecoration(
                          'Nama Kegiatan', 'Contoh: Relawan Pendidikan'),
                      validator: (v) =>
                          v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _locationC,
                      decoration: _inputDecoration('Lokasi', 'Contoh: Bandung'),
                      validator: (v) =>
                          v!.isEmpty ? 'Lokasi tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _descC,
                      maxLines: 3,
                      decoration: _inputDecoration(
                          'Deskripsi', 'Jelaskan kegiatan relawan...'),
                      validator: (v) =>
                          v!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _imageC,
                      decoration: _inputDecoration(
                          'URL Gambar (opsional)', 'https://...'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _linkC,
                      decoration: _inputDecoration(
                          'Link Pendaftaran (opsional)',
                          'https://forms.gle/...'),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          _isEdit ? 'Simpan Perubahan' : 'Simpan Relawan',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
