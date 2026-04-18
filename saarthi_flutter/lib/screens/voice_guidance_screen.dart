import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/emergency_service.dart';
import '../utils/responsive.dart';
import '../widgets/animated_press_card.dart';
import 'action_steps_screen.dart';

class VoiceGuidanceScreen extends StatefulWidget {
  const VoiceGuidanceScreen({super.key});

  @override
  State<VoiceGuidanceScreen> createState() => _VoiceGuidanceScreenState();
}

class _VoiceGuidanceScreenState extends State<VoiceGuidanceScreen> with SingleTickerProviderStateMixin {
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
    final service = context.watch<EmergencyService>();
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFF080A10),
      body: SafeArea(
        child: Responsive.constrain(
          maxWidth: r.maxContentWidth,
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding: EdgeInsets.fromLTRB(r.horizontalPadding, r.vPad(20), r.horizontalPadding, r.vPad(10)),
                child: Row(
                  children: [
                    Semantics(
                      button: true,
                      label: 'Go back',
                      child: AnimatedPressCard(
                        borderRadius: BorderRadius.circular(10),
                        glowColor: const Color(0x18FFFFFF),
                        pressScale: 0.92,
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: Responsive.minTouchTarget,
                          height: Responsive.minTouchTarget,
                          decoration: BoxDecoration(color: const Color(0xFF22222A), borderRadius: BorderRadius.circular(10)),
                          child: const Center(child: Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white70)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Semantics(
                      header: true,
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(text: 'Saar'),
                            TextSpan(text: 'thi', style: TextStyle(color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Animated mic ──
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Semantics(
                      button: true,
                      label: 'Voice guidance microphone. Tap to hear next instruction.',
                      child: GestureDetector(
                        onTap: () => service.nextVoiceStep(),
                        child: SizedBox(
                          width: 200, height: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildWave(174, 0.8),
                              _buildWave(134, 0.4),
                              _buildWave(96, 0.0),
                              Container(
                                width: 76, height: 76,
                                decoration: const BoxDecoration(color: Color(0xFF1565C0), shape: BoxShape.circle),
                                child: const Center(child: Icon(Icons.mic, size: 32, color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: r.vPad(24)),
                    Text('Tell me what happened', style: TextStyle(fontSize: 17 * r.fontScale, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('Tap mic to cycle guidance', style: TextStyle(fontSize: 12, color: Colors.white54)),
                  ],
                ),
              ),

              // ── Current instruction ──
              Semantics(
                liveRegion: true,
                label: 'Current guidance step: ${service.currentVoiceInstruction}',
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: const Color.fromRGBO(21, 101, 192, 0.3)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        service.currentVoiceInstruction,
                        key: ValueKey(service.currentVoiceInstruction),
                        style: TextStyle(fontSize: 14 * r.fontScale),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Action steps link ──
              Padding(
                padding: EdgeInsets.fromLTRB(r.horizontalPadding, r.vPad(14), r.horizontalPadding, r.vPad(16)),
                child: Semantics(
                  button: true,
                  label: 'See step-by-step actions',
                  child: AnimatedPressCard(
                    borderRadius: BorderRadius.circular(15),
                    glowColor: const Color(0x10FFFFFF),
                    pressScale: 0.97,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActionStepsScreen())),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      constraints: const BoxConstraints(minHeight: Responsive.minTouchTarget),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.08)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(child: Text('See step-by-step actions →', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWave(double size, double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double val = (_controller.value + delay) % 1.0;
        double scale = 0.8 + (val * 0.4);
        double opacity = 0.8 * (1.0 - val);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: size, height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color.fromRGBO(21, 101, 192, opacity.clamp(0.0, 1.0)),
                width: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
