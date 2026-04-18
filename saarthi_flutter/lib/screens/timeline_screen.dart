import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/emergency_service.dart';
import '../utils/responsive.dart';
import '../widgets/animated_press_card.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cur = context.watch<EmergencyService>().currentProtocol;
    final r = Responsive(context);

    return Scaffold(
      body: SafeArea(
        child: Responsive.constrain(
          maxWidth: r.maxContentWidth,
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding: EdgeInsets.fromLTRB(r.horizontalPadding, r.vPad(20), r.horizontalPadding, r.vPad(12)),
                child: Row(
                  children: [
                    Semantics(
                      button: true,
                      label: 'Return to home',
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
                    const SizedBox(width: 15),
                    Semantics(
                      header: true,
                      child: Text('Incident Timeline', style: TextStyle(fontSize: 15 * r.fontScale, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              // ── Timeline ──
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
                  children: [
                    const Text('April 18 — Active emergency', style: TextStyle(fontSize: 12, color: Colors.white54)),
                    SizedBox(height: r.vPad(14)),
                    _buildTimelineItem('8:41 PM', 'Emergency reported', cur?.timelineDesc ?? 'Detection logic', Icons.warning_amber, const Color.fromRGBO(229, 57, 53, 0.15), true),
                    _buildTimelineItem('8:42 PM', 'Stress detected', 'Switching to Assist Mode', Icons.flash_on, const Color.fromRGBO(255, 143, 0, 0.15), true),
                    _buildTimelineItem('8:43 PM', 'SOS sent', 'Location shared — services dispatched', Icons.cell_tower, const Color.fromRGBO(229, 57, 53, 0.15), true),
                    _buildTimelineItem('8:44 PM', cur?.timelineGuidance ?? 'Guidance started', 'Step-by-step instructions active', Icons.mic, const Color.fromRGBO(21, 101, 192, 0.15), true),
                    _buildTimelineItem('8:47 PM', 'Help arrived', 'Emergency resolved — 6 min response', Icons.check_circle, const Color.fromRGBO(46, 125, 50, 0.15), false, titleColor: const Color(0xFF66BB6A)),

                    SizedBox(height: r.vPad(20)),
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
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.08)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(child: Text('Return to Home', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String time, String title, String sub, IconData icon, Color iconBg, bool showConnector, {Color? titleColor}) {
    return Semantics(
      label: '$time: $title. $sub',
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: Center(child: Icon(icon, size: 14, color: Colors.white70)),
                ),
                if (showConnector) Expanded(child: Container(width: 1, color: Colors.white12, margin: const EdgeInsets.symmetric(vertical: 5)))
              ],
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(time, style: const TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    const SizedBox(height: 2),
                    Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: titleColor ?? Colors.white)),
                    const SizedBox(height: 1),
                    Text(sub, style: const TextStyle(fontSize: 11, color: Colors.white54)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
