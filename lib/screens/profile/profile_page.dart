import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/profile_model.dart';
import '../home/splash_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryBlue = const Color(0xFF4A90E2);

  late Future<Profile> _profileFuture;

  final String baseUrl = "https://6950dbe970e1605a1088a896.mockapi.io/profile";
  String getUserLevel(int points) {
    if (points >= 3000) return "Platinum";
    if (points >= 2000) return "Gold";
    if (points >= 1000) return "Silver";
    return "Bronze";
  }

  @override
  void initState() {
    super.initState();
    _profileFuture = fetchProfile();
  }

  Future<Profile> fetchProfile() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);

      if (data.isEmpty) {
        throw Exception("Data profil kosong");
      }

      return Profile.fromJson(data.first);
    }

    throw Exception("Gagal memuat profil");
  }

  Future<void> updateProfile(
    String id,
    String name,
    String role,
  ) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "name": name,
        "role": role,
      }),
    );

    if (res.statusCode == 200) {
      setState(() {
        _profileFuture = fetchProfile();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil berhasil diperbarui"),
        ),
      );
    }
  }

  void showEditDialog(Profile profile) {
    final nameController = TextEditingController(text: profile.name);

    final roleController = TextEditingController(text: profile.role);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Profil"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: "Peran",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              await updateProfile(
                profile.id,
                nameController.text,
                roleController.text,
              );

              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: FutureBuilder<Profile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final profile = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(profile),
                const SizedBox(height: 80),
                _buildStatCards(profile),
                _buildRewardCard(profile),
                _buildBadgeCard(),
                _buildAccountInfo(profile),
                _buildDonationHistory(),
                const SizedBox(height: 10),
                _buildProfileMenu(
                  Icons.edit_outlined,
                  "Edit Profil",
                  () => showEditDialog(profile),
                ),
                _buildProfileMenu(
                  Icons.card_giftcard,
                  "Reward Saya",
                  () {},
                ),
                _buildProfileMenu(
                  Icons.history,
                  "Riwayat Aktivitas",
                  () {},
                ),
                _buildProfileMenu(
                  Icons.settings,
                  "Pengaturan",
                  () {},
                ),
                _buildProfileMenu(
                  Icons.logout_rounded,
                  "Keluar",
                  () => _showLogoutDialog(context),
                  isLogout: true,
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(Profile profile) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 230,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4A90E2),
                Color(0xFF357ABD),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        Positioned(
          bottom: -70,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 65,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.workspace_premium,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profile.role,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards(Profile profile) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _statCard(
            Icons.favorite,
            profile.donation.toString(),
            "Donasi",
          ),
          const SizedBox(width: 10),
          _statCard(
            Icons.people,
            profile.volunteer.toString(),
            "Relawan",
          ),
          const SizedBox(width: 10),
          _statCard(
            Icons.stars,
            profile.points.toString(),
            "Poin",
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    IconData icon,
    String value,
    String title,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: primaryBlue,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard(Profile profile) {
    double progress = profile.points / 1000;

    if (progress > 1) {
      progress = 1;
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Progress Reward",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Level ${getUserLevel(profile.points)}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 5),
          Text(
            "Sisa ${(1000 - profile.points).clamp(0, 1000)} poin menuju level berikutnya",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Badge Pengguna",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Chip(
                avatar: const Icon(
                  Icons.workspace_premium,
                  color: Colors.amber,
                ),
                label: const Text(
                  "Donatur Aktif",
                ),
              ),
              Chip(
                avatar: Icon(
                  Icons.volunteer_activism,
                  color: primaryBlue,
                ),
                label: const Text(
                  "Relawan Aktif",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(Profile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Akun",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: primaryBlue,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(profile.name),
              ),
            ],
          ),
          const Divider(height: 25),
          Row(
            children: [
              Icon(
                Icons.work_outline,
                color: primaryBlue,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(profile.role),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonationHistory() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Riwayat Donasi Terakhir",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 15),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: primaryBlue.withOpacity(0.1),
              child: Icon(
                Icons.inventory_2,
                color: primaryBlue,
              ),
            ),
            title: const Text(
              "Baju Layak Pakai",
            ),
            subtitle: const Text(
              "15 Mei 2026",
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: primaryBlue.withOpacity(0.1),
              child: Icon(
                Icons.chair,
                color: primaryBlue,
              ),
            ),
            title: const Text(
              "Kursi Roda",
            ),
            subtitle: const Text(
              "01 Mei 2026",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenu(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              (isLogout ? Colors.red : primaryBlue).withOpacity(0.1),
          child: Icon(
            icon,
            color: isLogout ? Colors.red : primaryBlue,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Konfirmasi Keluar",
        ),
        content: const Text(
          "Yakin ingin keluar dari akun?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const SplashScreen(),
                ),
                (_) => false,
              );
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }
}
