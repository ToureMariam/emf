import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def check(d, h, load):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
    f = [d, h, load, 0.075, 0.075]
    df = pd.DataFrame([f], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
    p = model.predict(scaler.transform(df))[0][0]
    print(f"Dist={d}m, H={h}, Load={load:.2f} => B={p:.4f} uT")

if __name__ == "__main__":
    check(10, 150, 0.30)
    check(5, 150, 0.30)
