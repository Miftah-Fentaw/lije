import 'package:flutter/material.dart';

class AnimatedBabyIcon extends StatefulWidget {
  const AnimatedBabyIcon({super.key});

  @override
  State<AnimatedBabyIcon> createState() => _AnimatedBabyIconState();
}

class _AnimatedBabyIconState extends State<AnimatedBabyIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _float;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    _float = Tween<double>(begin: -4, end: 4)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _glow = Tween<double>(begin: 0.3, end: 0.7)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Transform.translate(
          offset: Offset(0, _float.value),
          child: Stack(alignment: Alignment.center, children: [
            Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white.withOpacity(_glow.value),
                        blurRadius: 18,
                        spreadRadius: 4)
                  ],
                )),
            Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15))),
            SizedBox(
                width: 52,
                height: 52,
                child: CustomPaint(painter: BabyPainter())),
            Positioned(
                top: 4,
                right: 4,
                child: Text('💕',
                    style: TextStyle(fontSize: 10 + _float.value * 0.1))),
          ]),
        ),
      );
}

class BabyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.white.withOpacity(0.95);
    canvas.drawCircle(
        Offset(s.width * 0.5, s.height * 0.32), s.width * 0.2, paint);
    final body = Path();
    body.moveTo(s.width * 0.5, s.height * 0.50);
    body.cubicTo(s.width * 0.72, s.height * 0.53, s.width * 0.74,
        s.height * 0.76, s.width * 0.5, s.height * 0.79);
    body.cubicTo(s.width * 0.26, s.height * 0.76, s.width * 0.28,
        s.height * 0.53, s.width * 0.5, s.height * 0.50);
    canvas.drawPath(body, paint);
    paint
      ..color = Colors.white.withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final leftArm = Path();
    leftArm.moveTo(s.width * 0.36, s.height * 0.52);
    leftArm.quadraticBezierTo(
        s.width * 0.22, s.height * 0.48, s.width * 0.28, s.height * 0.38);
    canvas.drawPath(leftArm, paint);
    final rightArm = Path();
    rightArm.moveTo(s.width * 0.64, s.height * 0.52);
    rightArm.quadraticBezierTo(
        s.width * 0.78, s.height * 0.48, s.width * 0.72, s.height * 0.38);
    canvas.drawPath(rightArm, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
