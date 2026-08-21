import joblib
import pandas as pd
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
import os
try:
    from utils import map_load_condition
except ImportError:
    from Backend.utils import map_load_condition

app = FastAPI(title="EMF SafeZone ML API", version="1.0.0")

# Enable CORS for Flutter communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False, # Must be False if allow_origins is ["*"]
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load the model on startup using absolute path
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
model = None

@app.on_event("startup")
def load_model():
    global model
    if os.path.exists(MODEL_PATH):
        try:
            model = joblib.load(MODEL_PATH)
            print(f"Model loaded successfully from {MODEL_PATH}")
        except Exception as e:
            print(f"Error loading model: {e}")
    else:
        print(f"Warning: Model file not found at {MODEL_PATH}")
        print(f"Looked in: {os.getcwd()}")

class PredictionInput(BaseModel):
    distance: float
    height: float
    load_condition: str
    model_name: str = "Random Forest"

class PredictionResult(BaseModel):
    is_compliant: bool
    magnetic_flux: float
    electric_field: float
    threshold_b: float = 0.4
    threshold_e: float = 5000.0
    classification: str
    probability: float = 1.0

@app.get("/")
def read_root():
    return {"status": "Backend is running", "model_available": model is not None}

@app.post("/predict", response_model=PredictionResult)
def predict(data: PredictionInput):
    if model is None:
        raise HTTPException(status_code=503, detail="ML Model not loaded on server")

    try:
        # Map categorical data
        load_numeric = map_load_condition(data.load_condition)

        # Prepare feature vector (5 features expected)
        # Internal mapping optimized for model training distribution:
        # [Distance, Height, Load, 1.0 (Volt Placeholder), 1.0 (Freq Placeholder)]
        features = [[
            data.distance,
            data.height,
            load_numeric,
            1.0,
            1.0
        ]]

        # Perform prediction (Model returns 2 outputs: [Magnetic_Flux (uT), Electric_Field (V/m)])
        prediction_array = model.predict(features)

        # Extract values
        predicted_b_field = float(prediction_array[0][0])
        predicted_e_field = float(prediction_array[0][1])

        # Logic: Compliant if:
        # 1. Predicted Magnetic Flux <= 0.4 µT (Precautionary)
        # 2. Predicted Electric Field <= 5000 V/m (ICNIRP)
        is_compliant = (predicted_b_field <= 0.4) and (predicted_e_field <= 5000.0)

        return PredictionResult(
            is_compliant=is_compliant,
            magnetic_flux=predicted_b_field,
            electric_field=predicted_e_field,
            classification="COMPLIANT" if is_compliant else "NON-COMPLIANT",
            probability=1.0
        )

    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

@app.get("/safe-zone")
def get_safe_zone(height: float = 1.5, load_condition: str = "Maximum-Peak"):
    if model is None:
        raise HTTPException(status_code=503, detail="ML Model not loaded on server")

    load_numeric = map_load_condition(load_condition)

    # Optimized: Predict all distances (0-100m) in a single batch
    distances = [float(d) for d in range(0, 101)]
    feature_matrix = [[d, height, load_numeric, 1.0, 1.0] for d in distances]

    # Batch inference
    predictions = model.predict(feature_matrix)

    safe_distance = 100.0
    for d, pred in enumerate(predictions):
        b = float(pred[0])
        e = float(pred[1])

        if b <= 0.4 and e <= 5000.0:
            safe_distance = float(d)
            break

    return {
        "safe_distance": safe_distance,
        "load": load_condition,
        "height": height,
        "threshold_b": 0.4
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
