import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def check(d, load):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)

    # Feature 0: Distance
    # Feature 1: Height (325 mean)
    # Feature 2: Load (0.17 mean, 0.34 max tested)
    # Feature 3, 4: 0.07 mean

    f = [d, 325, load, 0.075, 0.075]
    df = pd.DataFrame([f], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
    p = model.predict(scaler.transform(df))[0][0]
    print(f"Dist={d}m, Load={load:.2f} => B={p:.4f} uT")

if __name__ == "__main__":
    print("Testing for distance where B > 0.4 uT:")
    for d in [0, 2, 5, 10, 20]:
        check(d, 0.34) # Max load
