import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/animated_press_card.dart';
import 'chat_screen.dart';

class MedicalScreen extends StatelessWidget {
  const MedicalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      body: SafeArea(
        child: Responsive.constrain(
          maxWidth: r.maxContentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── App bar ──
              Padding(
                padding: EdgeInsets.fromLTRB(r.horizontalPadding, r.vPad(20), r.horizontalPadding, r.vPad(12)),
                child: Row(
                  children: [
                    _buildBackButton(context),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Medical Emergency',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16 * r.fontScale,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding, vertical: r.vPad(10)),
                child: Text('CHOOSE THE SITUATION', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1, color: Colors.white54)),
              ),

              // ── Sub-type list ──
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
                  children: [
                    _buildSubCard(context, r, '❤️', 'heart', 'Heart Attack', 'Chest pain, arm pain, sweating', const Color.fromRGBO(229, 57, 53, 0.3), const Color.fromRGBO(229, 57, 53, 0.15)),
                    SizedBox(height: r.vPad(9)),
                    _buildSubCard(context, r, '😮‍💨', 'breathing', 'Breathing Issue', 'Choking, asthma, can\'t breathe', const Color.fromRGBO(255, 143, 0, 0.3), const Color.fromRGBO(255, 143, 0, 0.15)),
                    SizedBox(height: r.vPad(9)),
                    _buildSubCard(context, r, '🩸', 'bleeding', 'Severe Bleeding', 'Deep cut, wound, blood loss', const Color.fromRGBO(183, 28, 28, 0.3), const Color.fromRGBO(183, 28, 28, 0.15)),
                    SizedBox(height: r.vPad(9)),
                    _buildSubCard(context, r, '🫥', 'unconscious', 'Unconscious Person', 'Collapsed, unresponsive, fainted', const Color.fromRGBO(21, 101, 192, 0.3), const Color.fromRGBO(21, 101, 192, 0.15)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Semantics(
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
          decoration: BoxDecoration(
            color: const Color(0xFF22222A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(child: Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white70)),
        ),
      ),
    );
  }

  Widget _buildSubCard(BuildContext context, Responsive r, String icon, String id, String title, String sub, Color borderColor, Color bgColor) {
    return Semantics(
      button: true,
      label: '$title. $sub',
      child: AnimatedPressCard(
        borderRadius: BorderRadius.circular(15),
        glowColor: borderColor,
        pressScale: 0.97,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(emergencyType: id)));
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          constraints: const BoxConstraints(minHeight: 72),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(icon, style: const TextStyle(fontSize: 22))),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 14 * r.fontScale, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(sub, style: const TextStyle(fontSize: 11, color: Colors.white54)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}
