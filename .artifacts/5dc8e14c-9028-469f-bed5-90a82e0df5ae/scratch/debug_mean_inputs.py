import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def test(d):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
    # Using MEANS from the scaler to see if it becomes compliant
    # [distance, 325.4, 0.178, 0.075, 0.075]
    features_df = pd.DataFrame([[d, 325.4, 0.178, 0.075, 0.075]], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
    scaled = scaler.transform(features_df)
    pred = model.predict(scaled)
    print(f"Dist={d} => B={pred[0][0]:.4f}, E={pred[0][1]:.4f}")

if __name__ == "__main__":
    print("Testing with Mean Inputs:")
    test(5)
    test(20)
    test(50)
    test(100)
