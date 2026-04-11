import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:otolog/resources/colors.dart';

class OtoLogLogo extends StatelessWidget {
  const OtoLogLogo({
    super.key,
    this.size = 148,
    this.showWordmark = false,
    this.wordmarkColor,
  });

  final double size;
  final bool showWordmark;
  final Color? wordmarkColor;

  @override
  Widget build(BuildContext context) {
    final resolvedWordmarkColor = wordmarkColor ?? AppColors.neutral[900]!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _OtoLogLogoPainter()),
        ),
        if (showWordmark) ...[
          SizedBox(height: size * 0.16),
          Text(
            'OtoLog',
            style: TextStyle(
              color: resolvedWordmarkColor,
              fontSize: size * 0.22,
              fontWeight: FontWeight.w800,
              letterSpacing: -size * 0.01,
              height: 1,
            ),
          ),
        ],
      ],
    );
  }
}

CustomPainter createOtoLogLogoPainter() => _OtoLogLogoPainter();

class _OtoLogLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.34;
    final ringStroke = size.width * 0.11;

    final primaryRingPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = ringStroke
          ..strokeCap = StrokeCap.round
          ..shader = SweepGradient(
            startAngle: _deg(-70),
            endAngle: _deg(250),
            colors: [
              AppColors.primary[700]!,
              AppColors.primary,
              AppColors.primary[300]!,
            ],
            stops: const [0.0, 0.55, 1.0],
          ).createShader(Rect.fromCircle(center: center, radius: radius));

    final ringRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(ringRect, _deg(32), _deg(296), false, primaryRingPaint);

    final hubPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white;
    canvas.drawCircle(center, radius - ringStroke * 1.15, hubPaint);

    final pulsePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.07
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = AppColors.tertiary;

    final pulse =
        Path()
          ..moveTo(size.width * 0.31, size.height * 0.53)
          ..lineTo(size.width * 0.42, size.height * 0.42)
          ..lineTo(size.width * 0.52, size.height * 0.57)
          ..lineTo(size.width * 0.65, size.height * 0.39)
          ..lineTo(size.width * 0.76, size.height * 0.50)
          ..lineTo(size.width * 0.87, size.height * 0.50);
    canvas.drawPath(pulse, pulsePaint);

    final dotPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = AppColors.tertiary;
    canvas.drawCircle(
      Offset(size.width * 0.87, size.height * 0.50),
      size.width * 0.028,
      dotPaint,
    );
  }

  double _deg(double value) => value * math.pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
