import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../../widgets/donation_progress_card.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = ModalRoute.of(context)!.settings.arguments as Project;

    final collected = int.tryParse(p.collected.toString()) ?? 0;
    final target = int.tryParse(p.target.toString()) ?? 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Proyek"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              p.image,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    " ${p.location}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Divider(height: 40),

                  const Text(
                    "Progres Penggalangan Dana",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  // ✅ DonationProgressCard — CustomPainter + gesture onLongPress
                  DonationProgressCard(
                    title: p.title,
                    collected: collected,
                    target: target,
                    color: const Color(0xFF4A90E2),
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    p.description,
                    style: const TextStyle(height: 1.5, color: Colors.black87),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(
                          context, '/donation-form',
                          arguments: p),
                      child: const Text(
                        "Donasi Sekarang",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
