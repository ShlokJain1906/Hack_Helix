import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/emergency_service.dart';
import '../services/action_steps_data.dart';
import '../utils/responsive.dart';
import '../widgets/animated_press_card.dart';
import 'timeline_screen.dart';

class ActionStepsScreen extends StatefulWidget {
  const ActionStepsScreen({super.key});

  @override
  State<ActionStepsScreen> createState() => _ActionStepsScreenState();
}

class _ActionStepsScreenState extends State<ActionStepsScreen> {
  String? _expandedCard;

  @override
  Widget build(BuildContext context) {
    final service = context.watch<EmergencyService>();
    final cur = service.currentProtocol;
    final r = Responsive(context);
    final isSevere = service.currentSeverity >= 2;

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
                                TextSpan(text: 'thi', style: const TextStyle(color: Colors.green)),
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

              // ── Action cards list ──
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding, vertical: 8),
                  children: cur?.cards.map((card) {
                    final detail = actionStepDetails[card.label];
                    final isExpanded = _expandedCard == card.label;
                    return _buildExpandableCard(context, card.icon, card.label, card.borderColor, card.bgColor, detail, isExpanded, isSevere);
                  }).toList() ?? [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableCard(BuildContext context, String emoji, String label, Color borderColor, Color bgColor, ActionStepDetail? detail, bool isExpanded, bool isSevere) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedPressCard(
        borderRadius: BorderRadius.circular(16),
        glowColor: borderColor,
        pressScale: 0.97,
        onTap: () {
          setState(() {
            _expandedCard = isExpanded ? null : label;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // ── Card header ──
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: isSevere && detail?.icon != null
                            ? Icon(detail!.icon, size: 22, color: Colors.white)
                            : Text(emoji, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          if (detail != null && detail.summary.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(detail.summary, style: const TextStyle(fontSize: 11, color: Colors.white54, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                            ),
                        ],
                      ),
                    ),
                    Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.white54, size: 20),
                  ],
                ),
              ),
              // ── Expanded steps ──
              if (isExpanded && detail != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Column(
                    children: [
                      const Divider(color: Color(0x22FFFFFF), height: 1),
                      const SizedBox(height: 10),
                      ...detail.steps.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 22, height: 22,
                                decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(6)),
                                child: Center(child: Text('${entry.key + 1}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 12, height: 1.45, color: Colors.white70))),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
