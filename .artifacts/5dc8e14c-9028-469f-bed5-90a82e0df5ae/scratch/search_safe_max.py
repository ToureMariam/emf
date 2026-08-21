import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def get_b(d):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
    f = [d, 150, 0.5, 0.25, 0.25]
    df = pd.DataFrame([f], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
    return model.predict(scaler.transform(df))[0][0]

if __name__ == "__main__":
    for d in range(0, 201, 20):
        print(f"Dist={d}m => B={get_b(d):.4f}")
