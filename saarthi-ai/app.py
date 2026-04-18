from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from edge_core.executor import MedicalExecutor
from edge_core.storage import IncidentStorage
import uvicorn

app = FastAPI(title="Saarthi AI Edge Engine")

# Singleton instances for the session
executor = MedicalExecutor()
storage = IncidentStorage()

class UserInput(BaseModel):
    context: str
    panic_score: int

@app.get("/")
def read_root():
    return {"status": "Saarthi AI Edge Engine is running", "mode": "OFFLINE_READY"}

@app.post("/process")
def process_emergency(user_input: UserInput):
    """
    The main entry point for the Frontend.
    Receives parsed context from the SLM/STT and returns medical guidance.
    """
    result = executor.update(user_input.context, user_input.panic_score)
    
    # Periodic background logging (In a real app, this might happen at the end)
    if result["is_emergency"]:
        storage.log_incident(result)
        
    return result

@app.get("/status")
def get_current_status():
    """Returns the current state of the engine without moving the state machine."""
    return {
        "current_state": executor.state.value,
        "panic_level": executor.panic_level,
        "instruction": executor._get_instruction()
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
