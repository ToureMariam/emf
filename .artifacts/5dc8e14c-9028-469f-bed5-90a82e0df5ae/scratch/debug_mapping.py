import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def test(d, h, l):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
    # Mapping: [distance, height, load, 1.0, 1.0]
    features_df = pd.DataFrame([[d, h, l, 1.0, 1.0]], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
    scaled = scaler.transform(features_df)
    pred = model.predict(scaled)
    print(f"D={d}, H={h}, L={l} => B={pred[0][0]:.4f}")

if __name__ == "__main__":
    test(20, 1.5, 1) # Typical case
    test(100, 1.5, 1) # Far case
    test(5, 1.5, 1) # Close case
    test(20, 10.0, 1) # High height?
