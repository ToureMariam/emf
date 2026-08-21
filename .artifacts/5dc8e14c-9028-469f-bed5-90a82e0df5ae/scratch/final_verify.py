import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def predict(d, h, l):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)

    # Logic from main.py:
    feature_data = [
        d,
        h * 100.0,
        0.1 + (l * 0.1),
        0.075,
        0.075
    ]
    df = pd.DataFrame([feature_data], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
    scaled = scaler.transform(df)
    pred = model.predict(scaled)
    b = pred[0][0]
    is_compliant = b <= 0.4
    print(f"Dist={d}m, H={h}m, Load={l} => B={b:.4f} uT (Compliant: {is_compliant})")

if __name__ == "__main__":
    print("Verifying Final Logic:")
    predict(20, 1.5, 1) # Expected: Compliant
    predict(5, 1.5, 1)  # Expected: Near threshold or non-compliant
    predict(50, 1.5, 1) # Expected: Compliant
    predict(20, 5.0, 2) # Higher height, Max load -> Should be higher B
