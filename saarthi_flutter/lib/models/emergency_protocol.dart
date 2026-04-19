import 'package:flutter/material.dart';

class EmergencyActionCard {
  final String icon;
  final IconData? materialIcon;
  final String label;
  final String summary;
  final List<String> detailedSteps;
  final Color borderColor;
  final Color bgColor;

  const EmergencyActionCard({
    required this.icon,
    this.materialIcon,
    required this.label,
    this.summary = '',
    this.detailedSteps = const [],
    required this.borderColor,
    required this.bgColor,
  });
}

class EmergencyResponse {
  final String text;
  final String styleClass; // urg, wrn, inf, suc, empty string

  const EmergencyResponse({required this.text, required this.styleClass});
}

class EmergencyProtocol {
  final String id;
  final String icon;
  final String title;
  final Color color;
  final String callLabel;
  final String panicLabel;
  final String initialMsg;
  final List<EmergencyResponse> responses;
  final String timelineDesc;
  final String timelineGuidance;
  final String cardTitle;
  final String cardSub;
  final List<EmergencyActionCard> cards;
  final List<String> voiceSteps;

  const EmergencyProtocol({
    required this.id,
    required this.icon,
    required this.title,
    required this.color,
    required this.callLabel,
    required this.panicLabel,
    required this.initialMsg,
    required this.responses,
    required this.timelineDesc,
    required this.timelineGuidance,
    required this.cardTitle,
    required this.cardSub,
    required this.cards,
    required this.voiceSteps,
  });
}
