import 'package:flutter/material.dart';
import 'dart:math' as math;

// Custom Painter untuk menggambar arc progress donasi
class _DonutPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0
  final Color trackColor;
  final Color fillColor;
  final double strokeWidth;

  _DonutPainter({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
    this.strokeWidth = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Lingkaran track (background)
    canvas.drawCircle(center, radius, trackPaint);

    // Arc progres — mulai dari atas (-90 derajat)
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Widget utama — DonationProgressCard
// Menggunakan GestureDetector dengan onLongPress (gesture tambahan)
// dan CustomPainter untuk menggambar donut chart
class DonationProgressCard extends StatefulWidget {
  final String title;
  final int collected;
  final int target;
  final Color color;

  const DonationProgressCard({
    super.key,
    required this.title,
    required this.collected,
    required this.target,
    this.color = const Color(0xFF4A90E2),
  });

  @override
  State<DonationProgressCard> createState() => _DonationProgressCardState();
}

class _DonationProgressCardState extends State<DonationProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnim;
  bool _showDetail = false;

  @override
  void initState() {
    super.initState();
    final ratio = widget.target > 0 ? widget.collected / widget.target : 0.0;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _progressAnim = Tween<double>(begin: 0, end: ratio.clamp(0.0, 1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatRupiah(int value) {
    return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    final percent =
        widget.target > 0 ? (widget.collected / widget.target * 100) : 0.0;

    return GestureDetector(
      // onTap: toggle detail singkat
      onTap: () => setState(() => _showDetail = !_showDetail),
      // onLongPress: gesture tambahan — reset dan ulangi animasi
      onLongPress: () {
        _controller.reset();
        _controller.forward();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Animasi diulang'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Donut chart dengan CustomPainter
                SizedBox(
                  width: 90,
                  height: 90,
                  child: AnimatedBuilder(
                    animation: _progressAnim,
                    builder: (_, __) => CustomPaint(
                      painter: _DonutPainter(
                        progress: _progressAnim.value,
                        trackColor: widget.color.withOpacity(0.15),
                        fillColor: widget.color,
                      ),
                      child: Center(
                        child: Text(
                          '${percent.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(
                          'Terkumpul',
                          'Rp ${_formatRupiah(widget.collected)}',
                          widget.color),
                      const SizedBox(height: 6),
                      _infoRow('Target', 'Rp ${_formatRupiah(widget.target)}',
                          Colors.grey),
                      if (_showDetail) ...[
                        const SizedBox(height: 6),
                        _infoRow(
                            'Sisa',
                            'Rp ${_formatRupiah((widget.target - widget.collected).clamp(0, widget.target))}',
                            Colors.orange),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _showDetail
                  ? 'Ketuk untuk sembunyikan • Tahan untuk animasi ulang'
                  : 'Ketuk untuk detail • Tahan untuk animasi ulang',
              style: TextStyle(fontSize: 11, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: valueColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
