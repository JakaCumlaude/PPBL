import 'package:flutter/material.dart';

class QuickMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const QuickMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF4A90E2);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Center(),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
