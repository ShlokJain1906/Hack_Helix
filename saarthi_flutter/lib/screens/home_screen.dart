import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/animated_press_card.dart';
import 'chat_screen.dart';
import 'medical_screen.dart';

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        Semantics(
                          button: true,
                          label: 'Notifications',
                          child: AnimatedPressCard(
                            borderRadius: BorderRadius.circular(10),
                            glowColor: const Color(0x18FFFFFF),
                            pressScale: 0.92,
                            child: Container(
                              width: Responsive.minTouchTarget,
                              height: Responsive.minTouchTarget,
                              decoration: BoxDecoration(
                                color: const Color(0xFF22222A),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(child: Text('🔔', style: TextStyle(fontSize: 15))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Tagline ──
                  Padding(
                    padding: EdgeInsets.fromLTRB(r.horizontalPadding, 2, r.horizontalPadding, r.vPad(13)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stay safe,\nwe\'re here.',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            height: 1.25,
                            fontSize: 24 * r.fontScale,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Tap an emergency or describe it below', style: Theme.of(context).textTheme.bodySmall),
                      ],
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
    return Semantics(
      button: true,
      label: 'Describe your emergency using voice or text',
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
              Icon(Icons.mic_none, color: Colors.white54, size: 18),
              SizedBox(width: 9),
              Text('Describe your emergency...', style: TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyGrid(BuildContext context, Responsive r) {
    return GridView.count(
      crossAxisCount: r.gridColumns,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: r.isDesktop ? 1.0 : (r.isTablet ? 1.1 : 1.5),
      children: [
        _buildGridCard(context, '🚗', 'accident', 'Crash · Fall · Injury', const Color.fromRGBO(229, 57, 53, 0.3), const Color.fromRGBO(229, 57, 53, 0.15), 'Accident'),
        _buildGridCard(context, '🏥', 'medical', 'Heart · Breathing · More', const Color.fromRGBO(21, 101, 192, 0.3), const Color.fromRGBO(21, 101, 192, 0.15), 'Medical', isRouteToMedical: true),
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
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(11)),
                  child: Center(child: Text(icon, style: const TextStyle(fontSize: 21))),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(sub, style: const TextStyle(fontSize: 10, color: Colors.white54)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickPrompts(BuildContext context) {
    final prompts = ['Heart attack', 'Road crash', 'Fire nearby', 'Heavy bleeding', 'Unconscious person', 'Can\'t breathe'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: prompts.map((e) {
          // Map prompt text to the correct emergency type
          const promptTypeMap = {
            'heart': 'heart', 'crash': 'accident', 'fire': 'fire',
            'bleed': 'bleeding', 'unconscious': 'unconscious', 'breathe': 'breathing',
          };
          final lo = e.toLowerCase();
          String type = 'custom';
          for (final entry in promptTypeMap.entries) {
            if (lo.contains(entry.key)) {
              type = entry.value;
              break;
            }
          }

          return Semantics(
            button: true,
            label: 'Quick prompt: $e',
            child: AnimatedPressCard(
              borderRadius: BorderRadius.circular(9),
              glowColor: const Color(0x18FFFFFF),
              pressScale: 0.94,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(emergencyType: type))),
              child: Container(
                margin: const EdgeInsets.only(right: 7),
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                constraints: const BoxConstraints(minHeight: Responsive.minTouchTarget),
                decoration: BoxDecoration(
                  color: const Color(0xFF22222A),
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(child: Text(e, style: const TextStyle(fontSize: 11))),
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
