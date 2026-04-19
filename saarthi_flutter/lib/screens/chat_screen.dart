import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/emergency_protocol.dart';
import '../services/emergency_service.dart';
import '../utils/responsive.dart';
import '../widgets/animated_press_card.dart';
import 'assist_mode_screen.dart';
import 'action_steps_screen.dart';

import '../services/voice_service.dart';

class ChatScreen extends StatefulWidget {
  final String emergencyType;
  final bool autoStartVoice;
  const ChatScreen({super.key, required this.emergencyType, this.autoStartVoice = false});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late EmergencyService _service;
  late VoiceService _voiceService;

  @override
  void initState() {
    super.initState();
    _service = context.read<EmergencyService>();
    _voiceService = context.read<VoiceService>();
    _voiceService.initSpeech();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _service.startEmergency(widget.emergencyType);
      if (widget.autoStartVoice) {
        Future.delayed(const Duration(milliseconds: 500), _toggleVoice);
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      context.read<EmergencyService>().submitUserMessage(text);
      _inputController.clear();
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  void _toggleVoice() {
    if (_voiceService.isListening) {
      final words = _voiceService.lastWords;
      _voiceService.stopListening();
      if (words.isNotEmpty) {
        _service.submitUserMessage(words, isVoice: true);
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    } else {
      _voiceService.startListening((result) {
        // This callback is for automatic final results
        if (result.isNotEmpty && !_service.chatMessages.any((m) => m.isUser && m.text == result)) {
          _service.submitUserMessage(result, isVoice: true);
          Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<EmergencyService>();
    final voice = context.watch<VoiceService>();
    final cur = service.currentProtocol;
    final r = Responsive(context);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Responsive.constrain(
              maxWidth: r.maxContentWidth,
              child: Column(
                children: [
                  // ── Chat header ──
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding, vertical: r.vPad(12)),
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
                        const SizedBox(width: 10),
                        ExcludeSemantics(
                          child: Container(
                            width: 30, height: 30,
                            decoration: BoxDecoration(
                              color: cur?.color ?? const Color.fromRGBO(229, 57, 53, 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(child: Text(cur?.icon ?? '🚨', style: const TextStyle(fontSize: 17))),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Semantics(
                            liveRegion: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cur?.title ?? 'Emergency', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13 * r.fontScale)),
                                const Text('AI responding', style: TextStyle(fontSize: 10, color: Colors.white54)),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 7, height: 7, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                            const SizedBox(width: 5),
                            const Text('Live', style: TextStyle(fontSize: 11, color: Colors.white54)),
                            const SizedBox(width: 10),
                            // ── Severity Badge ──
                            if (service.currentSeverity > 0)
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: service.currentSeverity >= 2 ? Colors.red : Colors.orange,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('Lvl ${service.currentSeverity}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            // ── SOS Button ──
                            Semantics(
                              button: true,
                              label: 'SOS emergency button. Tap to enter Assist Mode.',
                              child: AnimatedPressCard(
                                borderRadius: BorderRadius.circular(10),
                                glowColor: const Color.fromRGBO(229, 57, 53, 0.4),
                                pressScale: 0.92,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssistModeScreen())),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: cur?.color.withOpacity(0.8) ?? const Color(0xFFB71C1C),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (cur?.color ?? const Color.fromRGBO(229, 57, 53, 0.4)).withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.warning_rounded, size: 14, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text('SOS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  // ── Messages ──
                  Expanded(
                    child: Semantics(
                      label: 'Emergency chat messages',
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding, vertical: 10),
                        itemCount: service.chatMessages.length + (service.isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == service.chatMessages.length && service.isTyping) {
                            return _buildTypingIndicator();
                          }
                          final msg = service.chatMessages[index];
                          return msg.isUser ? _buildUserMessage(msg.text, cur) : _buildAiMessage(msg.text, msg.styleClass);
                        },
                      ),
                    ),
                  ),

                  // ── High-stress banner or Critical Confirmation ──
                  if (service.requiresCriticalConfirmation)
                    _buildCriticalConfirmationCard(service)
                  else if (service.isStressHigh)
                    _buildStressBanner(),

                  // ── Input bar ──
                  Padding(
                    padding: EdgeInsets.all(r.horizontalPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Semantics(
                            textField: true,
                            label: 'Type your emergency description',
                            child: TextField(
                              controller: _inputController,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Describe what happened...',
                                hintStyle: const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: const Color(0xFF22222A),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Semantics(
                          button: true,
                          label: voice.isListening ? 'Stop listening' : 'Start voice input',
                          child: AnimatedPressCard(
                            borderRadius: BorderRadius.circular(11),
                            glowColor: voice.isListening ? Colors.red : const Color(0x18FFFFFF),
                            pressScale: 0.92,
                            onTap: _toggleVoice,
                            child: Container(
                              width: Responsive.minTouchTarget,
                              height: Responsive.minTouchTarget,
                              decoration: BoxDecoration(
                                color: voice.isListening ? Colors.red.withOpacity(0.2) : const Color(0xFF22222A),
                                border: voice.isListening ? Border.all(color: Colors.redAccent) : null,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Center(
                                child: Text(
                                  voice.isListening ? '🛑' : '🎤',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Semantics(
                          button: true,
                          label: 'Send message',
                          child: AnimatedPressCard(
                            borderRadius: BorderRadius.circular(11),
                            glowColor: const Color.fromRGBO(229, 57, 53, 0.3),
                            pressScale: 0.92,
                            onTap: _sendMessage,
                            child: Container(
                              width: Responsive.minTouchTarget,
                              height: Responsive.minTouchTarget,
                              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(11)),
                              child: const Center(child: Icon(Icons.arrow_upward, size: 18, color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Voice Overlay ──
          if (voice.isListening)
            _buildVoiceOverlay(voice),
        ],
      ),
    );
  }

  Widget _buildVoiceOverlay(VoiceService voice) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.85),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             const Text('Listening...', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
             const SizedBox(height: 20),
             Text(
               voice.lastWords.isEmpty ? 'Say something...' : voice.lastWords,
               textAlign: TextAlign.center,
               style: const TextStyle(fontSize: 18, color: Colors.white70),
             ),
             const SizedBox(height: 40),
             // Animated mic wave
             SizedBox(
               width: 100, height: 100,
               child: Stack(
                 alignment: Alignment.center,
                 children: [
                    for (int i = 1; i <= 3; i++)
                      _buildMicWave(i, voice.level),
                    const Icon(Icons.mic, size: 40, color: Colors.white),
                 ],
               ),
             ),
             const SizedBox(height: 50),
             Semantics(
               button: true,
               label: 'Finish and submit voice input',
               child: AnimatedPressCard(
                 borderRadius: BorderRadius.circular(30),
                 glowColor: Colors.white24,
                 pressScale: 0.9,
                 onTap: _toggleVoice,
                 child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(30),
                   ),
                   child: const Text('FINISH & SUBMIT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 13)),
                 ),
               ),
             ),
             const SizedBox(height: 20),
             const Text('Voice input triggers Critical Priority', style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMicWave(int index, double level) {
    // level is usually -2 to 10
    double scale = 1.0 + (level.clamp(0.0, 10.0) * 0.1 * index);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: scale),
      duration: const Duration(milliseconds: 100),
      builder: (context, val, child) {
        return Transform.scale(
          scale: val,
          child: Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3 / index)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAiMessage(String text, String styleClass) {
    Color borderColor = const Color.fromRGBO(255, 255, 255, 0.08);
    Color bgColor = const Color(0xFF18181C);

    if (styleClass == 'urg') {
      borderColor = const Color.fromRGBO(229, 57, 53, 0.45);
      bgColor = const Color.fromRGBO(229, 57, 53, 0.09);
    } else if (styleClass == 'wrn') {
      borderColor = const Color.fromRGBO(255, 143, 0, 0.45);
      bgColor = const Color.fromRGBO(255, 143, 0, 0.09);
    } else if (styleClass == 'inf') {
      borderColor = const Color.fromRGBO(21, 101, 192, 0.45);
      bgColor = const Color.fromRGBO(21, 101, 192, 0.09);
    } else if (styleClass == 'suc') {
      borderColor = const Color.fromRGBO(46, 125, 50, 0.45);
      bgColor = const Color.fromRGBO(46, 125, 50, 0.09);
    }

    return Semantics(
      label: 'Saarthi AI says: $text',
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16),
              bottomRight: Radius.circular(16), bottomLeft: Radius.circular(4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Text('SAARTHI AI', style: TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ),
              const SizedBox(height: 3),
              Text(text, style: const TextStyle(fontSize: 13, height: 1.55)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserMessage(String text, EmergencyProtocol? cur) {
    return Semantics(
      label: 'You said: $text',
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: cur?.color.withOpacity(0.8) ?? Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16), bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Semantics(
      liveRegion: true,
      label: 'Saarthi AI is typing',
      child: _buildAiMessage('...', ''),
    );
  }

  Widget _buildStressBanner() {
    return Semantics(
      liveRegion: true,
      label: 'High stress detected. Tap SOS to enter simplified Assist Mode.',
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssistModeScreen())),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Responsive(context).horizontalPadding),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(183, 28, 28, 0.85),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Row(
            children: [
              Text('⚡', style: TextStyle(fontSize: 21)),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('High stress detected', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    Text('Tap here or SOS to enter Assist Mode', style: TextStyle(fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCriticalConfirmationCard(EmergencyService service) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Responsive(context).horizontalPadding, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1818),
        border: Border.all(color: const Color.fromRGBO(229, 57, 53, 0.45), width: 1.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(229, 57, 53, 0.15), blurRadius: 12, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.redAccent, size: 22),
              SizedBox(width: 8),
              Expanded(child: Text('Critical Emergency Detected', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.redAccent))),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Do you need to dispatch emergency services immediately?', style: TextStyle(fontSize: 13, height: 1.4)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AnimatedPressCard(
                  borderRadius: BorderRadius.circular(10),
                  glowColor: const Color(0x22FFFFFF),
                  onTap: () {
                    service.clearCriticalConfirmation();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(color: const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(10)),
                    child: const Center(child: Text('NO, I\'M OKAY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedPressCard(
                  borderRadius: BorderRadius.circular(10),
                  glowColor: const Color.fromRGBO(229, 57, 53, 0.4),
                  onTap: () {
                    service.clearCriticalConfirmation();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 10),
                            Expanded(child: Text('SOS & Location Dispatched!')),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 4),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ActionStepsScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(color: const Color(0xFFE53935), borderRadius: BorderRadius.circular(10)),
                    child: const Center(child: Text('YES, DISPATCH', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
