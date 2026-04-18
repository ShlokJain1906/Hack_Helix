import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/animated_press_card.dart';
import 'assist_mode_screen.dart';
import 'timeline_screen.dart';

class SosSentScreen extends StatelessWidget {
  const SosSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      body: SafeArea(
        child: Responsive.constrain(
          maxWidth: r.maxContentWidth,
          child: Column(
            children: [
              // ── Back button → goes to Assist screen ──
              Padding(
                padding: EdgeInsets.fromLTRB(r.horizontalPadding, r.vPad(20), r.horizontalPadding, r.vPad(12)),
                child: Row(
                  children: [
                    Semantics(
                      button: true,
                      label: 'Return to Assist mode',
                      child: AnimatedPressCard(
                        borderRadius: BorderRadius.circular(10),
                        glowColor: const Color(0x18FFFFFF),
                        pressScale: 0.92,
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const AssistModeScreen()),
                        ),
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
                      child: Text('Emergency Alert', style: TextStyle(fontSize: 15 * r.fontScale, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(r.horizontalPadding + 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Semantics(
                        liveRegion: true,
                        label: 'SOS has been sent. Emergency services have been notified.',
                        child: Column(
                          children: [
                            const ExcludeSemantics(child: Text('🚨', style: TextStyle(fontSize: 58))),
                            SizedBox(height: r.vPad(15)),
                            Text('SOS Sent', style: TextStyle(fontSize: 23 * r.fontScale, fontWeight: FontWeight.bold)),
                            SizedBox(height: r.vPad(15)),
                            const Text(
                              'Emergency services notified.\nYour location has been shared.\nHelp is on the way.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, color: Colors.white54, height: 1.8),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: r.vPad(15)),
                      Semantics(
                        label: 'Estimated time of arrival: approximately 4 minutes',
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(46, 125, 50, 0.1),
                            border: Border.all(color: const Color.fromRGBO(46, 125, 50, 0.3)),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('ETA', style: TextStyle(fontSize: 11, color: Color(0xFF66BB6A), fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                              const SizedBox(height: 2),
                              Text('~4 min', style: TextStyle(fontSize: 25 * r.fontScale, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: r.vPad(15)),
                      Semantics(
                        button: true,
                        label: 'View incident timeline',
                        child: AnimatedPressCard(
                          borderRadius: BorderRadius.circular(15),
                          glowColor: const Color(0x10FFFFFF),
                          pressScale: 0.97,
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TimelineScreen()));
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            constraints: const BoxConstraints(minHeight: Responsive.minTouchTarget),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.08)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(child: Text('View Timeline →', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                      SizedBox(height: r.vPad(15)),
                      Semantics(
                        button: true,
                        label: 'Return to home screen',
                        child: AnimatedPressCard(
                          borderRadius: BorderRadius.circular(15),
                          glowColor: const Color(0x10FFFFFF),
                          pressScale: 0.97,
                          onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            constraints: const BoxConstraints(minHeight: Responsive.minTouchTarget),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 0.06),
                              border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.08)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(child: Text('🏠 Return to Home', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
