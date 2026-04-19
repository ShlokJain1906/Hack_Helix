import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/animated_press_card.dart';
import 'chat_screen.dart';
import 'medical_screen.dart';
import '../services/offline_inference.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      body: SafeArea(
        child: Responsive.constrain(
          maxWidth: r.maxContentWidth,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // ── Header ──
                  Padding(
                    padding: EdgeInsets.fromLTRB(r.horizontalPadding, r.vPad(20), r.horizontalPadding, r.vPad(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                  ),

                  // ── Tagline ──
                  Padding(
                    padding: EdgeInsets.fromLTRB(r.horizontalPadding, 2, r.horizontalPadding, r.vPad(13)),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Stay safe,\nwe\'re here.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            height: 1.25,
                            fontSize: 24 * r.fontScale,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap an emergency or describe it below', 
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    ),
                  ),

                  // ── Scrollable content ──
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
                      children: [
                        _buildSearchBox(context),
                        SizedBox(height: r.vPad(18)),
                        Semantics(
                          label: 'Emergency type selection',
                          child: Text('EMERGENCY TYPE', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1, color: Colors.white54)),
                        ),
                        SizedBox(height: r.vPad(10)),
                        _buildEmergencyGrid(context, r),
                        SizedBox(height: r.vPad(18)),
                        Text('QUICK PROMPTS', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1, color: Colors.white54)),
                        SizedBox(height: r.vPad(10)),
                        _buildQuickPrompts(context),
                        SizedBox(height: r.vPad(10)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            button: true,
            label: 'Describe your emergency using text',
            child: AnimatedPressCard(
              borderRadius: BorderRadius.circular(15),
              glowColor: const Color(0x10FFFFFF),
              pressScale: 0.98,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen(emergencyType: 'custom'))),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.edit_note, color: Colors.white54, size: 18),
                    SizedBox(width: 9),
                    Text('Describe emergency...', style: TextStyle(color: Colors.white54, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Semantics(
          button: true,
          label: 'Describe your emergency using voice',
          child: AnimatedPressCard(
            borderRadius: BorderRadius.circular(15),
            glowColor: const Color.fromRGBO(21, 101, 192, 0.4),
            pressScale: 0.95,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen(emergencyType: 'custom', autoStartVoice: true))),
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                   BoxShadow(color: const Color(0xFF1565C0).withOpacity(0.3), blurRadius: 10, spreadRadius: 0),
                ],
              ),
              child: const Icon(Icons.mic, color: Colors.white, size: 22),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyGrid(BuildContext context, Responsive r) {
    return GridView.count(
      crossAxisCount: r.gridColumns,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: r.isDesktop ? 1.0 : (r.isTablet ? 0.95 : 0.9),
      children: [
        _buildGridCard(context, '🚗', 'accident', 'Crash · Fall · Injury', const Color.fromRGBO(229, 57, 53, 0.3), const Color.fromRGBO(229, 57, 53, 0.15), 'Accident'),
        _buildGridCard(context, '🩺', 'medical', 'Heart · Asthma · Poison · More', const Color.fromRGBO(21, 101, 192, 0.3), const Color.fromRGBO(21, 101, 192, 0.15), 'Medical', isRouteToMedical: true),
        _buildGridCard(context, '🔥', 'fire', 'House · Smoke · Burns', const Color.fromRGBO(255, 143, 0, 0.3), const Color.fromRGBO(255, 143, 0, 0.15), 'Fire'),
        _buildGridCard(context, '🚨', 'crime', 'Theft · Assault · Unsafe', const Color.fromRGBO(46, 125, 50, 0.3), const Color.fromRGBO(46, 125, 50, 0.15), 'Crime / Threat'),
      ],
    );
  }

  Widget _buildGridCard(BuildContext context, String icon, String id, String sub, Color borderColor, Color bgColor, String title, {bool isRouteToMedical = false}) {
    return Semantics(
      button: true,
      label: '$title emergency. $sub',
      child: AnimatedPressCard(
        borderRadius: BorderRadius.circular(18),
        glowColor: borderColor,
        pressScale: 0.95,
        onTap: () {
          if (isRouteToMedical) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicalScreen()));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(emergencyType: id)));
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text(icon, style: const TextStyle(fontSize: 22))),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(sub, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.white54, height: 1.2)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickPrompts(BuildContext context) {
    final prompts = [
      {'text': 'Heart attack', 'lvl': 3, 'type': 'heart'},
      {'text': 'Road crash', 'lvl': 2, 'type': 'accident'},
      {'text': 'Fire nearby', 'lvl': 2, 'type': 'fire'},
      {'text': 'Heavy bleeding', 'lvl': 3, 'type': 'bleeding'},
      {'text': 'Unconscious person', 'lvl': 3, 'type': 'unconscious'},
      {'text': 'Can\'t breathe, choking, difficulty in breathing', 'lvl': 3, 'type': 'breathing'},
      {'text': 'Asthma attack', 'lvl': 2, 'type': 'asthma'},
      {'text': 'Minor scratch', 'lvl': 0, 'type': 'minor_ailment'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: prompts.map((p) {
          final text = p['text'] as String;
          final severity = p['lvl'] as int;
          final type = p['type'] as String;
          
          // Determine badge color
          final badgeColor = severity == 3 ? Colors.red : (severity == 2 ? Colors.orange : (severity == 1 ? Colors.yellow : Colors.green));

          return Semantics(
            button: true,
            label: 'Quick prompt: $text (Severity Level $severity)',
            child: AnimatedPressCard(
              borderRadius: BorderRadius.circular(9),
              glowColor: badgeColor.withOpacity(0.1),
              pressScale: 0.94,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(emergencyType: type))),
              child: Container(
                margin: const EdgeInsets.only(right: 7),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF22222A),
                  border: Border.all(color: badgeColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Lvl $severity', style: TextStyle(color: badgeColor, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text(text, style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          // Emergency tab → go to chat with custom emergency
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen(emergencyType: 'custom')));
        }
        // index 0 = Home (already here)
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
