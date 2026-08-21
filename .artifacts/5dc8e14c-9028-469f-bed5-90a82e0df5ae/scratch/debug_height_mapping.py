import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def test(d, rf):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
    features_df = pd.DataFrame([[d, rf, 0.178, 0.075, 0.075]], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
    scaled = scaler.transform(features_df)
    pred = model.predict(scaled)
    print(f"Dist={d}, RF={rf} => B={pred[0][0]:.4f}")

if __name__ == "__main__":
    print("Varying RF (Potential Height in cm):")
    test(20, 150) # 1.5m
    test(20, 325) # 3.25m (mean)
    test(20, 500) # 5m
