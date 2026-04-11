import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otolog/resources/colors.dart';
import 'package:otolog/widgets/otolog_logo.dart';

void main() {
  test('renders branding PNG assets', () async {
    await _renderTransparentLogo(
      outputPath: 'assets/native/otolog_splash_logo.png',
      size: 1024,
    );
    await _renderTransparentLogo(
      outputPath: 'assets/branding/otolog_logo_mark_1024.png',
      size: 1024,
    );
    await _renderAppIcon(
      outputPath: 'assets/branding/otolog_app_icon_1024.png',
    );
    await _renderStoreListing(
      outputPath: 'assets/branding/otolog_store_listing_1024x500.png',
    );
  });
}

Future<void> _renderTransparentLogo({
  required String outputPath,
  required int size,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final painter = createOtoLogLogoPainter();

  painter.paint(canvas, Size(size.toDouble(), size.toDouble()));

  await _writePicture(outputPath, recorder, width: size, height: size);
}

Future<void> _renderAppIcon({required String outputPath}) async {
  const size = 1024;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final rect = Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());
  final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(220));

  final backgroundPaint =
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, 0),
          Offset(size.toDouble(), size.toDouble()),
          [Colors.white, AppColors.primary[50]!, AppColors.neutral[50]!],
          const [0, 0.58, 1],
        );

  canvas.drawRRect(rrect, backgroundPaint);

  final haloPaint =
      Paint()
        ..style = PaintingStyle.fill
        ..color = AppColors.primary.withValues(alpha: 0.08);
  canvas.drawCircle(
    const Offset(size * 0.5, size * 0.5),
    size * 0.34,
    haloPaint,
  );

  canvas.save();
  const logoSize = 760.0;
  canvas.translate((size - logoSize) / 2, (size - logoSize) / 2);
  createOtoLogLogoPainter().paint(canvas, const Size(logoSize, logoSize));
  canvas.restore();

  await _writePicture(outputPath, recorder, width: size, height: size);
}

Future<void> _renderStoreListing({required String outputPath}) async {
  const width = 1024;
  const height = 500;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final rect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());

  final backgroundPaint =
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, 0),
          Offset(width.toDouble(), height.toDouble()),
          [Colors.white, AppColors.primary[50]!, AppColors.secondary[50]!],
          const [0, 0.6, 1],
        );
  canvas.drawRect(rect, backgroundPaint);

  final accentPaint =
      Paint()..color = AppColors.tertiary.withValues(alpha: 0.10);
  canvas.drawCircle(const Offset(860, 120), 110, accentPaint);
  canvas.drawCircle(
    const Offset(120, 430),
    140,
    Paint()..color = AppColors.primary.withValues(alpha: 0.07),
  );

  final cardRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(86, 74, 304, 304),
    const Radius.circular(56),
  );
  canvas.drawRRect(
    cardRect,
    Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
  );
  canvas.drawRRect(cardRect, Paint()..color = Colors.white);

  canvas.save();
  const logoSize = 220.0;
  canvas.translate(128, 116);
  createOtoLogLogoPainter().paint(canvas, const Size(logoSize, logoSize));
  canvas.restore();

  final panelRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(448, 78, 470, 344),
    const Radius.circular(40),
  );
  canvas.drawRRect(
    panelRect,
    Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
  );
  canvas.drawRRect(
    panelRect,
    Paint()..color = Colors.white.withValues(alpha: 0.88),
  );

  final topBarRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(486, 114, 394, 22),
    const Radius.circular(12),
  );
  canvas.drawRRect(
    topBarRect,
    Paint()..color = AppColors.neutral[900]!.withValues(alpha: 0.96),
  );

  for (final rect in const [
    Rect.fromLTWH(486, 156, 112, 18),
    Rect.fromLTWH(610, 156, 148, 18),
    Rect.fromLTWH(770, 156, 74, 18),
  ]) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      Paint()..color = AppColors.secondary[500]!.withValues(alpha: 0.88),
    );
  }

  final statCards = [
    (
      rect: const Rect.fromLTWH(486, 202, 116, 78),
      color: AppColors.primary.withValues(alpha: 0.12),
    ),
    (
      rect: const Rect.fromLTWH(620, 202, 116, 78),
      color: AppColors.secondary[100]!.withValues(alpha: 0.90),
    ),
    (
      rect: const Rect.fromLTWH(754, 202, 126, 78),
      color: AppColors.tertiary.withValues(alpha: 0.14),
    ),
  ];
  for (final card in statCards) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(card.rect, const Radius.circular(22)),
      Paint()..color = card.color,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          card.rect.left + 16,
          card.rect.top + 18,
          card.rect.width - 48,
          12,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = AppColors.neutral[900]!.withValues(alpha: 0.82),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          card.rect.left + 16,
          card.rect.top + 42,
          card.rect.width - 66,
          10,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = AppColors.neutral[500]!.withValues(alpha: 0.70),
    );
  }

  final chartArea = RRect.fromRectAndRadius(
    const Rect.fromLTWH(486, 302, 232, 88),
    const Radius.circular(24),
  );
  canvas.drawRRect(
    chartArea,
    Paint()..color = AppColors.primary[50]!.withValues(alpha: 0.95),
  );

  final chartGridPaint =
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.12)
        ..strokeWidth = 2;
  for (final y in [324.0, 348.0, 372.0]) {
    canvas.drawLine(
      const Offset(504, 0) + Offset(0, y),
      const Offset(698, 0) + Offset(0, y),
      chartGridPaint,
    );
  }

  final chartPaint =
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = AppColors.tertiary;
  final chartPath =
      Path()
        ..moveTo(516, 364)
        ..lineTo(556, 340)
        ..lineTo(590, 352)
        ..lineTo(632, 318)
        ..lineTo(684, 332);
  canvas.drawPath(chartPath, chartPaint);

  final listCard = RRect.fromRectAndRadius(
    const Rect.fromLTWH(738, 302, 142, 88),
    const Radius.circular(24),
  );
  canvas.drawRRect(
    listCard,
    Paint()..color = AppColors.neutral[100]!.withValues(alpha: 0.92),
  );
  for (final rect in const [
    Rect.fromLTWH(758, 322, 84, 12),
    Rect.fromLTWH(758, 346, 100, 12),
    Rect.fromLTWH(758, 370, 68, 12),
  ]) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      Paint()..color = AppColors.neutral[700]!.withValues(alpha: 0.88),
    );
  }

  await _writePicture(outputPath, recorder, width: width, height: height);
}

Future<void> _writePicture(
  String outputPath,
  ui.PictureRecorder recorder, {
  required int width,
  required int height,
}) async {
  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  if (byteData == null) {
    fail('Failed to render PNG bytes for $outputPath.');
  }

  final outputFile = File(outputPath);
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsBytes(byteData.buffer.asUint8List());
}
