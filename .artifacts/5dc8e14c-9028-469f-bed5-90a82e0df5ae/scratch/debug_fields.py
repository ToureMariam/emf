import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def test(d, rf):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
    features_df = pd.DataFrame([[d, rf, 1, 1, 1]], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
    scaled = scaler.transform(features_df)
    pred = model.predict(scaled)
    print(f"D={d}, RF={rf} => B={pred[0][0]:.4f}, E={pred[0][1]:.4f}")

if __name__ == "__main__":
    test(1, 1)
    test(50, 1)
    test(100, 1)
    test(1, 0)
    test(100, 0)
