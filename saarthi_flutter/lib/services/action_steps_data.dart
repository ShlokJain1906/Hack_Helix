import 'package:flutter/material.dart';

class ActionStepDetail {
  final IconData icon;
  final String summary;
  final List<String> steps;
  const ActionStepDetail({required this.icon, required this.summary, required this.steps});
}

const Map<String, ActionStepDetail> actionStepDetails = {
  // ── Heart Attack ──
  'Start CPR': ActionStepDetail(
    icon: Icons.monitor_heart,
    summary: 'Push hard and fast on center of chest — 30 compressions, then 2 breaths.',
    steps: [
      'Place person on their back on a firm, flat surface.',
      'Put the heel of one hand on the center of the chest, other hand on top.',
      'Lock your elbows and position shoulders directly over your hands.',
      'Push hard and fast — at least 2 inches deep, 100–120 per minute.',
      'After 30 compressions, tilt head back, lift chin, give 2 rescue breaths.',
      'Continue 30:2 cycles until help arrives or person responds.',
    ],
  ),
  'Lay Flat': ActionStepDetail(
    icon: Icons.airline_seat_flat,
    summary: 'Lay the person flat on a firm surface and loosen tight clothing.',
    steps: [
      'Help the person lie flat on the ground or floor.',
      'Loosen any tight clothing — belt, tie, shirt buttons.',
      'Do not give them anything to eat or drink.',
      'If they are conscious, let them sit in a comfortable position.',
      'Monitor breathing continuously until help arrives.',
    ],
  ),
  'Give Aspirin': ActionStepDetail(
    icon: Icons.medication,
    summary: 'If conscious and not allergic, have them chew one aspirin (325 mg).',
    steps: [
      'Ask if the person is allergic to aspirin.',
      'If not allergic and they can swallow, give one adult aspirin (325 mg).',
      'Tell them to chew it slowly — do not swallow whole.',
      'Do NOT give aspirin if they are unconscious or vomiting.',
      'Continue to monitor and keep them calm until help arrives.',
    ],
  ),
  'Stay Calm': ActionStepDetail(
    icon: Icons.self_improvement,
    summary: 'Reassure the person, keep them still, and monitor their condition.',
    steps: [
      'Speak in a calm, steady voice — reassure them help is coming.',
      'Keep them still — do not let them walk or move unnecessarily.',
      'Monitor their breathing and consciousness continuously.',
      'Be ready to start CPR if they become unresponsive.',
    ],
  ),
  // ── Breathing / Choking ──
  'Back Blows': ActionStepDetail(
    icon: Icons.back_hand,
    summary: 'Bend them forward and deliver 5 firm blows between the shoulder blades.',
    steps: [
      'Stand to the side and slightly behind the person.',
      'Support their chest with one hand, bend them forward at the waist.',
      'Use the heel of your hand to give 5 firm blows between shoulder blades.',
      'Check if the object has been dislodged after each blow.',
      'If unsuccessful after 5 blows, switch to abdominal thrusts.',
    ],
  ),
  'Heimlich': ActionStepDetail(
    icon: Icons.sports_mma,
    summary: 'Wrap arms around their waist and thrust inward and upward below the ribs.',
    steps: [
      'Stand directly behind the choking person.',
      'Wrap your arms around their waist.',
      'Make a fist with one hand, place it just above the navel.',
      'Grab your fist with the other hand.',
      'Give 5 quick, inward and upward thrusts.',
      'Alternate with 5 back blows until the object is cleared.',
    ],
  ),
  'Rescue Breaths': ActionStepDetail(
    icon: Icons.air,
    summary: 'Tilt head back, lift chin, seal mouth and blow for 1 second per breath.',
    steps: [
      'Tilt the head back by lifting the chin with two fingers.',
      'Pinch the nose shut with your other hand.',
      'Create a seal over their mouth with yours.',
      'Blow steadily for about 1 second — watch the chest rise.',
      'Give 2 breaths, then continue with 30 chest compressions.',
    ],
  ),
  // ── Severe Bleeding ──
  'Apply Pressure': ActionStepDetail(
    icon: Icons.compress,
    summary: 'Press firmly on the wound with a cloth — do not release until help arrives.',
    steps: [
      'Grab any clean cloth, shirt, or bandage.',
      'Press it firmly and directly over the wound.',
      'Apply steady, continuous pressure — do NOT lift to check.',
      'If blood soaks through, add more cloth on top — do not remove the first layer.',
      'Maintain pressure until emergency services arrive.',
    ],
  ),
  'Elevate Limb': ActionStepDetail(
    icon: Icons.upload,
    summary: 'Raise the injured limb above heart level to slow bleeding.',
    steps: [
      'While maintaining pressure, raise the injured arm or leg.',
      'Elevate it above the level of the heart.',
      'Use a pillow, bag, or folded clothing to prop it up.',
      'Keep the person lying down and as still as possible.',
    ],
  ),
  'Bandage Tight': ActionStepDetail(
    icon: Icons.healing,
    summary: 'Wrap a firm bandage over the dressing to hold pressure in place.',
    steps: [
      'Once initial bleeding slows, wrap a bandage tightly over the cloth.',
      'Wind it firmly but not so tight it cuts off circulation.',
      'Secure the end with a knot or tape.',
      'Check fingers/toes below the bandage for colour and warmth.',
    ],
  ),
  "Don't Release": ActionStepDetail(
    icon: Icons.do_not_touch,
    summary: 'Never remove a blood-soaked dressing — always add more layers on top.',
    steps: [
      'If the first cloth soaks through, do NOT remove it.',
      'Place a fresh cloth directly on top and press again.',
      'Removing the first layer breaks clots and restarts bleeding.',
      'Keep adding layers and maintain firm pressure.',
    ],
  ),
  // ── Unconscious Person ──
  'Check Response': ActionStepDetail(
    icon: Icons.record_voice_over,
    summary: 'Shout their name and tap both shoulders firmly to check for response.',
    steps: [
      'Kneel beside the person and shout "Can you hear me?"',
      'Tap both shoulders firmly.',
      'If no response, call emergency services immediately.',
      'Check for no more than 10 seconds before acting.',
    ],
  ),
  'Check Breathing': ActionStepDetail(
    icon: Icons.visibility,
    summary: 'Tilt head back, lift chin, and look for chest movement for 10 seconds.',
    steps: [
      'Tilt the head back gently by lifting the chin.',
      'Place your ear near their mouth and nose.',
      'Look at the chest for rise and fall.',
      'Listen and feel for breath for no more than 10 seconds.',
      'If not breathing normally, begin CPR immediately.',
    ],
  ),
  'Recovery Position': ActionStepDetail(
    icon: Icons.airline_seat_recline_normal,
    summary: 'Roll them onto their side to keep the airway open and prevent choking.',
    steps: [
      'Kneel beside the person, straighten their legs.',
      'Place the arm nearest you at a right angle to their body.',
      'Bring the far arm across and hold the back of their hand against their cheek.',
      'Pull the far knee up, then roll them towards you onto their side.',
      'Tilt head back to keep airway open, monitor breathing continuously.',
    ],
  ),
  // ── Road Accident ──
  "Don't Move": ActionStepDetail(
    icon: Icons.do_not_step,
    summary: 'Never move an injured person — risk of spinal cord damage.',
    steps: [
      'Do NOT move the injured person unless there is immediate danger (fire, explosion).',
      'Moving someone with a spinal injury can cause paralysis.',
      'Support their head and neck in the position you found them.',
      'Wait for trained paramedics to arrive and move them safely.',
    ],
  ),
  'Stop Bleeding': ActionStepDetail(
    icon: Icons.bloodtype,
    summary: 'Apply firm direct pressure to any visible wound with available cloth.',
    steps: [
      'Find any clean cloth or clothing.',
      'Press it firmly against the bleeding wound.',
      'Do not release — maintain constant pressure.',
      'If possible, elevate the limb above heart level.',
      'Keep pressing until paramedics take over.',
    ],
  ),
  'Warn Traffic': ActionStepDetail(
    icon: Icons.warning_amber,
    summary: 'Turn on hazard lights and place warning triangles to alert oncoming traffic.',
    steps: [
      'Turn on the vehicle hazard lights immediately.',
      'If available, place a warning triangle 50m behind the vehicle.',
      'If at night, use your phone flashlight to signal traffic.',
      'Do not stand in the road — stay to the side.',
    ],
  ),
  // ── Fire Emergency ──
  'Evacuate Now': ActionStepDetail(
    icon: Icons.exit_to_app,
    summary: 'Leave the building immediately through the nearest exit — take nothing.',
    steps: [
      'Stop what you are doing and leave immediately.',
      'Use the nearest marked exit — do not use elevators.',
      'Close doors behind you as you leave to slow the fire.',
      'Move to the designated assembly point outside.',
      'Do NOT re-enter the building for any reason.',
    ],
  ),
  'Stay Low': ActionStepDetail(
    icon: Icons.height,
    summary: 'Crawl below the smoke — cleaner air is within 30 cm of the floor.',
    steps: [
      'Drop to your hands and knees immediately.',
      'Crawl towards the nearest exit.',
      'Smoke and toxic gases rise — breathable air is near the floor.',
      'Cover your nose and mouth with a wet cloth if possible.',
    ],
  ),
  'No Elevator': ActionStepDetail(
    icon: Icons.elevator,
    summary: 'Never use elevators in a fire — they can trap you or open on the fire floor.',
    steps: [
      'Always use the stairs during a fire emergency.',
      'Elevators may lose power and trap you inside.',
      'Elevator shafts can fill with smoke rapidly.',
      'The elevator may open directly on the floor that is on fire.',
    ],
  ),
  'Cover Mouth': ActionStepDetail(
    icon: Icons.masks,
    summary: 'Breathe through a damp cloth to filter smoke and toxic particles.',
    steps: [
      'Grab any cloth — towel, shirt, handkerchief.',
      'Wet it with water if available.',
      'Hold it firmly over your nose and mouth.',
      'Breathe through the cloth as you crawl to the exit.',
    ],
  ),
  // ── Crime / Threat ──
  'Move Away': ActionStepDetail(
    icon: Icons.directions_run,
    summary: 'If there is a safe escape route, leave the area immediately.',
    steps: [
      'If you can see a clear, safe path away from the threat, take it.',
      'Leave your belongings behind — your life is the priority.',
      'Help others escape if it does not put you at risk.',
      'Keep your hands visible when you encounter police.',
      'Do not stop running until you are in a safe location.',
    ],
  ),
  'Note Location': ActionStepDetail(
    icon: Icons.location_on,
    summary: 'Memorize street name, landmarks, and details for the police report.',
    steps: [
      'Note the exact street name or address.',
      'Identify nearby landmarks — shops, signs, intersections.',
      'Remember the time when the incident occurred.',
      'If safe, note the appearance and clothing of any suspects.',
    ],
  ),
  'Stay Silent': ActionStepDetail(
    icon: Icons.volume_off,
    summary: 'If hiding, silence your phone completely and remain absolutely still.',
    steps: [
      'Silence your phone — turn off vibration and sounds.',
      'Lock and barricade the door if possible.',
      'Turn off lights and stay away from windows.',
      'Remain absolutely still and quiet.',
      'Wait for police to give the all-clear before moving.',
    ],
  ),
  // ── Custom / Generic ──
  'Call 112': ActionStepDetail(
    icon: Icons.phone,
    summary: 'Dial 112 immediately and describe your emergency clearly.',
    steps: [
      'Dial 112 (or your local emergency number).',
      'State your location clearly — address, landmarks.',
      'Describe the emergency — what happened, how many people.',
      'Follow the operator instructions — do not hang up.',
    ],
  ),
  'Share Location': ActionStepDetail(
    icon: Icons.share_location,
    summary: 'Share your GPS location with emergency contacts.',
    steps: [
      'Open your phone location/maps app.',
      'Share your live location with emergency contacts.',
      'If on a call with 112, describe nearby landmarks.',
    ],
  ),
  'Get Help': ActionStepDetail(
    icon: Icons.people,
    summary: 'Alert nearby people and ask for specific help.',
    steps: [
      'Shout for help — be specific: "You, call an ambulance!"',
      'Point at a specific person to avoid bystander effect.',
      'Ask someone to meet the ambulance and guide them to you.',
    ],
  ),
};
