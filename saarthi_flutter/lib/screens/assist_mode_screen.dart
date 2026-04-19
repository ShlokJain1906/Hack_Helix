import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/emergency_service.dart';
import '../utils/responsive.dart';
import '../widgets/animated_press_card.dart';
import '../widgets/sos_button.dart';
import 'action_steps_screen.dart';
import 'sos_sent_screen.dart';
import 'timeline_screen.dart';
import 'voice_guidance_screen.dart';

class AssistModeScreen extends StatelessWidget {
  const AssistModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cur = context.read<EmergencyService>().currentProtocol;
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0608),
      body: SafeArea(
        child: Responsive.constrain(
          maxWidth: r.maxContentWidth,
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding: EdgeInsets.fromLTRB(r.horizontalPadding, r.vPad(20), r.horizontalPadding, r.vPad(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Semantics(
                      button: true,
                      label: 'Go back to home',
                      child: AnimatedPressCard(
                        borderRadius: BorderRadius.circular(10),
                        glowColor: const Color(0x18FFFFFF),
                        pressScale: 0.92,
                        onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                        child: Container(
                          width: Responsive.minTouchTarget,
                          height: Responsive.minTouchTarget,
                          decoration: BoxDecoration(color: const Color(0xFF22222A), borderRadius: BorderRadius.circular(10)),
                          child: const Center(child: Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white70)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Semantics(
                      header: true,
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(text: 'Saar'),
                            TextSpan(text: 'thi', style: const TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                    ),
                    Semantics(
                      label: 'Current mode: Assist, ${cur?.title ?? "Emergency"}',
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(229, 57, 53, 0.2),
                          border: Border.all(color: const Color.fromRGBO(229, 57, 53, 0.4)),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          'ASSIST — ${cur?.title.toUpperCase() ?? "EMERGENCY"}',
                          style: const TextStyle(fontSize: 10, color: Color(0xFFFF5252), fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // ── SOS button ──
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SosButton(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SosSentScreen()));
                      },
                    ),
                    SizedBox(height: r.vPad(38)),
                    const Text('Simplified mode active', style: TextStyle(fontSize: 12, color: Colors.white54)),
                    const SizedBox(height: 4),
                    Semantics(
                      liveRegion: true,
                      child: Text(cur?.panicLabel ?? '● High stress detected', style: const TextStyle(color: Color(0xFFE53935), fontSize: 11)),
                    ),
                  ],
                ),
              ),

              // ── Action buttons ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding, vertical: r.vPad(14)),
                child: Column(
                  children: [
                    _buildActionBtn(context, Icons.local_hospital, cur?.callLabel ?? 'Call Ambulance', const Color.fromRGBO(229, 57, 53, 0.15), const Color.fromRGBO(229, 57, 53, 0.25), () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ActionStepsScreen()));
                    }),
                    SizedBox(height: r.vPad(9)),
                    _buildActionBtn(context, Icons.location_on, 'Share Location', const Color.fromRGBO(21, 101, 192, 0.15), const Color.fromRGBO(21, 101, 192, 0.25), () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TimelineScreen()));
                    }),
                    SizedBox(height: r.vPad(9)),
                    _buildActionBtn(context, Icons.mic, 'Start Voice Guidance', const Color.fromRGBO(46, 125, 50, 0.15), const Color.fromRGBO(46, 125, 50, 0.25), () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const VoiceGuidanceScreen()));
                    }),
                  ],
                ),
              ),
              _buildBottomNav(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionBtn(BuildContext context, IconData icon, String label, Color iconBg, Color glowColor, VoidCallback onTap) {
    return Semantics(
      button: true,
      label: label,
      child: AnimatedPressCard(
        borderRadius: BorderRadius.circular(15),
        glowColor: glowColor,
        pressScale: 0.97,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
          constraints: const BoxConstraints(minHeight: Responsive.minTouchTarget),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.08)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                child: Center(child: Icon(icon, size: 20, color: Colors.white70)),
              ),
              const SizedBox(width: 13),
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        if (index == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
        // index 1 = current screen (Emergency)
        // index 2 = Profile (not yet implemented)
      },
      items: const [
        BottomNavigationBarItem(icon: Text('🏠', style: TextStyle(fontSize: 16)), label: 'Home'),
        BottomNavigationBarItem(icon: Text('🚨', style: TextStyle(fontSize: 16)), label: 'Emergency'),
        BottomNavigationBarItem(icon: Text('👤', style: TextStyle(fontSize: 16)), label: 'Profile'),
      ],
    );
  }
}
