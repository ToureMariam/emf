import joblib
import pandas as pd
import numpy as np
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def search():
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)

    # Try different distances
    for d in [0, 10, 50, 100, 200, 500]:
        features_df = pd.DataFrame([[d, 1.5, 1, 1, 1]], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
        scaled = scaler.transform(features_df)
        pred = model.predict(scaled)
        b = pred[0][0]
        print(f"Dist={d} => B={b:.4f}")

    print("\nTry varying RF Strength (Feature 2):")
    for rf in [0, 0.1, 0.5, 1.0, 5.0, 10.0]:
        features_df = pd.DataFrame([[20, rf, 1, 1, 1]], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
        scaled = scaler.transform(features_df)
        pred = model.predict(scaled)
        b = pred[0][0]
        print(f"RF={rf} => B={b:.4f}")

if __name__ == "__main__":
    search()
