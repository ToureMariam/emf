import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def test(d, x):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
    # distance, rf_strength (mean), x_component, y_component (mean), z_component (mean)
    features_df = pd.DataFrame([[d, 325.4, x, 0.075, 0.075]], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
    scaled = scaler.transform(features_df)
    pred = model.predict(scaled)
    print(f"Dist={d}, X={x} => B={pred[0][0]:.4f}")

if __name__ == "__main__":
    print("Varying X (potential load mapping):")
    test(20, 0.1)
    test(20, 0.2)
    test(20, 0.3)
