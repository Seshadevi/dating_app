import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class Particle {
  final double angle; // direction in radians
  final double velocity;
  final double radiusStart;
  final double radiusEnd;
  final double sizeMin;
  final double sizeMax;
  final double rotationStart;
  final double rotationEnd;
  final Paint paint;
  final double startDelay; // 0.0 to 1.0

  Particle({
    required this.angle,
    required this.velocity,
    required this.radiusStart,
    required this.radiusEnd,
    required this.sizeMin,
    required this.sizeMax,
    required this.rotationStart,
    required this.rotationEnd,
    required this.paint,
    required this.startDelay,
  });
}

class HeartBlastPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final List<Particle> particles;

  HeartBlastPainter({
    required this.progress,
    required this.particles,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw pulsating glow
    final glowRadius = 40 + 80 * (0.5 + 0.5 * sin(progress * 2 * pi));
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.redAccent.withOpacity(0.6),
          Colors.transparent,
        ],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: glowRadius));

    canvas.drawCircle(center, glowRadius, glowPaint);

    // Draw heart outline progressively
    final heartPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    Path heartPath = Path();
    double w = size.width;
    double h = size.height;
    heartPath.moveTo(w / 2, h * 0.9);
    heartPath.cubicTo(
      w * 0.1,
      h * 0.6,
      w * 0.1,
      h * 0.3,
      w * 0.35,
      h * 0.2,
    );
    heartPath.cubicTo(
      w * 0.5,
      h * 0.2,
      w * 0.5,
      h * 0.45,
      w * 0.5,
      h * 0.45,
    );
    heartPath.cubicTo(
      w * 0.5,
      h * 0.45,
      w * 0.5,
      h * 0.2,
      w * 0.65,
      h * 0.2,
    );
    heartPath.cubicTo(
      w * 0.9,
      h * 0.3,
      w * 0.9,
      h * 0.6,
      w / 2,
      h * 0.9,
    );

    PathMetrics metrics = heartPath.computeMetrics();
    for (var metric in metrics) {
      final length = metric.length;
      final drawLength = length * progress;
      final extractPath = metric.extractPath(0, drawLength);
      canvas.drawPath(extractPath, heartPaint);
    }

    // Draw particles (small hearts) with independent timings and motions
    for (var particle in particles) {
      final localProgress = ((progress - particle.startDelay) / particle.velocity).clamp(0.0, 1.0);
      if(localProgress <= 0) continue;

      final radius = lerpDouble(particle.radiusStart, particle.radiusEnd, localProgress)!;
      final size = lerpDouble(particle.sizeMin, particle.sizeMax, 1 - localProgress)!;
      final rotation = lerpDouble(particle.rotationStart, particle.rotationEnd, localProgress)!;

      final position = Offset(
        center.dx + radius * cos(particle.angle),
        center.dy + radius * sin(particle.angle),
      );

      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(rotation);
      _drawHeart(canvas, size, particle.paint.color.withOpacity(1 - localProgress));
      canvas.restore();
    }
  }

  void _drawHeart(Canvas canvas, double size, Color color) {
    Paint paint = Paint()..color = color;
    Path path = Path();

    path.moveTo(0, size * 0.33);
    path.cubicTo(-size * 0.32, size * 0.06, -size * 0.48, -size * 0.4, 0, -size * 0.66);
    path.cubicTo(size * 0.48, -size * 0.4, size * 0.32, 0.06, 0, size * 0.33);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HeartBlastPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.particles != particles;
  }
}

class HeartShiningAnimation extends StatefulWidget {
  final double size;
  const HeartShiningAnimation({this.size = 220, Key? key}) : super(key: key);

  @override
  _HeartShiningAnimationState createState() => _HeartShiningAnimationState();
}

class _HeartShiningAnimationState extends State<HeartShiningAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> particles;
  final int particleCount = 12;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 4))..repeat();

    final random = Random();
    particles = List.generate(particleCount, (index) {
      return Particle(
        angle: random.nextDouble() * 2 * pi,
        velocity: random.nextDouble() * 0.5 + 0.5,
        radiusStart: 40,
        radiusEnd: random.nextDouble() * 50 + 100,
        sizeMin: 6,
        sizeMax: 10,
        rotationStart: random.nextDouble() * 2 * pi,
        rotationEnd: random.nextDouble() * 2 * pi,
        paint: Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.fill,
        startDelay: random.nextDouble(),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: HeartBlastPainter(progress: _controller.value, particles: particles),
    );
  }
}
