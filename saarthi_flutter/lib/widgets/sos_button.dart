import 'package:flutter/material.dart';

class SosButton extends StatefulWidget {
  final VoidCallback onTap;
  const SosButton({super.key, required this.onTap});

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'SOS emergency button. Long press to send distress signal.',
      child: GestureDetector(
        onLongPress: widget.onTap,
        child: SizedBox(
          width: 240, height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildRing(210, 0.0),
              _buildRing(175, 0.5),
              Container(
                width: 136, height: 136,
                decoration: const BoxDecoration(color: Color(0xFFB71C1C), shape: BoxShape.circle),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('SOS', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    Text('Hold to send', style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 0.5)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRing(double size, double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double val = (_controller.value + delay) % 1.0;
        double scale = 0.85 + (val * 0.25);
        double opacity = 0.7 * (1.0 - val);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: size, height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color.fromRGBO(229, 57, 53, opacity.clamp(0.0, 1.0)),
                width: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
