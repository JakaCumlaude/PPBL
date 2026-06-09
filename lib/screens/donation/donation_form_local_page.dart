import 'package:flutter/material.dart';
import 'package:tangankebaikan/screens/models/donation_model.dart';
import '../../database/db_helper.dart';
import '../../models/donation_model.dart';

class DonationFormLocalPage extends StatefulWidget {
  final Donation? donation;

  const DonationFormLocalPage({super.key, this.donation});

  @override
  State<DonationFormLocalPage> createState() => _DonationFormLocalPageState();
}

class _DonationFormLocalPageState extends State<DonationFormLocalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _amountC = TextEditingController();
  final _noteC = TextEditingController();

  String _selectedMethod = 'Transfer Bank (BCA)';
  String _selectedStatus = 'Menunggu';
  bool _isLoading = false;

  final List<String> _methods = [
    'Transfer Bank (BCA)',
    'Transfer Bank (BRI)',
    'E-Wallet (OVO/Dana)',
    'QRIS',
  ];

  final List<String> _statuses = [
    'Menunggu',
    'Dikonfirmasi',
    'Ditolak',
  ];

  bool get _isEdit => widget.donation != null;

  get DBHelper => null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _nameC.text = widget.donation!.donorName;
      _amountC.text = widget.donation!.amount.toString();
      _noteC.text = widget.donation!.note;
      _selectedMethod = widget.donation!.paymentMethod.isNotEmpty
          ? widget.donation!.paymentMethod
          : _methods.first;
      _selectedStatus = widget.donation!.status;
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _amountC.dispose();
    _noteC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final donation = Donation(
      id: widget.donation?.id,
      donorName: _nameC.text.trim(),
      amount: int.tryParse(_amountC.text.trim()) ?? 0,
      paymentMethod: _selectedMethod,
      note: _noteC.text.trim(),
      proofImage: widget.donation?.proofImage ?? '',
      status: _selectedStatus,
      createdAt: widget.donation?.createdAt ?? DateTime.now().toIso8601String(),
    );

    if (_isEdit) {
      await DBHelper.updateDonation(donation.id!, donation.toMap());
    } else {
      await DBHelper.insertDonation(donation.toMap());
    }

    setState(() => _isLoading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF4A90E2);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Donasi' : 'Tambah Donasi'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nama Donatur',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameC,
                      decoration: _inputDecoration('Masukkan nama lengkap'),
                      validator: (v) =>
                          v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Jumlah Donasi (Rp)',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountC,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Contoh: 50000'),
                      validator: (v) {
                        if (v!.isEmpty) return 'Jumlah tidak boleh kosong';
                        if (int.tryParse(v) == null) return 'Masukkan angka';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Metode Pembayaran',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedMethod,
                      decoration: _inputDecoration(''),
                      items: _methods
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedMethod = v!),
                    ),
                    if (_isEdit) ...[
                      const SizedBox(height: 16),
                      const Text('Status',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: _inputDecoration(''),
                        items: _statuses
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedStatus = v!),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text('Catatan / Doa',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _noteC,
                      maxLines: 3,
                      decoration:
                          _inputDecoration('Tulis doa atau pesan (opsional)'),
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
                          _isEdit ? 'Simpan Perubahan' : 'Simpan Donasi',
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
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
}
