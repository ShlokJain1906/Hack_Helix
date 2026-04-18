from enum import Enum
from typing import Dict, List, Optional
import time

class EmergencyState(Enum):
    IDLE = "IDLE"
    ASSESS_SAFETY = "ASSESS_SAFETY"
    CHECK_RESPONSIVENESS = "CHECK_RESPONSIVENESS"
    CALL_911 = "CALL_911"
    CHECK_PULSE = "CHECK_PULSE"
    CPR_ACTIVE = "CPR_ACTIVE"
    AED_GUIDANCE = "AED_GUIDANCE"
    RESOLVED = "RESOLVED"

class MedicalExecutor:
    def __init__(self):
        self.state = EmergencyState.IDLE
        self.start_time = None
        self.history: List[Dict] = []
        self.panic_level = 0
        self.logs = []

    def update(self, context: str, panic_score: int) -> Dict:
        """
        The deterministic brain. Takes AI context and panic score, 
        returns the NEXT step and the UI Instruction.
        """
        self.panic_level = panic_score
        
        # Determine UI Adaptation Level (Track 4.2)
        ui_adaptation = "GREEN"
        if panic_score > 4: ui_adaptation = "YELLOW"
        if panic_score > 7: ui_adaptation = "RED"  # HERO MODE

        # State Transition Logic
        if self.state == EmergencyState.IDLE:
            if context in ["cardiac", "collapsed", "unresponsive"]:
                self.state = EmergencyState.ASSESS_SAFETY
                self.start_time = time.time()

        elif self.state == EmergencyState.ASSESS_SAFETY:
            if "safe" in context or "yes" in context:
                self.state = EmergencyState.CHECK_RESPONSIVENESS

        elif self.state == EmergencyState.CHECK_RESPONSIVENESS:
            if "unresponsive" in context or "no reaction" in context:
                self.state = EmergencyState.CALL_911

        elif self.state == EmergencyState.CALL_911:
            if "called" in context or "911 contacted" in context:
                self.state = EmergencyState.CHECK_PULSE

        elif self.state == EmergencyState.CHECK_PULSE:
            if "no pulse" in context or "not breathing" in context:
                self.state = EmergencyState.CPR_ACTIVE

        # Log the transition
        self.logs.append({
            "timestamp": time.time(),
            "state": self.state.value,
            "panic": panic_score,
            "context": context
        })

        return {
            "current_state": self.state.value,
            "instruction": self._get_instruction(),
            "ui_mode": ui_adaptation,
            "is_emergency": self.state != EmergencyState.IDLE
        }

    def _get_instruction(self) -> str:
        """Returns the medically certified instructions for the current state."""
        instructions = {
            EmergencyState.IDLE: "Monitoring for cardiac emergencies...",
            EmergencyState.ASSESS_SAFETY: "Is the environment safe? Look for traffic, fire, or hazards.",
            EmergencyState.CHECK_RESPONSIVENESS: "Tap their shoulders and shout 'Are you okay?'.",
            EmergencyState.CALL_911: "They are unresponsive. CALL 911 immediately. Tell them you have a cardiac arrest.",
            EmergencyState.CHECK_PULSE: "Check for breathing and a pulse for 10 seconds. Place fingers on the neck side.",
            EmergencyState.CPR_ACTIVE: "START CPR. Push hard and fast in the center of the chest. 100-120 compressions per minute.",
            EmergencyState.AED_GUIDANCE: "AED has arrived. Follow its voice prompts immediately.",
            EmergencyState.RESOLVED: "Professional help has arrived. Hand over the patient."
        }
        return instructions.get(self.state, "Keep following current steps.")

if __name__ == "__main__":
    # Small test loop
    executor = MedicalExecutor()
    print(executor.update("collapsed", 3))
    print(executor.update("safe", 5))
    print(executor.update("unresponsive", 9)) # Should trigger RED mode
