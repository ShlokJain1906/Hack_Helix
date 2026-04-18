import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/emergency_service.dart';
import '../utils/responsive.dart';
import '../widgets/animated_press_card.dart';
import 'timeline_screen.dart';

class ActionStepsScreen extends StatelessWidget {
  const ActionStepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cur = context.watch<EmergencyService>().currentProtocol;
    final r = Responsive(context);

    return Scaffold(
      body: SafeArea(
        child: Responsive.constrain(
          maxWidth: r.maxContentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: EdgeInsets.fromLTRB(r.horizontalPadding, r.vPad(20), r.horizontalPadding, r.vPad(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                    Semantics(
                      button: true,
                      label: 'View incident timeline',
                      child: AnimatedPressCard(
                        borderRadius: BorderRadius.circular(10),
                        glowColor: const Color(0x18FFFFFF),
                        pressScale: 0.92,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimelineScreen())),
                        child: Container(
                          width: Responsive.minTouchTarget,
                          height: Responsive.minTouchTarget,
                          decoration: BoxDecoration(color: const Color(0xFF22222A), borderRadius: BorderRadius.circular(10)),
                          child: const Center(child: Icon(Icons.timeline, size: 18, color: Colors.white70)),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // ── Title ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding, vertical: r.vPad(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cur?.cardTitle ?? 'Take Action Now', style: TextStyle(fontSize: 17 * r.fontScale, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(cur?.cardSub ?? 'Follow these steps', style: const TextStyle(fontSize: 11, color: Colors.white54)),
                  ],
                ),
              ),

              // ── Action cards grid ──
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(r.horizontalPadding),
                  crossAxisCount: r.gridColumns,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: cur?.cards.map((e) => _buildCard(context, e.icon, e.label, e.borderColor, e.bgColor)).toList() ?? [],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String icon, String label, Color borderColor, Color bgColor) {
    return Semantics(
      label: 'Action: $label',
      child: AnimatedPressCard(
        borderRadius: BorderRadius.circular(19),
        glowColor: borderColor,
        pressScale: 0.95,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(19),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15)),
                  child: Center(child: Text(icon, style: const TextStyle(fontSize: 27))),
                ),
              ),
              const SizedBox(height: 9),
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
